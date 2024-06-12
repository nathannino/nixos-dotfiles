#!/bin/sh

PIPE_FILE="${XDG_RUNTIME_DIR}/customnotif-output"

while true
do
	cat "${PIPE_FILE}"
done
