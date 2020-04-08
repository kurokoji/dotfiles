# Created by newuser for 5.7.1
source $HOME/.switch_proxy
autoload -U compinit promptinit
compinit
promptinit

### Added by Zinit's installer {{{
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
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

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias vim=nvim
alias ls='ls -G'
alias la='ls -la'
alias pbc='(){ cat $1 | pbcopy }'

# PATH
export PATH=$HOME/.anyenv/bin:$PATH

eval "$(anyenv init -)"
