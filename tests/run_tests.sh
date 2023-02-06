#!/bin/bash

RUN_TESTS_SCRIPT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${RUN_TESTS_SCRIPT}/utils

if [ ${PWD##*/} != "yalda" ]; then
    log_warn "Run tests from 'YALDA' directory."
    exit 1
fi

usage=$(cat <<EOF
YALDA smoke tests runner.

Usage: $(basename $0) [-c config] [-t test]
    options:
        c   Config file name
        t   Test name
EOF
)

function _list_file_name_in_dir {
    local dir_path="$1"

    local file_name_list=()
    shopt -s nullglob
    local file_path_list=($dir_path/*)
    for file_path in "${file_path_list[@]}"; do
        local file_name=${file_path##*/}
        file_name_list+=(${file_name})
    done

    echo ${file_name_list[*]}
}

export ROOT_DIR=$(pwd)
TESTS_DIR=${ROOT_DIR}/tests
TEST_CONFIG_DIR=${TESTS_DIR}/config
TEST_FILE_PATH=${TESTS_DIR}/test_source

all_config_file_list=$(_list_file_name_in_dir ${TEST_CONFIG_DIR})
source ${TEST_FILE_PATH}
all_test_list=$(get_test_list)
config_file_list=()
test_list=()

while getopts ":h:c:t:" opt; do
    case $opt in
        h)
            echo "$usage"; exit 0
            ;;
        c)
            config_file_arg=$OPTARG
            if [[ "${all_config_file_list[*]}" =~ "${config_file_arg}" ]]; then
                config_file_list=${config_file_arg}
            else
                log_warn "ERROR! Config file '$config_file_arg' does not exist."
                exit 1
            fi
            ;;
        t)
            test_name_arg=$OPTARG
            if [[ "${all_test_list[*]}" =~ "${test_name_arg}" ]]; then
                target_list=${test_name_arg}
            else
                log_warn "ERROR! Test '$test_name_arg' does not exist."
                exit 1
            fi
            ;;
        \?)
            log_warn "Invalid option: -$OPTARG" >/dev/stderr; exit 1
            ;;
        :)
            log_warn "Option -$OPTARG requires an argument." >/dev/stderr; exit 1
            ;;
    esac
done

if [ ${#config_file_list[@]} -eq 0 ]; then
    config_file_list=${all_config_file_list}
fi

if [ ${#test_list[@]} -eq 0 ]; then
    test_list=${all_test_list}
fi

log_info "Config(s) to be tested: ${config_file_list[*]}"
log_info "Test(s) to be performed: ${test_list[*]}"

# Tests
failed_test_count=0
for config_file in ${config_file_list[@]}; do
    # Save test results in a separate directory for each config
    TEST_CONFIG_RESULT_DIR=${TESTS_DIR}/generated/${config_file}
    mkdir -p ${TEST_CONFIG_RESULT_DIR}
    # Save components in a separate directory for each config
    mkdir -p ${TEST_CONFIG_RESULT_DIR}/components

    TEST_CONFIG_DIR=${TESTS_DIR}/config
    TEST_CONFIG_FILE=${TEST_CONFIG_DIR}/${config_file}

    # Exports use when yalda script source environment file
    # TODO: Reimplement more straightforward
    export TEST_CONFIG_FILE
    export TEST_CONFIG_RESULT_DIR

    test_build ${TESTS_DIR}/env
    if [ "$?" -ne 0 ]; then
        log_warn "Build test failed."
        failed_test_count=$((${failed_test_count} + 1))
    fi
done

if [[ ${failed_test_count} == 0 ]]; then
    log_info "All tests passed."
    exit 0
else
    log_info "Tests failed."
    exit 1
fi