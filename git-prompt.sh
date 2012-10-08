#!/bin/sh
# Show the current git branch on your bash prompt

#
# Colors
#
YELLOW="\[\033[0;33m\]"
NORMAL="\[\033[0m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"

#
# Prompt Setup
#


# If we are currently rebasing, reflect that in the prompt.
# We can test for the existence of rebase-apply to see if we are rebasing.
function parse_git_in_rebase {
  [[ -d .git/rebase-apply ]] && echo " REBASING"
}

# If there is anything changed or uncommitted, reflect that in the prompt.
# Unless the last line of git status' output is "nothing to commit", then the repo is considered "dirty"
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " *"
}

# Show the name of the active branch, if applicable
# Grab the current git branch name, also displaying its dirty/clean/rebasing status
function parse_git_branch {
  branch=$(git branch 2> /dev/null | grep "*" | sed -e s/^..//g)
  if [[ -z ${branch} ]]; then
    return
  fi
  echo "("${branch}$(parse_git_dirty)$(parse_git_in_rebase)") "
}

# Add git info to the prompt:
# current user@host in green, 
# working directory name in blue, 
# git information in yellow, 
# and finally the [super]user ($ or #) prompt in blue.
export PS1="$GREEN\u@\h $BLUE\W$YELLOW \$(parse_git_branch)$BLUE\$$NORMAL " 
