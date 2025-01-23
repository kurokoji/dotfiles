#!/bin/zsh
# Created by newuser for 5.7.1

# source $HOME/.switch_proxy

### Added by Zinit's installer {{{
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk }}}

setopt auto_cd
setopt auto_list
setopt auto_menu
setopt no_beep

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
# zinit light denysdovhan/spaceship-prompt
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=100000

# variable {{{

case ${OSTYPE} in
  darwin*)
    eval $(/opt/homebrew/bin/brew shellenv)
    # source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
esac

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse"
export FZF_REVERSE_ISEARCH_OPTS="--reverse --height=100%"
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.deno/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

# }}}
# function {{{

executable() {
  type $1 >/dev/null 2>&1
}

pbc() {
  cat $1 | pbcopy
}

# }}}
# source {{{

source $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}
# alias {{{

case ${OSTYPE} in
  darwin*)
    alias rm='mv2trash'

  ;;
  linux*)
    alias open='xdg-open'

    if executable xclip ; then
      alias pbcopy='xclip -selection c'
      alias pbpaste='xclip -selection c -o'
    fi

    if executable xsel ; then
      alias pbcopy='xsel -bi'
      alias pbpaste='xsel -b'
    fi
  ;;
esac

if executable eza ; then
  alias ls='eza --icons'
fi

if executable rg; then
  alias grep='rg'
fi

if executable bat; then
  alias cat='bat'
fi


alias lvim=$(which -p vim)
if executable nvim; then
  alias vi=vim
  alias vim=nvim
fi

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# }}}

autoload -U compinit promptinit && compinit
promptinit
