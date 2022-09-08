#!/bin/bash

print_git_status() {
  cd_project_path
  # Get git branch info
  local branch_name
  branch_name=$(git branch --show-current)
  local branch_commit_short
  branch_commit_short="$(git rev-parse --short HEAD)"
  # Get git parent branch info
  local branch_parent_name
  branch_parent_name=$(git log --pretty=format:'%D' HEAD^ | grep 'origin/' | head -n1 | sed 's@origin/@@' | sed 's@,.*@@')
  local branch_parent_commit
  branch_parent_commit=$(git log --decorate | grep 'commit' | grep 'origin/' | head -n 2 | tail -n 1 | awk '{ print $2 }' | tr -d "\n")
  local branch_parent_commit_short
  branch_parent_commit_short="$(git rev-parse --short "$branch_parent_commit")"

  # =====================================
  # ==== print the current git branch ====
  cprint wh "  Current branch: "
  cecho r "$branch_name"
  # print the current commit
  cprint wh "  Current commit: "
  cecho r "$branch_commit_short"

  # =====================================
  # ==== print the parent git branch ====
  cprint wh "  Parent branch: "
  cecho r "$branch_parent_name"
  # print the current commit
  cprint wh "  Parent commit: "
  cecho r "$branch_parent_commit_short"

  # =====================================
  # print if not in clean check-out state
  [[ -n $(git status -s) ]] && cecho y 'Git has modified and/or untracked!' && git status --short
  [[ -z $(git status -s) ]] && cecho g 'Git checkout state is clean.'
}
