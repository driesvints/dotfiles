## Playground Skill

Invoke the `playground` skill when the user asks to "create a demo", "build a demo", "make a
visual demo", "show me how X works interactively", "visualize X", or any request for a
standalone interactive tool or explorer. If the request is ambiguous, suggest the playground
skill as an option before proceeding with a static response.

## Worktree Management

Worktrees are managed exclusively through worktrunk (`wt` CLI). Never use raw `git worktree add`. When the `using-git-worktrees` skill runs, substitute `wt switch --create <branch>` for `git worktree add`. Worktrees always live as siblings to the main worktree (worktrunk's default) — never ask the user where to put them.

## Auditing Local Command Permissions

When prompted to audit a project's local command permissions, use `.claude/settings.local.json`. Start by scanning the project's bin/ and equivalent folders for executables, as well as executables added by the project's package managers, e.g. rubygems. Expand any that accept subcommands. Ignore any that are not specific to development environments or local testing and analysis tasks, as well as any already covered by global allow, ask, deny settings. Next, compare that list to the current local allow, ask, and deny lists. Look carefully for any existing entries that might be prefixed with "##", indicating they are already known and have been explicitly commented out. For each existing entry in the local allow, ask, and deny lists, check if it still exists in the project. If it does not, organize it into a "stale" section. If any conflict with the global allow, ask, or deny settings, group them into a "conflicts" section. Next, ensure all commands are alphabetized within their respective sections for easy reference. Finally add any new commands and sub commands to a "new" section at the bottom of the local allow list, categorizing between destructive (or potentially destructive) and non-destructive (or easily recoverable) commands, and in alphabetical order. I will then manually review the final list to ensure it is comprehensive and correctly categorized. This process will help maintain a clean and secure command permission setup for each project with limited interruptions to the development workflow.
