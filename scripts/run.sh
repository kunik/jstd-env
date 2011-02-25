#!/bin/bash

stuff_dir="$ENV_GLOBAL_JSTD_DIR/stuff"
scripts_dir="$ENV_GLOBAL_JSTD_DIR/scripts"

source "${scripts_dir}/helpers.sh"

opts_capture_console="--captureConsole"
opts_verbose="--verbose"
opts_preload_files="--preloadFiles"
opts_reset_runner="--reset"

opts_plugins=""
function main {
    load_config ${stuff_dir} $ENV_LOCAL_JSTD_DIR
    read_options

    tests="$1"
    if [ -z ${tests} ]; then
        tests="all"
    fi

    java -jar "$ENV_LOCAL_JSTD_DIR/JsTestDriver.jar"  \
             --basePath $ENV_LOCAL_JSTD_DIR/..  \
             --tests $tests  \
             --server http://${jstd_host}:${jstd_port}  \
             --config $ENV_LOCAL_JSTD_DIR/${jstd_config_file}  \
             ${opts_capture_console} ${opts_verbose} ${opts_preload_files} ${opts_reset_runner} ${opts_plugins}
}

function read_options {
    if [ ${jstd_options_capture_console} != "1" ]; then
        opts_capture_console=""
    fi

    if [ ${jstd_options_verbose} != "1" ]; then
        opts_verbose=""
    fi

    if [ ${jstd_options_preload_files} != "1" ]; then
        opts_preload_files=""
    fi

    if [ ${jstd_options_reset_runner} != "1" ]; then
        opts_reset_runner=""
    fi

#    if [ ${#jstd_options_plugins[@]} -gt 0 ]; then
#        opts_plugins="--plugins .jstd/${jstd_options_plugins[0]}"
#        for element in $(seq 1 $((${#jstd_options_plugins[@]} - 1)))
#            do
#                opts_plugins="${opts_plugins}, .jstd/${jstd_options_plugins[${element}]}"
#            done
#    fi
}

main $*
exit 0