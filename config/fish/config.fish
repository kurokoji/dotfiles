# variable {{{
uname | read os_name
if [ "$os_name" = "Darwin" ]
  eval (/opt/homebrew/bin/brew shellenv)
  # set -x PATH /opt/homebrew/opt/binutils/bin $PATH

  # set -x LDFLAGS "-L/opt/homebrew/opt/binutils/lib" $LDFLAGS
  # set -x CPPFLAGS "-I/opt/homebrew/opt/binutils/include" $CPPFLAGS
  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/libpq/lib/pkgconfig"

else if [ "$os_name" = "Linux" ]
  if [ (uname -r | grep 'microsoft') ]
    # set -x WSL_HOST (cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    # set -x ADB_SERVER_SOCKET tcp:$WSL_HOST:5037
    # set -x DISPLAY $WSL_HOST:0.0
  end

  # set -x DefaultImModule fcitx
  # set -x GTK_IM_MODULE fcitx
  # set -x QT_IM_MODULE fcitx
  # set -x XMODIFIERS '@im=fcitx'

  # set -x LC_ALL en_US.UTF-8
  # set -x LC_ALL ja_JP.UTF-8
end


# set -x fish_ambiguous_width 2

set -x FZF_DEFAULT_OPTS "--height 40% --layout=reverse"
set -x PATH $HOME/dotfiles/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.deno/bin $PATH
set -x PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH


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
# source $HOME/.asdf/asdf.fish
source $HOME/.config/fish/scripts/asdf.fish

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

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

if executable eza
  alias ls='eza --icons'
  alias la='ls -a'
end

if executable rg
  alias grep='rg'
end

if executable bat
  alias cat='bat --theme=gruvbox-light'
end

if [ "$os_name" = "Darwin" ]
    # alias rm=mv2trash
else if [ "$os_name" = "Linux" ]
  # alias rm=rmtrash
  alias open='xdg-open'
  alias emulator='emulator.exe'

  if executable xclip
    alias pbcopy='xclip -selection c'
    alias pbpaste='xclip -selection c -o'
  end

  if executable xsel
    alias pbcopy='xsel -bi'
    alias pbpaste='xsel -b'
  end
end
# }}}
# color {{{
source $HOME/.config/fish/colors/dawnfox_fish.fish
# }}}

if not functions -q fisher
  echo 'not installed fisher'
  echo 'please type this: fish $HOME/dotfiles/etc/init/linux/fisher.fish'
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
end

set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

set -g theme_display_node yes


# pnpm
# set -gx PNPM_HOME "/Users/s-kakiha/Library/pnpm"
# if not string match -q -- $PNPM_HOME $PATH
#   set -gx PATH "$PNPM_HOME" $PATH
# end
# pnpm end
