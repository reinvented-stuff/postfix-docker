#!/bin/sh
#
# Start Postfix in the foreground, as the container's process 1.
#
# Run as process 1, "postfix start-fg" execs master(8) in init mode (-i), so
# the signal "docker stop" sends, SIGTERM, reaches master itself, as the one
# "postfix stop" sends does: master passes it on to its child processes and
# exits (master(8), SIGTERM). Logging to standard output, with
# "maillog_file = /dev/stdout", needs start-fg too (postconf(5), maillog_file).
#
set -eu

config_directory=/etc/postfix

for config_file in main.cf master.cf; do
    if [ ! -f "${config_directory}/${config_file}" ]; then
        echo "postfix-docker: ${config_directory}/${config_file} not found" >&2
        exit 1
    fi
done

exec postfix start-fg
