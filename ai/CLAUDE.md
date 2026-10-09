# Git

- Before starting new work in a git repository, run `git fetch` and check whether the current branch is behind its remote. If it is, pull with `--ff-only` before changing anything. If the working tree has uncommitted changes, ask before pulling.
- Delete local branches whose pull requests have already been merged, without asking. Never delete the current branch, the default branch, or a branch with unpushed commits.

# Pull requests

- When opening a PR, don't write the description. Put a placeholder in the body for me to fill in, since I write PR descriptions myself so I can explain the change to other people and confirm I understand it.
- After opening the PR, give me a summary in chat with the important details I can use for the description: what changed and why, notable implementation decisions, anything reviewers should look at closely, and how it was tested.
