#!/usr/bin/env bash

#  read global rc configurations
source "/etc/profile"
[ -r ${HOME}/.bashrc ] && source ${HOME}/.bashrc

#  check for colours
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1="${PS1}\[\033[0;33m\]jstd\[\033[00m\]> "
else
    PS1="${PS1}jstd> "
fi
unset color_prompt force_color_prompt

#  loading config
source $ENV_GLOBAL_JSTD_DIR/scripts/helpers.sh
load_config $ENV_GLOBAL_JSTD_DIR/stuff $ENV_LOCAL_JSTD_DIR

#  Completion for run:
#
#  run TestCase
#
_run_tests()
{
    local cur prev opts cur_pwd test_files
    test_files=`grep '.js' $ENV_LOCAL_JSTD_DIR/${jstd_config_file} | sed 's/\s*-\s*\(.*\)/\1/' | tr "\\n" " "`

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    cur_pwd=$PWD
    cd $ENV_LOCAL_JSTD_DIR/..

    opts=`grep 'TestCase' ${test_files} | sed 's/.*TestCase\s*(\s*['"'"'"]\([^'"'"'"]*\).*/\1/'`
    cd $cur_pwd

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _run_tests run

alias startsrv="jstd start"

if [ -n $TRY_TO_START_SRV_ON_PORT ]; then
    jstd start $TRY_TO_START_SRV_ON_PORT
fi