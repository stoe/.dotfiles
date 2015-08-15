#!/bin/zsh

# ------------------------------------------------------------------------------
#
# stoe - my theme for oh-my-zsh
#
# ------------------------------------------------------------------------------


# VARIABLES --------------------------------------------------------------------
ICON_GIT_REPO=""       # U+F20C
ICON_GIT_DIRTY=""      # U+F201
ICON_GIT_UNTRACKED=""  # U+F22A
ICON_PROMPT=""         # U+F278

# OPTIONS ----------------------------------------------------------------------
setopt prompt_subst

# MODULES ----------------------------------------------------------------------
autoload -Uz vcs_info

# VCS_INFO ---------------------------------------------------------------------
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
# only export two msg variables from vcs_info
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%%u%c"
zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%u%c (%a)"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" ""

# ----- List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# FUNCTIONS --------------------------------------------------------------------
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}

    let local elapsed=$stop-$start

    [ $elapsed -gt 3 ] && echo ${elapsed}s
}

preexec() {
    cmd_timestamp=`date +%s`
}

git_repo() {
    if [ $vcs_info_msg_1_ ]; then
        echo "%F{8}$ICON_GIT_REPO  "
    fi
}

git_dirty() {
    # Check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # Check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo " $ICON_GIT_DIRTY"
}

# PROMPTS ----------------------------------------------------------------------
precmd() {
    vcs_info

    # print -P "\n%F{white}%~ %F{yellow}$(cmd_exec_time)%f"
    print -P "\n%F{white}${vcs_info_msg_0_%%/.} %F{yellow}$(cmd_exec_time)%f"
    RPROMPT="$(git_prompt_info)"
}

PROMPT="%(?.%F{8}.%F{red})$ICON_PROMPT%f "
RPROMPT=""

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}$ICON_GIT_REPO  "
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{yellow}$ICON_GIT_DIRTY"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{red}$ICON_GIT_UNTRACKED"
ZSH_THEME_GIT_PROMPT_CLEAN=""
