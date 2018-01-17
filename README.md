# git.sh

git.sh is:

* The typical bunch of aliases that you "should create one day" (but didn't)
* A few higher-level commands for git interaction
* An approach to backup your branch before doing any destructive (directly or not) git command:
  - Cleaning up all staged and/or unstaged changes
  - Pushing, pulling
  - Merging, rebasing
  - Removing branches
  - git `reset`-ting, `amend`-ing
  - Changing branches

By having aliases for all those operations, one can perform the backup operation, right before.

## Requirements

* `ruby` (worry not; its CLI performs instantly)
* `pbcopy` or a shim

## Usage

* `git clone https://github.com/vemv/git.sh.git ~/git_sh`
* Look at the source.
* Selectively `export` `ENABLE_GIT_SH_ALIASES`, `ENABLE_GIT_SH_SHORTFNS` and `ENABLE_GIT_SH_BACKUPS` to `1`, as per your liking. Else leave unset.
* export GIT_SH_DEFAULT_FEATURE_TARGET_BRANCH to `master`, `develop`, `dev` or whatever your usual targetted branch (for merging features) is.
* `source ~/git_sh/git.sh` in your .bashrc.

## An example session