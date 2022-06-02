# variable {{{
uname | read os_name
if [ "$os_name" = "Darwin" ]
  eval (/opt/homebrew/bin/brew shellenv)

else if [ "$os_name" = "Linux" ]
  if [ (uname -r | grep 'microsoft') ]
    set -x WSL_HOST (cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    set -x ADB_SERVER_SOCKET tcp:$WSL_HOST:5037
    set -x DISPLAY $WSL_HOST:0.0
  end

  # set -x DefaultImModule fcitx
  # set -x GTK_IM_MODULE fcitx
  # set -x QT_IM_MODULE fcitx
  # set -x XMODIFIERS '@im=fcitx'

  # set -x LC_ALL en_US.UTF-8
  # set -x LC_ALL ja_JP.UTF-8
end


# set -x fish_ambiguous_width 2

set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.deno/bin $PATH


# }}}
# function {{{
function executable
  type $argv[1] >/dev/null 2>&1
end

function pbc
  cat $argv[1] | pbcopy
end

function d-rldc2
  docker run --rm -ti -v (pwd):/src dlanguage/ldc:0.17.0 ldc2 -run $argv[1]
end

# }}}
# source {{{
source $HOME/.asdf/asdf.fish

if [ "$os_name" = "Darwin" ]
  # source ~/.iterm2_shell_integration.(basename $SHELL)
else if [ "$os_name" = "Linux" ]
end

if executable opam
  eval (opam config env)
  eval (opam env)
end
# }}}
# alias {{{
alias lvim=(which vim)
alias vim=nvim
alias vi=nvim
alias rldc='ldc2 --run'
alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

function em
  env TERM=xterm-24bit emacs -nw .emacs.d/init.el $argv
end
alias emacs=em

if executable exa
  alias ls='exa --icons'
end

if executable rg
  alias grep='rg'
end

if executable bat
  alias cat='bat --theme=gruvbox-light'
end



if [ "$os_name" = "Darwin" ]
  alias rm=mv2trash
else if [ "$os_name" = "Linux" ]
  # alias rm=rmtrash
  alias open='xdg-open'
  alias emulator='emulator.exe'

  if executable xclip
    alias pbcopy='xclip -selection c'
    alias pbpaste='xclip -selection c -o'
  end
end
# }}}

if not functions -q fisher
  echo 'not installed fisher'
  echo 'please type this: fish $HOME/dotfiles/etc/init/linux/fisher.fish'
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
end

set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

set -g theme_display_node yes
