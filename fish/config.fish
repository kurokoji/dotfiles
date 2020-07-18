# variable {{{
uname | read os_name
if [ "$os_name" = "Darwin" ]
  set -x SDKROOT /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk $SDKROOT

  #  set -x PATH $PYENV_ROOT/shims $PATH
  set -x PATH /usr/local/opt/llvm/bin $PATH
  set -x PATH /usr/local/opt/go/libexec/bin $PATH
  set -x PATH /Applications/MEGAcmd.app/Contents/MacOS $PATH
  set -x PATH $HOME/.cpan $PATH
  set -x PATH $HOME/.local/bin/bin $PATH
  set -x PATH $HOME/.local/bin $PATH
  set -x PATH /usr/local/sbin $PATH
  set -x PATH $HOME/.bin/ $PATH
  set -x PATH $HOME/.anyenv/bin $PATH
  set -x PATH /usr/local/texlive/2019/bin/x86_64-darwin $PATH
  set -x PATH $HOME/Library/Android/sdk/platform-tools $PATH

  set -x LDFLAGS -L/usr/local/opt/llvm/lib $LDFLAGS
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
  set -x PKG_CONFIG_PATH /opt/X11/lib/pkgconfig $PKG_CONFIG_PATH

  set -x MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH
  set -x MANPATH /usr/local/texlive/2019/texmf-dist/doc/man $MANPATH

  set -x INFOPATH /usr/local/texlive/2019/texmf-dist/doc/info $INFOPATH

  set -x cc gcc-8


else if [ "$os_name" = "Linux" ]
  set -x PATH $HOME/.anyenv/bin $PATH
  set -x PATH $HOME/.local/bin $PATH
  set -x PATH $HOME/.bin $PATH

  set -x PATH $HOME/.cargo/bin $PATH


  set -x WSL_HOST (cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
  set -x ADB_SERVER_SOCKET tcp:$WSL_HOST:5037
  set -x DISPLAY $WSL_HOST:0.0
  set -x GDK_SCALE 0.5
  set -x GDK_DPI_SCALE 2
  # set -x LIBGL_ALWAYS_INDIRECT 1

  # set -x CUDA_HOME /usr/local/cuda-10.1
  # set -x LD_LIBRARY_PATH $CUDA_HOME/lib64 $LD_LIBRARY_PATH
  # set -x PATH $CUDA_HOME/bin $PATH
  # set -x PATH $PATH /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin

  # set -x DefaultImModule fcitx
  # set -x GTK_IM_MODULE fcitx
  # set -x QT_IM_MODULE fcitx
  # set -x XMODIFIERS '@im=fcitx'

  # set -x LC_ALL en_US.UTF-8
  # set -x LC_ALL ja_JP.UTF-8
end


# set -x fish_ambiguous_width 2

# }}}
# source {{{
source $HOME/.config/fish/switch_proxy.fish
anyenv init - fish | source
eval (opam config env)

if [ "$os_name" = "Darwin" ]
  source ~/.iterm2_shell_integration.(basename $SHELL)
else if [ "$os_name" = "Linux" ]
end

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
# alias {{{
alias lvim=(which vim)
alias vim=nvim
alias vi=nvim
alias rldc='ldc2 --run'
alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

if executable exa
  alias ls='exa'
end

if executable rg
  alias grep='rg'
end

if executable bat
  alias cat='bat'
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
#
set -g theme_display_node yes
