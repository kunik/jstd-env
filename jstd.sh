#!/usr/bin/env bash

old_path=""
jstd_dir=".jstd"
script_dir="$( cd "$( dirname "$0" )" && pwd )"
stuff_dir="$script_dir/stuff"

function set_up {
    old_path=$PATH
    export PATH="/tmp:$PATH"
    echo "You are in jstd env now! To exit, press Ctrl+D."
}

function tear_down {
    export PATH=$old_path
    echo "Bye!!!"
}

function create {
    echo "1) Creating directory for jstd stuff"
    mkdir ${jstd_dir}

    echo "2) Creating symlink on jstd jar"
    ln -s $stuff_dir/JsTestDriver.jar ${jstd_dir}

    echo "3) Creating new config"
    cp $stuff_dir/jstd.conf ${jstd_dir}

    echo ""
    enter
}

function enter {
    if [ ! -d ${jstd_dir} ]; then
        echo "jstd env was not created"
        exit 1
    fi

    set_up
    bash
    tear_down
}

function print_help {
    cat - <<HLP
Jstd-env is a helper script that should help writing and running tests as much quickly and easy as possible.
It creates ${jstd_dir} dir with jsTestDriver, it's config and other cool stuff inside your working copy and
allows you to run tests with single 'run' command.

Usage:
    $0 create    creates ${jstd_dir} dir with virtual environment for you and enters it
    $0 enter     enters current virtual environment
    $0 help      prints the current message
HLP
}



function main {
    case $1 in
        create  ) create ;;
        enter   ) enter ;;
        help    ) print_help ;;
        *       ) print_help
    esac
}

main $*
exit 0