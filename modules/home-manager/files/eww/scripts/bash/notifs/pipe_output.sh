#!/bin/sh

PIPE_FILE="${XDG_RUNTIME_DIR}/customnotif-output"

while [ ! -f "${PIPE_FILE}" ];
do
	sleep 1;
done


cat "${PIPE_FILE}" & ~/.config/eww/scripts/bash/notifs/pipe_input.sh "reload"
echo ""

while true
do
	cat "${PIPE_FILE}"
	echo ""
done
