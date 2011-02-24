#!/usr/bin/env bash

old_path=""
function set_up {
    echo $PATH
    old_path=$PATH
    export PATH="/tmp:$PATH"
    echo $PATH
}

function tear_down {
    echo $PATH
    export PATH=$old_path
    echo $PATH
    echo "Bye!!!"
}

set_up
bash
tear_down