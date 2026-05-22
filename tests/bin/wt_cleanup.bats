bats_require_minimum_version 1.5.0

load "../test_helper"

# ---------------------------------------------------------------------------
# Setup / teardown
# ---------------------------------------------------------------------------

setup() {
  _setup_common

  WT_LOG="${TEST_TMPDIR}/wt_calls.log"

  # Canned wt list JSON — one worktree + two branches.
  CANNED_JSON="${TEST_TMPDIR}/list.json"
  cat > "${CANNED_JSON}" <<'EOF'
[
  {
    "branch": "feature-a",
    "path": "/tmp/repo.feature-a",
    "kind": "worktree",
    "commit": {"sha":"abc","short_sha":"abc","message":"add feature A","timestamp":1700000000},
    "working_tree": {"modified":true,"staged":false,"untracked":false,"renamed":false,"deleted":false,"diff":{"added":3,"deleted":1}},
    "main_state": "diverged",
    "main": {"ahead":2,"behind":1,"diff":{"added":5,"deleted":2}},
    "remote": {"name":"origin","branch":"feature-a","ahead":2,"behind":0},
    "is_main": false, "is_current": false, "is_previous": false,
    "symbols": "⇡"
  },
  {
    "branch": "old-cleanup",
    "kind": "branch",
    "commit": {"sha":"def","short_sha":"def","message":"old work","timestamp":1600000000},
    "main_state": "integrated",
    "main": {"ahead":0,"behind":50,"diff":{"added":0,"deleted":0}},
    "is_main": false, "is_current": false, "is_previous": false,
    "symbols": "⊂"
  },
  {
    "branch": "stale-remote",
    "kind": "branch",
    "commit": {"sha":"ghi","short_sha":"ghi","message":"stale","timestamp":1650000000},
    "main_state": "integrated",
    "remote": {"name":"origin","branch":"stale-remote","gone":true},
    "is_main": false, "is_current": false, "is_previous": false,
    "symbols": "⊂"
  }
]
EOF

  # Mock `wt`: log every call; for `list`, serve canned JSON.
  # Shifts past any leading `-C <path>` before checking the subcommand.
  cat > "${TEST_TMPDIR}/mock_bin/wt" <<EOF
#!/usr/bin/env bash
echo "wt \$*" >> "${WT_LOG}"
while [[ "\$1" == "-C" ]]; do shift 2; done
if [[ "\$1" == "list" ]]; then
  cat "${CANNED_JSON}"
  exit 0
fi
if [[ "\$1" == "remove" ]]; then
  exit 0
fi
exit 0
EOF
  chmod +x "${TEST_TMPDIR}/mock_bin/wt"

  # Default fzf mock: select feature-a with Enter.
  _mock_fzf_select "feature-a"
}

teardown() {
  _teardown_common
}

# Helper: install an fzf mock that emits `enter` + the given branch row.
_mock_fzf_select() {
  local branch="$1"
  cat > "${TEST_TMPDIR}/mock_bin/fzf" <<EOF
#!/usr/bin/env bash
# Read & discard stdin (fzf consumes its input).
cat > /dev/null
echo "enter"
echo "${branch}	dummy	${branch}	worktree	-	-	-	-	-"
EOF
  chmod +x "${TEST_TMPDIR}/mock_bin/fzf"
}

# Helper: install an fzf mock that emits multiple selections.
_mock_fzf_select_multi() {
  local lines="$1"
  cat > "${TEST_TMPDIR}/mock_bin/fzf" <<EOF
#!/usr/bin/env bash
cat > /dev/null
echo "enter"
${lines}
EOF
  chmod +x "${TEST_TMPDIR}/mock_bin/fzf"
}

# Helper: fzf mock that exits 130 (user cancelled).
_mock_fzf_cancel() {
  cat > "${TEST_TMPDIR}/mock_bin/fzf" <<'EOF'
#!/usr/bin/env bash
cat > /dev/null
exit 130
EOF
  chmod +x "${TEST_TMPDIR}/mock_bin/fzf"
}

invoke() {
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    "${DOTFILES_BIN}/wt_cleanup" "$@"
}

# Convenience: invoke with stdin "y" (confirming the remove prompt).
invoke_yes() {
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    bash -c "echo y | '${DOTFILES_BIN}/wt_cleanup' $*"
}

# Convenience: invoke with stdin "n" (declining the remove prompt).
invoke_no() {
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    bash -c "echo n | '${DOTFILES_BIN}/wt_cleanup' $*"
}

# ---------------------------------------------------------------------------
# Help / arg validation
# ---------------------------------------------------------------------------

@test "wt_cleanup: --help prints usage and exits 0" {
  invoke --help
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"Usage"* ]] || { echo "Got: ${output}"; return 1; }
  [[ "${output}" == *"--delete-branch"* ]] || return 1
}

@test "wt_cleanup: unknown option exits non-zero" {
  invoke --bogus
  [ "${status}" -ne 0 ]
}

@test "wt_cleanup: positional argument exits non-zero" {
  invoke some-branch
  [ "${status}" -ne 0 ]
}

# ---------------------------------------------------------------------------
# Prerequisite checks
# ---------------------------------------------------------------------------

@test "wt_cleanup: errors when wt is not available" {
  rm "${TEST_TMPDIR}/mock_bin/wt"
  # Build a PATH with system utilities but without wt (it lives in /opt/homebrew/bin).
  run env PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:/usr/bin:/bin" "${DOTFILES_BIN}/wt_cleanup" --yes
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"wt is not installed"* ]] || { echo "Got: ${output}"; return 1; }
}

@test "wt_cleanup: errors when fzf is not available" {
  rm "${TEST_TMPDIR}/mock_bin/fzf"
  run env PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:/usr/bin:/bin" "${DOTFILES_BIN}/wt_cleanup" --yes
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"fzf is not installed"* ]] || { echo "Got: ${output}"; return 1; }
}

# ---------------------------------------------------------------------------
# wt list failures
# ---------------------------------------------------------------------------

@test "wt_cleanup: exits non-zero when wt list fails" {
  cat > "${TEST_TMPDIR}/mock_bin/wt" <<'EOF'
#!/usr/bin/env bash
while [[ "$1" == "-C" ]]; do shift 2; done
if [[ "$1" == "list" ]]; then
  echo "boom" >&2
  exit 1
fi
exit 0
EOF
  invoke --yes
  [ "${status}" -ne 0 ]
}

@test "wt_cleanup: exits cleanly when wt list returns empty array" {
  cat > "${TEST_TMPDIR}/mock_bin/wt" <<'EOF'
#!/usr/bin/env bash
while [[ "$1" == "-C" ]]; do shift 2; done
[[ "$1" == "list" ]] && { echo "[]"; exit 0; }
exit 0
EOF
  invoke --yes
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"No worktrees"* ]] || { echo "Got: ${output}"; return 1; }
}

# ---------------------------------------------------------------------------
# wt list args
# ---------------------------------------------------------------------------

@test "wt_cleanup: omits --branches by default" {
  invoke_yes --yes
  grep -qE 'list --format json( |$)' "${WT_LOG}" || return 1
  ! grep -q 'list --format json --branches' "${WT_LOG}" || {
    echo "should not have --branches: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: passes --branches when --branches given" {
  invoke_yes --yes --branches
  grep -q 'list --format json --branches' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: does not pass --full by default" {
  invoke_yes --yes
  ! grep -q '\-\-full' "${WT_LOG}" || {
    echo "wt log should not include --full: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: passes --full when --full given" {
  invoke_yes --yes --full
  grep -q 'list --format json --full' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

# ---------------------------------------------------------------------------
# cwd is forwarded to wt via -C
# ---------------------------------------------------------------------------

@test "wt_cleanup: passes -C <cwd> to wt list" {
  fake_repo="${TEST_TMPDIR}/some/other/repo"
  mkdir -p "${fake_repo}"
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    bash -c "cd '${fake_repo}' && echo y | '${DOTFILES_BIN}/wt_cleanup' --yes"
  grep -q "wt -C ${fake_repo} list " "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: passes -C <cwd> to wt remove" {
  fake_repo="${TEST_TMPDIR}/some/other/repo"
  mkdir -p "${fake_repo}"
  run env \
    PATH="${TEST_TMPDIR}/mock_bin:${DOTFILES_BIN}:${PATH}" \
    bash -c "cd '${fake_repo}' && echo y | '${DOTFILES_BIN}/wt_cleanup' --yes"
  grep -q "wt -C ${fake_repo} remove --no-delete-branch feature-a" "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

# ---------------------------------------------------------------------------
# Removal — default flag set
# ---------------------------------------------------------------------------

@test "wt_cleanup: default remove includes --no-delete-branch" {
  invoke_yes --yes
  [ "${status}" -eq 0 ]
  grep -q 'remove --no-delete-branch feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: --delete-branch drops --no-delete-branch" {
  invoke_yes --yes --delete-branch
  [ "${status}" -eq 0 ]
  ! grep -q '\-\-no-delete-branch' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
  grep -q 'remove feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: --force-delete is forwarded" {
  invoke_yes --yes --force-delete
  grep -q 'remove --no-delete-branch --force-delete feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: --force is forwarded" {
  invoke_yes --yes --force
  grep -q 'remove --no-delete-branch --force feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: --no-hooks is forwarded" {
  invoke_yes --yes --no-hooks
  grep -q 'remove --no-delete-branch --no-hooks feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: combined flags are forwarded in order" {
  invoke_yes --yes --delete-branch --force-delete --force --no-hooks
  grep -q 'remove --force-delete --force --no-hooks feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

# ---------------------------------------------------------------------------
# Pass-through args after --
# ---------------------------------------------------------------------------

@test "wt_cleanup: args after -- are appended to wt remove" {
  invoke_yes --yes -- --foreground -v
  grep -q 'remove --no-delete-branch feature-a --foreground -v' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

# ---------------------------------------------------------------------------
# Multi-select
# ---------------------------------------------------------------------------

@test "wt_cleanup: removes each selected entry" {
  _mock_fzf_select_multi 'echo "feature-a	x	feature-a	worktree	-	-	-	-	-"
echo "old-cleanup	x	old-cleanup	branch	-	-	-	-	-"'
  invoke_yes --yes
  [ "${status}" -eq 0 ]
  grep -q 'remove --no-delete-branch feature-a' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
  grep -q 'remove --no-delete-branch old-cleanup' "${WT_LOG}" || {
    echo "wt log: $(cat "${WT_LOG}")"; return 1
  }
}

# ---------------------------------------------------------------------------
# Cancellation paths
# ---------------------------------------------------------------------------

@test "wt_cleanup: exits cleanly when fzf is cancelled" {
  _mock_fzf_cancel
  invoke
  [ "${status}" -eq 0 ]
  ! grep -qE ' remove( |$)' "${WT_LOG}" || {
    echo "should not have called wt remove: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: declining confirmation prompt skips remove" {
  invoke_no
  [ "${status}" -eq 0 ]
  ! grep -qE ' remove( |$)' "${WT_LOG}" || {
    echo "should not have called wt remove: $(cat "${WT_LOG}")"; return 1
  }
}

@test "wt_cleanup: --yes skips confirmation prompt" {
  # Use invoke (no stdin) — should succeed without a prompt.
  invoke --yes
  [ "${status}" -eq 0 ]
  grep -qE ' remove( |$)' "${WT_LOG}" || {
    echo "expected wt remove call: $(cat "${WT_LOG}")"; return 1
  }
}

# ---------------------------------------------------------------------------
# Remove failure surfaces non-zero exit
# ---------------------------------------------------------------------------

@test "wt_cleanup: exits non-zero when wt remove fails" {
  cat > "${TEST_TMPDIR}/mock_bin/wt" <<EOF
#!/usr/bin/env bash
echo "wt \$*" >> "${WT_LOG}"
while [[ "\$1" == "-C" ]]; do shift 2; done
if [[ "\$1" == "list" ]]; then
  cat "${CANNED_JSON}"
  exit 0
fi
if [[ "\$1" == "remove" ]]; then
  exit 2
fi
exit 0
EOF
  invoke_yes --yes
  [ "${status}" -ne 0 ]
}
