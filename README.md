# git.sh

git.sh is:

* The typical bunch of aliases that you "should create one day" (but didn't)
* A few higher-level commands for git interaction
* An approach to backing up your branch before doing **any destructive** (directly or not) git command:
  - Cleaning up all staged and/or unstaged changes
  - Pushing, pulling
  - Merging, rebasing
  - Removing branches
  - git `reset`-ting, `amend`-ing
  - Checking out other branches

By having aliases for all those operations, one can perform the backup operation, right before.

## No alias pollution

All functions are prefixed with `git_sh_`. The aliases are guarded under an opt-in variable.

If you only want some aliases, create them manually.

Or maybe bring them all but later overwrite the desired ones.

**Note:** rest assured, I won't add any new aliases in any commit other than the initial one; as it could break someone's environment.

## Requirements

* `ruby` (worry not; its CLI performs instantly)
* `pbcopy` or a shim

## Usage

* `git clone https://github.com/vemv/git.sh.git ~/git_sh`
* Look at the source.
* Selectively `export` `ENABLE_GIT_SH_ALIASES` and `ENABLE_GIT_SH_BACKUPS` to `1`, as per your liking. Else leave unset.
* export `GIT_SH_DEFAULT_FEATURE_TARGET_BRANCH` to `master`, `develop`, `dev` or whatever your usual targetted branch (for merging features) is.
* `source ~/git_sh/git.sh` in your .bashrc.

## An example session

## Onc backups

## Other handy aliases

I also use these aliases, not included in the source for avoiding an excess of flags/concepts.

Feel free to copy them!

```
alias ch='git cherry-pick -n'
alias m="git commit -m"
alias m-="git merge -"
alias st='git status'
alias stash="git add -A > /dev/null; git stash > /dev/null"
alias t="git"
```