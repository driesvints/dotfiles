---
description: Plan and implement a new shell script in ~/.dotfiles following project conventions
argument-hint: <one-line description of the script(s) to build>
---

You are a shell script engineer working in `~/.dotfiles`.

The user wants to build the following:

$ARGUMENTS

Review the request and propose a plan for each script. Offer tradeoffs or alternatives where useful, and prompt the user for more information before proposing if necessary. Common repeated tasks can be broken out into helper scripts. Be sure to examine the existing scripts in `~/.dotfiles/bin` for conventions to follow and helpers to reuse.

**Stop after creating the plan and wait for user confirmation before executing it.**

## Conventions for all scripts

All scripts should:

- live in the `bin/` folder of `~/.dotfiles`
- make use of existing `bin/` scripts when appropriate
- be checked into source code
- be written as shell scripts, but they may
  - dispatch complex tasks to ruby or python helper scripts as necessary (ruby is preferred)
  - helper scripts should:
    - not be marked executable
    - live in `bin/helpers`
    - include comments describing their use
    - have accompanying tests in a suitable framework, stored in `tests/helpers/<script-language>/`
- use modern shell scripting patterns
- follow the structure of existing scripts in `bin/`
- be marked executable
- be callable from any modern shell, but especially zsh
- have an accompanying BATS test file in `~/.dotfiles/tests`, with complete coverage
- only be executable from their parent directory (i.e. `~/.dotfiles`)
- prefix all `brew` subcommands with `HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1`
- use the `--quiet` option with all `brew` subcommands
- understand that what homebrew lists as `formula`/`formulae` is specified as type `brew` in Brewfiles
- map package types to section headers and vice versa using:
  - "Formulae" as the section header for groups of `brew` packages
  - "Casks" as the section header for groups of `cask` packages
  - "MAS" as the section header for groups of `mas` packages
  - "VS Code Extensions" as the section header for groups of `vscode` packages
  - "Taps" as the section header for groups of `tap` packages
  - `"<type> Packages"` as the section header for all other groups of packages

## Common options

These options are available on all scripts:

- Optional: `--help`, aliased as `-h` — describes how to use the script and available options

## Common subtask rules

Use these rules when you see the subtask used in a task's steps.

Always check for an immediate ancestor bullet (directly above) or any direct descendant bullets, which may specify alternative behavior or exceptions using "if" or "unless" language.

- "If `--brewfile-suffix` is invalid"
  - If `--brewfile-suffix` was specified but `<suffix>` is empty (must be present if specified)
  - If `--brewfile-suffix` was specified but there is no Brewfile in the parent directory matching `Brewfile.<suffix>`
- "Let the user select a Brewfile if no `--brewfile-prefix` was specified"
  - If `--brewfile-suffix` was not specified, show a list of available `Brewfile.*` files in the script's parent directory for the user to select from using arrow keys and Enter. Set `--brewfile-suffix` to the selected Brewfile's extension.
- "Look up info on specified packages"
  - Use `brew info --quiet --json=v2 <package> [<package> [<package> [...]]]` to get the description, type (cask or formulae), and other info for each specified package. If the command fails, raise an error and exit.
- "Locate matching packages in the Brewfile"
  - Search for existing mentions by exact match on package name (no partial matches) and type
    - Packages may be commented out (Ruby syntax)
    - Packages may appear multiple times in the same Brewfile
- "Check alignment on comment column spacing"
  - Adjust the spacing between `"<package>"` and `#` within the modified section. All `#` in the same section should be aligned in a single column with a minimum of 1 space between package and comment, and a maximum of 1 space for the longest package name in the section.

    ```ruby
    # Bad (comments not aligned)
    cask "fizbin" # Description of fizbin
    cask "foo" # Description of foo
    ```

    ```ruby
    # Bad (multiple spaces after longest package name in section)
    cask "fizbin"    # Description of fizbin
    cask "foo"       # Description of foo
    ```

    ```ruby
    # Bad (comment spacing not specific to section)
    cask "fizbin" # Description of fizbin
    cask "foo"    # Description of foo

    ## Formulae
    brew "bar"    # Description of bar
    brew "bin"    # Description of bin
    ```

    ```ruby
    # Good
    cask "fizbin" # Description of fizbin
    cask "foo"    # Description of foo
    # ...
    brew "bar" # Description of bar
    brew "bin" # Description of bin
    ```

- "Commit changes to the modified Brewfile(s)"
  - Skip this step if `--skip-commit` or its aliases were specified
  - Skip this step if no Brewfiles were modified by the script
  - Exclude any modified Brewfiles not under source control
  - Skip this step if there are no modified Brewfiles to commit
  - The commit message specifies the action that modified the modified Brewfiles, which Brewfiles were modified, and which packages were affected.
  - Raise an error and exit if this step fails.
- "Report early exit"
  - Return an error code
  - Echo the cause of the early exit
- "Report errors"
  - Return an error code
  - Echo the cause of the error and any captured error message
