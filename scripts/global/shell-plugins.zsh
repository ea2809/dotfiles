#!/usr/bin/env zsh
set -e
DOTFILES_DIR=${0:A:h:h:h}
source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
ANTIDOTE_CACHE=$(antidote home)
# Preserve tracked local edits. Git retains untracked generated files and refuses
# a merge/checkout if they conflict with incoming tracked files.
for gitdir in "$ANTIDOTE_CACHE"/**/.git(/N); do
  if [[ -n $(git -C "${gitdir:h}" status --porcelain --untracked-files=no) ]]; then
    print -u2 "Preserve local shell plugin edits before updating: ${gitdir:h}"
    exit 1
  fi
done
# forgit renamed its upstream default branch; retain the old local branch.
TASK_CACHE_DIR="$ANTIDOTE_CACHE/https-COLON--SLASH--SLASH-github.com-SLASH-wfxr-SLASH-forgit"
if [[ -d "$TASK_CACHE_DIR/.git" && $(git -C "$TASK_CACHE_DIR" branch --show-current) == master ]]; then
  git -C "$TASK_CACHE_DIR" config remote.origin.fetch '+refs/heads/main:refs/remotes/origin/main'
  git -C "$TASK_CACHE_DIR" fetch origin
  git -C "$TASK_CACHE_DIR" switch -c main --track origin/main
fi
# Load the actual declarations, including first-time clones, then use Antidote.
source <(antidote init)
# Read the same bundle commands used by the shell without running prompts/widgets.
while IFS= read -r declaration; do
  if [[ "$declaration" == *"antidote bundle "* && "$declaration" != *'#'* ]]; then
    if ! eval "$declaration"; then
      print -u2 "Failed shell plugin declaration: $declaration"
      exit 1
    fi
  fi
done < "$DOTFILES_DIR/zsh/zshrc"
antidote update --bundles
