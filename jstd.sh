#!/usr/bin/env bash

jstd_dir=".jstd"
start_stop_timeout=2

local_jstd_dir="$PWD/${jstd_dir}"
script_dir="$( cd "$( dirname "$0" )" && pwd )"
stuff_dir="${script_dir}/stuff"
scripts_dir="${script_dir}/scripts"

source ${scripts_dir}/helpers.sh

function main {
    load_config ${stuff_dir} ${local_jstd_dir}

    case $1 in
        create  ) create;;
        enter   ) enter ;;

        start   ) start $2 ;;
        restart ) restart ;;
        stop    ) stop ;;
        status  ) status ;;

        help | *) print_help
    esac
}


function print_help {
    cat - <<HLP
Jstd-env is a helper script that should help writing and running tests as much quickly and easy as possible.
It creates ${jstd_dir} dir with jsTestDriver, it_s config and other cool stuff inside your working copy and
allows you to run tests with single "run" command.

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
    create_directory

    echo "2) Creating symlink on jstd jar"
    create_symlinks

    echo "3) Creating new config"
    create_config_file

    echo ""
}

function create_directory {
    if [ -d ${jstd_dir} ]; then
        echo "There is directory with name ${jstd_dir} in current folder. [ Skipping ]"
    else
        mkdir ${jstd_dir}
    fi
}

function create_symlinks {
    if [ -a ${jstd_dir}/JsTestDriver.jar ]; then
        echo "The JsTestDriver.jar is already in your ${jstd_dir} folder. [ Skipping ]"
    else
        ln -s ${stuff_dir}/JsTestDriver.jar ${jstd_dir}
    fi

    if [ ! -a ${jstd_dir}/JsTestDriver.jar ]; then
        ln -s ${scripts_dir}/run.sh ${jstd_dir}/run
        #chmod +x ${jstd_dir}/run
    fi
}

function create_config_file {
    if [ -a ${jstd_dir}/${jstd_config_file} ]; then
        echo "You already have config in your ${jstd_dir} folder.         [ Skipping ]"
    else
        cp ${stuff_dir}/${jstd_config_file} ${jstd_dir}
    fi

    if [ ! -a ${jstd_dir}/local_config.sh ]; then
        cat ${stuff_dir}/default_config.sh | awk '{ print "# " $0 }' > ${jstd_dir}/local_config.sh
    fi
}

function enter {
    local create_env

    if [ ! -d ${jstd_dir} ]; then
        printf "You are not able to enter non existing env. Do you want to create it now?  [Y/n] "
        read create_env

        if [ -z ${create_env} ] || [ ${create_env} == "y" ] || [ ${create_env} == "Y" ]; then
            create
        else
            echo "Failed"
            exit 1
        fi

    fi

    enter_the_env
}

function enter_the_env {
    set_up
    bash --rcfile ${scripts_dir}/jstd_rc.sh
    tear_down
}

function start {
    local start_on_port create_env

    start_on_port=$1
    if [ -z ${start_on_port} ]; then
        start_on_port=${jstd_port}
    fi

    if [ ! -n "${ENV_LOCAL_JSTD_DIR:+1}" ]; then
        printf "To start JsTestDriver server you need to enter the env. Do you want to do it right now? [Y/n] "
        read create_env

        if [ -z ${create_env} ] || [ ${create_env} == "y" ] || [ ${create_env} == "Y" ]; then
            export TRY_TO_START_SRV_ON_PORT=$start_on_port
            enter
        else
            echo "Failed"
        fi
        exit 4
    fi

    get_status
    if [ $? -eq 1 ]; then
        echo "Service is already running"
        exit 5
    fi

    echo "Starting server on ${jstd_host}:${start_on_port}"
    echo "jstd_port=\"${start_on_port}\"" > "${local_jstd_dir}/port.sh"

    java -jar "${local_jstd_dir}/JsTestDriver.jar" --port "${start_on_port}" &
    echo $! > "${local_jstd_dir}/${pid_file_name}"

    sleep ${start_stop_timeout}

    get_status
    if [ $? -eq 1 ]; then
        echo "Done"
    else
        echo "Failed"
    fi
}

function stop {
    get_status
    if [ $? -ne 1 ]; then
        echo "Server is not running"
        exit 3
    fi

    echo "Stopping server"
    kill `cat "$ENV_LOCAL_JSTD_DIR/${pid_file_name}"`

    sleep $start_stop_timeout

    get_status
    if [ $? -eq 1 ]; then
        echo "Failed"
    else
        echo "Done"
        rm "$ENV_LOCAL_JSTD_DIR/${pid_file_name}"
    fi
}

function restart {
    stop
    start
}

function status {
    get_status
    if [ $? -eq 1 ]; then
        echo "Running"
    else
        echo "Stopped"
    fi
}

function get_status {
    local lines_count

    if [ ! -f "$ENV_LOCAL_JSTD_DIR/${pid_file_name}" ]; then
        return 0
    fi

    lines_count=`ps a | grep \`cat "$ENV_LOCAL_JSTD_DIR/${pid_file_name}"\` | wc -l`
    if [ $lines_count -gt 1 ]; then
        return 1
    else
        return 0
    fi
}


function set_up {
    update_vars
    echo "You are in jstd env now! To exit, press Ctrl+D."
}

function update_vars {
    export PATH="${local_jstd_dir}:$PATH"
    export ENV_LOCAL_JSTD_DIR="${local_jstd_dir}"
    export ENV_GLOBAL_JSTD_DIR="${script_dir}"
}

function tear_down {
    get_status
    if [ $? -eq 1 ]; then
        stop
    fi

    echo "Bye!!!"
}


main $*
exit 0