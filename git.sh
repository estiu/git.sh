if [[ -n $ENABLE_GIT_SH_ALIASES ]]; then
  alias ch='git cherry-pick -n'
  alias gist="gist -p | pbcopy"
  alias m-="git merge -"
  alias st='git status'
  alias stash="git add -A > /dev/null; git stash > /dev/null"
  alias t="git"
fi

if [[ -n $ENABLE_GIT_SH_SHORTFNS ]]; then
  alias A="git_sh_A"
  alias allmine="git_sh_allmine"
  alias amend="git_sh_amend"
  alias backup_branch="git_sh_backup_branch"
  alias br="git_sh_br"
  alias c-="git_s_h-"
  alias c--="git_sh_--"
  alias cln="git_sh_cln"
  alias co="git_sh_co"
  alias commit_count="git_sh_commit_count"
  alias copy_and_print="git_sh_copy_and_print"
  alias current_branch="git_sh_current_branch"
  alias days="git_sh_days"
  alias delete_origin="git_sh_delete_origin"
  alias E="git_sh_E"
  alias force_pull="git_sh_force_pull"
  alias hard="git_sh_hard"
  alias fwl="git_sh_fwl"
  alias log="git_sh_log"
  alias merge_base="git_sh_merge_base"
  alias ml="git_sh_ml"
  alias msg="git_sh_msg"
  alias previous_branch="git_sh_previous_branch"
  alias pull="git_sh_pull"
  alias push="git_sh_push"
  alias rebase_my_commits="git_sh_rebase_my_commits"
  alias rebase="git_sh_rebase"
  alias remove_branch="git_sh_remove_branch"
  alias renames="git_sh_renames"
  alias sap="git_sh_sap"
  alias set_upstream="git_sh_set_upstream"
  alias sha="git_sh_sha"
  alias soft_merge="git_sh_soft_merge"
  alias soft="git_sh_soft"
fi

# create a branch prefixed `BACKUPS`, with the current commits for the current branch.
# non-commited changes are not backed up.
git_sh_backup_branch(){
  if [[ -n $ENABLE_GIT_SH_BACKUPS ]]; then
    git branch "BACKUPS/$(current_branch)/$(date +%s)" > /dev/null 2>&1
  fi
}

# suggested alias: `A`. Enable it with ENABLE_GIT_SH_SHORTFNS
git_sh_A () {
  git add -A
}

# suggested alias: `c-`. Enable it with ENABLE_GIT_SH_SHORTFNS
git_sh_c- () {
  git_sh_backup_branch
  git checkout -
}

# suggested alias: `c--`. Enable it with ENABLE_GIT_SH_SHORTFNS
git_sh_c-- () {
  git checkout -
  git checkout -
}

# suggested alias: `sap`. Enable it with ENABLE_GIT_SH_SHORTFNS
git_sh_sap (){
  git stash apply
}

# suggested alias: `log`. Enable it with ENABLE_GIT_SH_SHORTFNS
git_sh_log(){
  git $1 log --no-merges --pretty=format:'%Cred%h%Creset -%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit $2
}

git_sh_current_branch(){
  git rev-parse --abbrev-ref HEAD
}

# Cleans all uncommitted changes, presumed useless
# Does not backup those - you should `git stash` before
git_sh_cln(){
  git_sh_backup_branch
  git reset . > /dev/null
  git checkout . > /dev/null
  git clean -fd > /dev/null
}

# Prevents typical annoyance about upstream when trying to `pull`
git_sh_set_upstream(){
  git branch --set-upstream-to=origin/`current_branch` > /dev/null 2>&1
}

git_sh_pull(){
  git_sh_set_upstream
  git_sh_backup_branch
  git pull -q
}

# If given 1 argument: Changes the branch to $1, and `pull`s if it's reasonable to.
# If given more argumenes: A plain `git checkout ...` targeted at files, not branches.
git_sh_co(){
  git_sh_set_upstream
  git fetch > /dev/null 2>&1
  git_sh_backup_branch
  if [ "$#" -ne 1 ]; then
    git checkout "$@"
  else
    git checkout -q $1
    ruby -e 'exit((`git status --porcelain` == "" && (`git status | grep diverged` == "")) ? 0 : 1)' && git pull -q  > /dev/null 2>&1
  fi
}

# How many unique days has been this repo committed to?
git_sh_days(){
	ruby -e 'puts `git log --date=short --pretty=format:"%ad"`.split("\n").uniq.size'
}

# The commit count of this repo
git_sh_commit_count(){
 git rev-list HEAD --count
}

git_sh_fwl(){
  git_sh_backup_branch
  git push --force-with-lease -q
}

git_sh_push(){
  git push -q 2>&1 || git_sh_fwl
}

git_sh_force_pull(){
  git_sh_backup_branch
  git fetch --all
  git reset --hard origin/$(current_branch)
}

git_sh_merge_base(){
  git merge-base $(current_branch) $GIT_SH_DEFAULT_FEATURE_TARGET_BRANCH
}

# Rebases the commits that are in your branch but not in $GIT_SH_DEFAULT_FEATURE_TARGET_BRANCH .
# Does not rebase the branch against GIT_SH_DEFAULT_FEATURE_TARGET_BRANCH ; it mererly rewrites the commits in this branch.
# Useful if you are concerned with renaming past commit messages, etc
git_sh_rebase_my_commits(){
  git_sh_backup_branch
  git rebase -i "$(echo $(merge_base))"
}

# ml = "My log"; the git log for the commits that are in your branch but not in $GIT_SH_DEFAULT_FEATURE_TARGET_BRANCH .
git_sh_ml(){
  log "--no-pager" $(merge_base)..$(sha)
}

# Removes all the branches passed as arguments, locally and remotely
git_sh_remove_branch(){
  git_sh_backup_branch
  git branch -D "$@"
  echo "$@" | xargs git_sh_delete_remote_branch
}

git_sh_delete_origin(){
  git_sh_delete_remote_branch $(git_sh_current_branch)
}

# "Merges" the $1 branch into the current branch, without committing anything
# or bringing any commits to the current branch's log
git_sh_soft_merge(){
  git_sh_backup_branch
  git merge --no-commit --no-ff $1
  git_sh_stash
  git_sh_c- > /dev/null 2>&1
  git_sh_c- > /dev/null 2>&1
  git_sh_sap > /dev/null
  git_sh_A
}

# The name of the previously visited branch
git_sh_previous_branch(){
  git rev-parse --abbrev-ref @{-1}
}

# Lists the renames done in the last commit
git_sh_renames(){
   git diff --name-status -C HEAD HEAD~1 | sort
}

git_sh_br() {
  git branch --sort=-committerdate | grep -v BACKUPS
}

git_sh_soft(){
  git_sh_backup_branch
  git reset --soft "HEAD~$1"
}

git_sh_hard(){
  git_sh_backup_branch
  git reset --hard "HEAD~$1"
}

git_sh_amend (){
  git_sh_backup_branch
  git commit --amend --no-edit
}

git_sh_rebase (){
  git_sh_backup_branch
  git rebase "@"
}

# Rewrites all commits using your current name/email.
# Good for fixing inconsistencies, anonymizing your email in a public repo, etc
git_sh_allmine (){
  git filter-branch -f --env-filter '
      export GIT_AUTHOR_NAME="`git config user.name`"
      export GIT_AUTHOR_EMAIL="`git config user.email`"
      export GIT_COMMITTER_NAME="`git config user.name`"
      export GIT_COMMITTER_EMAIL="`git config user.email`"
  ' --tag-name-filter cat -- --branches --tags
}

# - Copies $1 to the clipboard (without a newline)
# - Echoes $1 (with a newline)
git_sh_copy_and_print() {
  ruby -e "print \`$1\`.split("\"\\n\"")[0]" | pbcopy
  pbpaste | xargs echo
}

# Does a `copy_and_print` over this commit's sha
git_sh_sha() {
  git_sh_copy_and_print "git rev-parse HEAD"
}

# Does a `copy_and_print` over this commit's commit message
git_sh_msg(){
	git_sh_copy_and_print 'git log -1 --pretty=%B'
}

# Good for when you are merging, and you are OK with the default auto-generated "merge commit" message.
# i.e skips the tedious multi-step process of attempting to commit, then `vim`-img a prefilled message.
git_sh_E() {
  EDITOR=true git commit
}
