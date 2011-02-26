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
