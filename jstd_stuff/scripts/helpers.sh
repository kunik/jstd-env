#! bash

pid_file_name="JsTestDriver.pid"

function load_config {
    source "${1}/default_config.sh"

    if [ -f "${2}/local_config.sh" ]; then
        source "${2}/local_config.sh"
    fi

    if [ -f "${2}/port.sh" ]; then
        source "${2}/port.sh"
    fi
}

function get_status {
    echo "$ENV_LOCAL_JSTD_DIR/${pid_file_name}"

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
