# variable {{{
set -x PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
set -x PATH $HOME/.pyenv/shims $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.dub/packages/.bin/dls-latest $PATH
set -x PATH /usr/local/opt/llvm/bin $PATH
set -x MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH

set -x LDFLAGS -L/usr/local/opt/llvm/lib $LDFLAGS
set -x CPPFLAGS -I/usr/local/opt/llvm/include $CPPFLAGS
# }}}
# source {{{
source $HOME/.config/fish/switch_proxy.fish
eval (pyenv init - | source)
# }}}
# alias {{{
alias vim=nvim
alias vi=nvim
alias v=nvim
alias rldc2='ldc2 --run'
# }}}

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

