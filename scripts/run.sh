#!/bin/bash

stuff_dir="$ENV_GLOBAL_JSTD_DIR/stuff"
scripts_dir="$ENV_GLOBAL_JSTD_DIR/scripts"

source "${scripts_dir}/helpers.sh"

function main {
    load_config ${stuff_dir} $ENV_LOCAL_JSTD_DIR

    tests="$1"
    if [ -z ${tests} ]; then
        tests="all"
    fi

    java -jar "$ENV_LOCAL_JSTD_DIR/JsTestDriver.jar" --tests $tests --server ${jstd_host}:${jstd_port} --config $ENV_LOCAL_JSTD_DIR/jstd.conf
}

main $*
exit 0