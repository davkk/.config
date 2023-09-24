export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# -- ZSH OPTIONS

setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt PROMPT_SUBST

HYPHEN_INSENSITIVE="true"


# -- CUSTOM FUNCTIONS
vimcd() {
    if [ ! -z $NVIM ] && [ -e /tmp/nvim.pipe ]; then
        nvim --server /tmp/nvim.pipe --remote-send "<C-\\><C-N>:tcd $(realpath ${1:-.})<CR>"
    fi
}

pop() {
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find ~/projects ~/work ~/personal -mindepth 1 -maxdepth 1 -type d 2&>/dev/null | fzf )
    fi
    if [[ -n "$selected" ]]; then
        cd "$selected"
        zle reset-prompt

        vimcd $selected
    fi
}

vim() {
    if [ -z $NVIM ]; then
        nvim --listen /tmp/nvim.pipe $@
    elif [[ $# -le 1 ]]; then
        nvim --server /tmp/nvim.pipe --remote-silent $(realpath ${1:-.})
    else
        echo "sir, this is wendy's"
    fi
}


# -- BINDKEYS
bindkey -e

zle -N pop
bindkey '^f' pop

# ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
# urxvt
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word
# ctrl+delete
bindkey "\e[3;5~" kill-word
# urxvt
bindkey "\e[3^" kill-word
# ctrl+backspace
bindkey '^H' backward-kill-word
# ctrl+shift+delete
bindkey "\e[3;6~" kill-line
# urxvt
bindkey "\e[3@" kill-line


# -- ALIASES
alias l='ls --color -lhF --group-directories-first'
alias nv='echo you are stupid'
alias python='python3'
alias tmux='tmux -u'


# -- PLUGINS
source $XDG_CONFIG_HOME/antigen/antigen.zsh

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
