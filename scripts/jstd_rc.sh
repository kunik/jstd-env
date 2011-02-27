#!/usr/bin/env bash

#  read global rc configurations
source "/etc/profile"
[ -r ${HOME}/.bashrc ] && source ${HOME}/.bashrc

#  check for colours
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

#force_color_prompt=yes
#
#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#        color_prompt=yes
#    else
#        color_prompt=
#    fi
#fi

if [ "$color_prompt" = yes ]; then
    PS1="${PS1}\[\033[0;33m\]jstd\[\033[00m\]> "
else
    PS1="${PS1}jstd> "
fi
unset color_prompt force_color_prompt

#  Completion for run:
#
#  run TestCase
#
_run_tests()
{
    local cur prev opts

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=`grep 'TestCase' src/**.js tests/*.js | sed 's/.*TestCase\s*(\s*['"'"'"]\([^'"'"'"]*\).*/\1/'`

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _run_tests run
