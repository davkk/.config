# -- ZSH CONFIG
bindkey -v
bindkey "" autosuggest-accept

HYPHEN_INSENSITIVE="true"


# -- OH-MY-ZSH
export ZSH=$HOME/.config/zsh/.oh-my-zsh

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Standard plugins: $ZSH/plugins/
# Custom plugins: $ZSH_CUSTOM/plugins/
plugins=(
    git
    tmux
    vi-mode
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

export VI_MODE_SET_CURSOR=true

# export ZSH_TMUX_AUTOQUIT=false
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_CONFIG=$HOME/.config/tmux/tmux.conf

typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red

source $ZSH/oh-my-zsh.sh


# -- USER CONFIGURATION
export VOLTA_HOME=$HOME/.volta
export PNPM_HOME=$HOME/.local/share/pnpm
export BUN_INSTALL=$HOME/.bun
export ANDROID_SDK_ROOT=$HOME/.android
export ANDROID_AVD_HOME=$HOME/.android

export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
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

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export FZF_BASE=$(which fzf)

export GIT_CONFIG_GLOBAL=$HOME/.config/.gitconfig

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPAGER='nvim +Man!'

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# opam configuration
[[ ! -r /home/davkk/.opam/opam-init/init.zsh ]] || source /home/davkk/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null


# -- ALIASES
alias l='ls --color -lhF --group-directories-first'
alias vim='nvim'
alias nv='echo you are stupid'
alias python='python3'
alias tmux='tmux -u'


# -- STARSHIP
export STARSHIP_CONFIG=$HOME/.config/zsh/starship.toml
eval "$(starship init zsh)"
