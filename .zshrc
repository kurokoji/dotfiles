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

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light denysdovhan/spaceship-prompt
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# variable {{{

case ${OSTYPE} in
  darwin*)
    eval $(/opt/homebrew/bin/brew shellenv)
    source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
    export PATH=$HOME/.bin:$PATH
    export PATH=$HOME/local/bin:$PATH
esac

# }}}
# function {{{

executable() {
  type $1 >/dev/null 2>&1
}


case ${OSTYPE} in
  linux*)
    if executable xclip ; then
      alias pbcopy='xclip -selection c'
      alias pbpaste='xclip -selection c -o'
    fi
esac

# }}}
# source {{{

source $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

# }}}
# alias {{{

if executable exa ; then
  alias ls='exa --icons'
fi

if executable rg; then
  alias grep='rg'
fi

if executable bat; then
  alias cat='bat'
fi


if executable nvim; then
  alias vi=vim
  alias vim=nvim
fi

alias pbc='(){ cat $1 | pbcopy }'
# }}}

autoload -U compinit promptinit && compinit
promptinit
