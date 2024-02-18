export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export GTK_THEME=Adwaita-dark

# -- wayland fix
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME="qt5ct"
export GDK_BACKEND="wayland,x11"
export XDG_CURRENT_DESKTOP="sway"
export XDG_SESSION_DESKTOP="sway"
export XDG_CURRENT_SESSION_TYPE="wayland"
export MOZ_ENABLE_WAYLAND=1

export QT_SCALE_FACTOR=1.25
export QT_AUTO_SCREEN_SCALE_FACTOR=1.25
export ELM_SCALE=1.25
export GDK_SCALE=1.25
export XCURSOR_SIZE=27

# -- ZSH OPTIONS

setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt PROMPT_SUBST

HYPHEN_INSENSITIVE="true"

# -- ALIASES
alias l='ls --color -lhF --group-directories-first'
alias nv='echo you are stupid'
alias vim=nvim
alias python='python3'
alias tmux='tmux -u'


# -- PLUGINS
source $XDG_CONFIG_HOME/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle fzf

antigen bundle 'zsh-users/zsh-syntax-highlighting'
antigen bundle 'zsh-users/zsh-autosuggestions'

antigen apply

typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red

bindkey '^y' autosuggest-accept

# -- STARSHIP
export STARSHIP_CONFIG=$HOME/.config/zsh/starship.toml
eval "$(starship init zsh)"


# -- EXPORTS
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.local/zsh_history

export VOLTA_HOME=$HOME/.volta
export PNPM_HOME=$HOME/.local/share/pnpm
export BUN_INSTALL=$HOME/.bun
export ANDROID_SDK_ROOT=$HOME/.android
export ANDROID_AVD_HOME=$HOME/.android

export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.config/.scripts/
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:$HOME/.android/cmdline-tools/latest/bin
export PATH=$PATH:$HOME/.android/emulator
export PATH=$PATH:$HOME/.android/platform-tools
export PATH=$PATH:$HOME/.cargo/env
export PATH=$PATH:$VOLTA_HOME/bin
export PATH=$PATH:$PNPM_HOME
export PATH=$PATH:$BUN_INSTALL/bin

export FZF_BASE=$(which fzf)

export GIT_CONFIG_GLOBAL=$HOME/.config/.gitconfig

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPAGER="nvim +Man! --cmd 'let g:unception_disable=1'"

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# preferred editor for local and remote sessions
export SUDO_EDITOR=`which nvim`
export EDITOR=`which vim`

# -- CUSTOM FUNCTIONS

# change directory (project)
sp() {
    selected=`fzfp`
    if [[ -n "$selected" ]]; then
        cd "$selected"
    fi
}
zle -N cdp

# -- BINDKEYS
bindkey -e

# -- CONFIGS

# opam configuration
[[ ! -r /home/davkk/.opam/opam-init/init.zsh ]] || source /home/davkk/.opam/opam-init/init.zsh > /dev/null 2> /dev/null
eval `opam env`
