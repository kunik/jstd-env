#!/usr/bin/env bash

jstd_dir=".jstd"
local_jstd_dir="$PWD/${jstd_dir}"
script_dir="$( cd "$( dirname "$0" )" && pwd )"
stuff_dir="${script_dir}/stuff"

jstd_env_flag="${local_jstd_dir}/env_entered"
jstd_server_pid_file="${local_jstd_dir}/JsTestDriver.pid"

function main {
    load_config

    case $1 in
        create  ) create ;;
        enter   ) enter ;;

        start   ) start $2 ;;
        restart ) restart ;;
        stop    ) stop ;;
        status  ) status ;;

        help    ) print_help ;;
        *       ) print_help
    esac
}

function load_config {
    source "${stuff_dir}/default_config.sh"

    if [ -f "${local_jstd_dir}/local_config.sh" ]; then
        source "${local_jstd_dir}/local_config.sh"
    fi

    if [ -f "${local_jstd_dir}/port.sh" ]; then
        source "${local_jstd_dir}/port.sh"
    fi
}


function print_help {
    cat - <<HLP
Jstd-env is a helper script that should help writing and running tests as much quickly and easy as possible.
It creates ${jstd_dir} dir with jsTestDriver, it's config and other cool stuff inside your working copy and
allows you to run tests with single 'run' command.

Usage:
    $0 help            prints the current message

    $0 create          creates ${jstd_dir} dir with virtual environment for you and enters it
    $0 enter           enters current virtual environment

    $0 start [<port>]  starts jsTestDriver server on specified port. If port is not specified it tryes to get
                       it from config or uses default one (Uses ${jstd_port} in current env)
    $0 stop            stops running jsTestDriver server
    $0 restart         restarts running jsTestDriver server
    $0 status          returns information if jsTestDriver server is running
HLP
}

function create {
    echo "1) Creating directory for jstd stuff"
    mkdir ${jstd_dir}

    echo "2) Creating symlink on jstd jar"
    ln -s ${stuff_dir}/JsTestDriver.jar ${jstd_dir}

    echo "3) Creating new config"
    cp ${stuff_dir}/jstd.conf ${jstd_dir}

    echo ""
    enter
}

function enter {
    if [ ! -d ${jstd_dir} ]; then
        echo "Jstd env was not created"
        exit 1
    fi

    set_up
    bash
    tear_down
}

function start {
    check_if_can_work_with_server

    start_on_port=$1
    if [ -z ${start_on_port} ]; then
        start_on_port=${jstd_port}
    fi

    echo "Starting server on ${jstd_host}:${start_on_port}"
    echo "jstd_port=\"${start_on_port}\"" > "${local_jstd_dir}/port.sh"

    java -jar "${local_jstd_dir}/JsTestDriver.jar" --port "${start_on_port}" &
    echo $! > ${jstd_server_pid_file}

    get_status
    echo $?
    if [ $? -eq 1 ]; then
        echo "Done"
    else
        echo "Failed"
    fi
}

function stop {
    check_if_can_work_with_server
    echo "Stopping server"
    kill `cat ${jstd_server_pid_file}`

    get_status
    echo $?
    if [ $? -eq 1 ]; then
        echo "Failed"
    else
        echo "Done"
        rm ${jstd_server_pid_file}
    fi
}

function restart {
    stop
    start
}

function status {
    check_if_can_work_with_server

    get_status
    echo $?
    if [ $? -eq 1 ]; then
        echo "Running"
    else
        echo "Stopped"
    fi
}

function get_status {
    sleep 1
    if [ ! -f ${jstd_server_pid_file} ]; then
        return 0
    fi

    lines_count=`ps a | grep \`cat ${jstd_server_pid_file}\` | wc -l`
    return $((${lines_count} - 1))
}

function check_if_can_work_with_server {
    if [ ! -f ${jstd_env_flag} ]; then
        echo "You should enter the env to start/stop/restart jsTestDriver server"
        exit 2
    fi
}



function set_up {
    update_vars
    add_run_completion
    touch ${jstd_env_flag}
    echo "You are in jstd env now! To exit, press Ctrl+D."
}

function update_vars {
    export PATH="${local_jstd_dir}:$PATH"
}

function add_run_completion {
    echo "=="
}

function tear_down {
    if [ -f ${jstd_env_flag} ]; then
        rm ${jstd_env_flag}
    fi

    echo "Bye!!!"
}


main $*
exit 0