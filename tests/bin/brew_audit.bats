bats_require_minimum_version 1.5.0

load "../test_helper"

# ---------------------------------------------------------------------------
# Setup / teardown
# ---------------------------------------------------------------------------

setup() {
  _setup_common

  BREWFILE_DIR="${TEST_TMPDIR}/dotfiles"
  mkdir -p "${BREWFILE_DIR}"

  # Brewfile tracks git and wget; NOT fzf
  cat > "${BREWFILE_DIR}/Brewfile.test" <<'EOF'
## Formulae
brew "git" # Distributed revision control system
brew "wget" # Internet file retriever
EOF

  # Mock brew bundle dump: reports git and fzf installed (not wget)
  cat > "${TEST_TMPDIR}/mock_bin/brew" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "bundle" && "$2" == "dump" ]]; then
  # Find the --file= argument and write to it
  for arg in "$@"; do
    if [[ "$arg" == "--file="* ]]; then
      outfile="${arg#--file=}"
      cat > "${outfile}" <<DUMP
# Distributed revision control system
brew "git"
# Fuzzy finder
brew "fzf"
DUMP
      exit 0
    fi
  done
fi
exit 0
EOF
  chmod +x "${TEST_TMPDIR}/mock_bin/brew"
}

teardown() {
  _teardown_common
}

invoke() {
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    DOTFILES_ROOT="${BREWFILE_DIR}" \
    "${DOTFILES_BIN}/brew_audit" "$@"
}

# ---------------------------------------------------------------------------
# Early-exit validation
# ---------------------------------------------------------------------------

@test "brew_audit: fails when no Brewfiles found" {
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    DOTFILES_ROOT="${TEST_TMPDIR}/empty" \
    "${DOTFILES_BIN}/brew_audit"
  [ "${status}" -ne 0 ]
}

@test "brew_audit: fails when --all and type-specific flags both given" {
  invoke --all --formulae
  [ "${status}" -ne 0 ]
}

@test "brew_audit: fails when --file given with empty value" {
  invoke --file=
  [ "${status}" -ne 0 ]
}

@test "brew_audit: --help exits 0 and prints usage" {
  invoke --help
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"Usage"* ]] || {
    echo "Expected usage output, got: ${output}"; return 1
  }
}

# ---------------------------------------------------------------------------
# Diff output
# ---------------------------------------------------------------------------

@test "brew_audit: marks installed-but-not-tracked packages with +" {
  invoke
  [ "${status}" -eq 0 ]
  # fzf is installed but not in any Brewfile → should appear with +
  [[ "${output}" == *"+ brew"*"fzf"* ]] || [[ "${output}" == *"fzf"*"+"* ]] || {
    echo "Expected fzf with + status, got: ${output}"; return 1
  }
}

@test "brew_audit: marks tracked-but-not-installed packages with -" {
  invoke
  [ "${status}" -eq 0 ]
  # wget is in Brewfile but not in dump → should appear with -
  [[ "${output}" == *"- brew"*"wget"* ]] || [[ "${output}" == *"wget"*"-"* ]] || {
    echo "Expected wget with - status, got: ${output}"; return 1
  }
}

@test "brew_audit: does not flag packages present in both sets" {
  invoke
  [ "${status}" -eq 0 ]
  # git appears in both installed dump and Brewfile — should not appear in output
  # (it will appear in stats but not the diff list)
  # Check that git doesn't appear as + or -
  ! [[ "${output}" =~ [+-][[:space:]]+brew[[:space:]]+"git" ]] || {
    echo "git should not appear in diff output: ${output}"; return 1
  }
}

@test "brew_audit: reports statistics on stdout" {
  invoke
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"installed but not tracked"* ]] || {
    echo "Expected statistics in output, got: ${output}"; return 1
  }
}

# ---------------------------------------------------------------------------
# --file output
# ---------------------------------------------------------------------------

@test "brew_audit: writes plain text results to --file" {
  outfile="${TEST_TMPDIR}/audit_results.txt"
  invoke --file="${outfile}"
  [ "${status}" -eq 0 ]
  [ -f "${outfile}" ] || {
    echo "Expected output file to be created"; return 1
  }
  grep -q 'fzf\|wget' "${outfile}" || {
    echo "Expected diff results in output file"
    cat "${outfile}"
    return 1
  }
}

@test "brew_audit: --file output contains no ANSI escape codes" {
  outfile="${TEST_TMPDIR}/audit_results.txt"
  invoke --file="${outfile}"
  [ "${status}" -eq 0 ]
  # ANSI escape sequences start with ESC (\033 / \x1b)
  ! grep -qP '\x1b\[' "${outfile}" || {
    echo "Expected no ANSI color codes in file output"
    return 1
  }
}

@test "brew_audit: reports save location when --file is used" {
  outfile="${TEST_TMPDIR}/audit_results.txt"
  invoke --file="${outfile}"
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"${outfile}"* ]] || {
    echo "Expected output file path in stdout, got: ${output}"; return 1
  }
}

# ---------------------------------------------------------------------------
# Type filtering
# ---------------------------------------------------------------------------

@test "brew_audit: --formulae limits output to brew entries" {
  # Add a cask discrepancy to the dump
  cat > "${TEST_TMPDIR}/mock_bin/brew" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "bundle" && "$2" == "dump" ]]; then
  for arg in "$@"; do
    if [[ "$arg" == "--file="* ]]; then
      outfile="${arg#--file=}"
      cat > "${outfile}" <<DUMP
brew "fzf"
cask "extra-cask"
DUMP
      exit 0
    fi
  done
fi
exit 0
EOF
  invoke --formulae
  [ "${status}" -eq 0 ]
  # cask entries should not appear in formulae-only output
  ! [[ "${output}" == *"extra-cask"* ]] || {
    echo "cask entry should not appear when --formulae is set; got: ${output}"; return 1
  }
}

@test "brew_audit: --npm limits output to npm entries" {
  cat > "${TEST_TMPDIR}/mock_bin/brew" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "bundle" && "$2" == "dump" ]]; then
  for arg in "$@"; do
    if [[ "$arg" == "--file="* ]]; then
      outfile="${arg#--file=}"
      cat > "${outfile}" <<DUMP
brew "fzf"
npm "eslint"
DUMP
      exit 0
    fi
  done
fi
exit 0
EOF
  invoke --npm
  [ "${status}" -eq 0 ]
  # brew entries should not appear; npm entry should
  ! [[ "${output}" == *" brew "*"fzf"* ]] || {
    echo "brew entry should not appear when --npm is set; got: ${output}"; return 1
  }
  [[ "${output}" == *"eslint"* ]] || {
    echo "Expected eslint in --npm output; got: ${output}"; return 1
  }
}

@test "brew_audit: default --all expands to tracked-type flags, not --all" {
  # Mock records the args passed to brew bundle dump
  cat > "${TEST_TMPDIR}/mock_bin/brew" <<EOF
#!/usr/bin/env bash
if [[ "\$1" == "bundle" && "\$2" == "dump" ]]; then
  echo "\$@" > "${TEST_TMPDIR}/bundle_args"
  for arg in "\$@"; do
    if [[ "\$arg" == "--file="* ]]; then
      outfile="\${arg#--file=}"
      : > "\${outfile}"
      exit 0
    fi
  done
fi
exit 0
EOF
  chmod +x "${TEST_TMPDIR}/mock_bin/brew"
  invoke
  [ "${status}" -eq 0 ]
  args=$(cat "${TEST_TMPDIR}/bundle_args")
  for flag in --formulae --casks --taps --mas --vscode --npm; do
    [[ "${args}" == *"${flag}"* ]] || {
      echo "Expected ${flag} in dump args; got: ${args}"; return 1
    }
  done
  ! [[ "${args}" == *" --all"* ]] && ! [[ "${args}" == "--all"* ]] || {
    echo "--all flag should not be passed to brew bundle dump; got: ${args}"; return 1
  }
}

# ---------------------------------------------------------------------------
# brew bundle dump failure
# ---------------------------------------------------------------------------

@test "brew_audit: exits non-zero when brew bundle dump fails" {
  cat > "${TEST_TMPDIR}/mock_bin/brew" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "bundle" && "$2" == "dump" ]]; then
  echo "Error: bundle dump failed" >&2
  exit 1
fi
exit 0
EOF
  invoke
  [ "${status}" -ne 0 ]
}
