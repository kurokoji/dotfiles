# variable {{{
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.dub/packages/.bin/dls-latest $PATH
set -x PATH $HOME/.dub/packages/serve-d-0.4.1/serve-d $PATH

set -x GOPATH $HOME/.go $GOPATH
set -x PYENV_ROOT $HOME/.pyenv $PYENV_ROOT

set -x PATH $GOPATH/bin $PATH

uname | read os_name
if [ "$os_name" = "Darwin" ]
  set -x SDKROOT /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk $SDKROOT

  #  set -x PATH $PYENV_ROOT/shims $PATH
  set -x PATH /usr/local/opt/llvm/bin $PATH
  set -x PATH /usr/local/opt/go/libexec/bin $PATH
  set -x PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
  set -x PATH /Applications/MEGAcmd.app/Contents/MacOS $PATH
  set -x PATH $HOME/.chrome-avgle-helper $PATH
  set -x PATH $HOME/.cpan $PATH
  set -x PATH $HOME/.local/bin/bin $PATH
  set -x PATH $HOME/.local/bin $PATH
  set -x PATH /usr/local/sbin $PATH
  set -x PATH $HOME/.anyenv/bin $PATH

  set -x LDFLAGS -L/usr/local/opt/llvm/lib $LDFLAGS
  set -x LDFLAGS -L/usr/local/opt/zlib/lib $LDFLAGS
  set -x LDFLAGS -L/Users/nazuna/.local/lib/ $LDFLAGS
  set -x LDFLAGS -L/usr/local/opt/openblas/lib $LDFLAGS
  set -x LDFLAGS -L/usr/local/opt/readline/lib $LDFLAGS
  set -x LDFLAGS -L/usr/local/opt/openssl/lib $LDFLAGS

  set -x CFLAGS -I/usr/local/opt/openssl/include $CFLAGS

  set -x CPPFLAGS -I/usr/local/opt/llvm/include $CPPFLAGS
  set -x CPPFLAGS -I/usr/local/opt/zlib/include $CPPFLAGS
  set -x CPPFLAGS -I/usr/local/opt/openblas/include $CPPFLAGS
  set -x CPPFLAGS -I/Users/nazuna/.local/include/rpc $CPPFLAGS
  set -x CPPFLAGS -I/usr/local/opt/openssl/include $CPPFLAGS
  set -x CPPFLAGS -I/usr/local/opt/readline/include $CPPFLAGS

  set -x PKG_CONFIG_PATH /usr/local/opt/zlib/lib/pkgconfig $PKG_CONFIG_PATH
  set -x PKG_CONFIG_PATH /usr/local/opt/openblas/lib/pkgconfig $PKG_CONFIG_PATH
  set -x PKG_CONFIG_PATH $HOME/.local/lib/pkgconfig $PKG_CONFIG_PATH

  set -x MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

  set -x cc gcc-8

else if [ "$os_name" = "Linux" ]
  set -x PATH $HOME/.pyenv/bin $PATH
end


# set -x fish_ambiguous_width 2

# }}}
# source {{{
source $HOME/.config/fish/switch_proxy.fish
anyenv init - fish | source
eval (opam config env)
# }}}
# alias {{{
alias lvim=/usr/local/bin/vim
alias vim=nvim
alias vi=nvim
alias rldc='ldc2 --run'
alias luajitlatex='luajittex --fmt=luajitlatex.fmt'
alias rm=mv2trash
# }}}
# function {{{

function pbc
  cat $argv[1] | pbcopy
end

# }}}

if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher
end

# Fish git prompt
# set __fish_git_prompt_showdirtystate 'yes'
# set __fish_git_prompt_showstashstate 'yes'
# set __fish_git_prompt_showuntrackedfiles 'yes'
# set __fish_git_prompt_showupstream 'yes'
# set __fish_git_prompt_color_branch yellow
# set __fish_git_prompt_color_upstream_ahead green
# set __fish_git_prompt_color_upstream_behind red

# Status Chars
# set __fish_git_prompt_char_dirtystate '⚡'
# set __fish_git_prompt_char_stagedstate '→'
# set __fish_git_prompt_char_untrackedfiles '☡'
# set __fish_git_prompt_char_stashstate '↩'
# set __fish_git_prompt_char_upstream_ahead '+'
# set __fish_git_prompt_char_upstream_behind '-'
