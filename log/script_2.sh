#!/bin/bash

LOG_DIR=$1
BACKUP_DIR="./backup"

generate_files() {
    local file_size=$2
    local file_count=$1

    for i in $(seq 1 $file_count); do
	dd if=/dev/zero of="$LOG_DIR/file_$i.log" bs=1M count=$file_size status=none
	touch -d "$((RANDOM % 20 + 1)) days ago" "$LOG_DIR/file_$i.log"
    done
}

cleanup() {
    rm -f $LOG_DIR/file_*.log
}


test_1() {
    echo "Test 1...(Current usage < N)...Generating 5 files of 200 MB"
    generate_files 5 200
    ./script_1.sh $LOG_DIR 99 1
    cleanup
    echo "================================"
}

test_2() {
    echo "Test 2...(Current usage > N)...Generating 5 files of 200 MB"
    generate_files 5 200
    ./script_1.sh $LOG_DIR 1 5
    cleanup
    echo "================================"
}

test_3() {
    echo "Test 3...(Current usage > N, but number of files < X)...Generating 2 files of 1 GB"
    generate_files 2 1000
    ./script_1.sh $LOG_DIR 1 5
    cleanup
    echo "================================"
}

test_4() {
    echo "Test 4...(Stress test, current usage > N)...Generating 500 files of 2 MB"
    generate_files 500 2
    ./script_1.sh $LOG_DIR 1 150
    cleanup
    echo "================================"
}

test_1
test_2
test_3
test_4
