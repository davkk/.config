export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt PROMPT_SUBST

export HYPHEN_INSENSITIVE=false
export WORDCHARS=

export MANPAGER="nvim +Man!"

sd() {
    newdir=`fzfp $1`
    [ -n "$newdir" ] && cd $newdir || echo "no directory selected"
}

review() {
  local target=${1:-origin/main}
  local fork=$(git merge-base --fork-point $target)
  local files=$(git diff --name-only $fork..)
  if [[ -n "$files" ]]; then
      nvim -p $(echo "$files") +"tabdo Gvdiffsplit! $@ $fork" +tabfirst
  fi
}


alias l='ls --color -lahF --group-directories-first'
alias tmux='tmux -u'

export ALIBUILD_WORK_DIR="$HOME/work/alice/sw"
alias alice='apptainer shell -s /usr/bin/zsh ~/work/alice/alice.sif'
alias o2='MODULES_SHELL=zsh alienv enter O2Physics/latest ninja/latest --shellrc'

export XDG_CURRENT_DESKTOP="sway"
export XDG_SESSION_DESKTOP="sway"
export XDG_CURRENT_SESSION_TYPE="wayland"

export MOZ_ENABLE_WAYLAND=1
export XCURSOR_SIZE=28

export GDK_BACKEND="wayland,x11"

export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_ENABLE_HIGHDPI_SCALING=1

export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.local/zsh_history

export VOLTA_HOME=$HOME/.volta
export PNPM_HOME=$HOME/.local/share/pnpm
export BUN_INSTALL=$HOME/.bun
export ANDROID_SDK_ROOT=$HOME/.android
export ANDROID_AVD_HOME=$HOME/.android

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.config/.scripts/
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/env
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:$HOME/.android/cmdline-tools/latest/bin
export PATH=$PATH:$HOME/.android/emulator
export PATH=$PATH:$HOME/.android/platform-tools
export PATH=$PATH:$VOLTA_HOME/bin
export PATH=$PATH:$PNPM_HOME
export PATH=$PATH:$BUN_INSTALL/bin

export FZF_BASE=$(which fzf)
export FZF_DEFAULT_OPTS="
--color=fg:#e0e2ea,bg:#14161B,hl:#a6dbff
--color=fg+:#eef1f8,bg+:#2c2e33,hl+:#8cf8f7
--color=border:#4f5258,header:#c4c6cd,gutter:-1
--color=spinner:#fce094,info:#9b9ea4
--color=pointer:#a6dbff,marker:#b4f6c0,prompt:#a6dbff
--bind ctrl-y:accept
"

export GIT_CONFIG_GLOBAL=$HOME/.config/.gitconfig

# fix java gui apps
export _JAVA_AWT_WM_NONREPARENTING=1

export SUDO_EDITOR=`which nvim`
export EDITOR=`which nvim`

zstyle ':completion:*:default' menu select

bindkey -e
bindkey '^y' autosuggest-accept
bindkey '^n' complete-word

bindkey "\e[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

[[ ! -r /home/davkk/.opam/opam-init/init.zsh ]] || source /home/davkk/.opam/opam-init/init.zsh > /dev/null 2> /dev/null
eval `opam env 2>/dev/null` 2>/dev/null

source <(fzf --zsh 2>/dev/null)

[[ ! -f ${XDG_CONFIG_HOME}/zsh/powerlevel10k/powerlevel10k.zsh-theme ]] || source $XDG_CONFIG_HOME/zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ${XDG_CONFIG_HOME}/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

if command -v direnv >/dev/null 2>&1; then
    export DIRENV_LOG_FORMAT=
    eval "$(direnv hook zsh)" 2>/dev/null
fi
