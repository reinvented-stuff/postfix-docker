#!/bin/sh
#
# Entrypoint script
#

POSTFIX_CONF_DIR="/etc/postfix"

trap_SIGINT() {
    echo
    echo "Caught SIGINT"
    echo

    postfix stop
    echo "Postfix stopped."
}

trap "trap_SIGINT" 2

if ! [ -f "${POSTFIX_CONF_DIR}/main.cf" ] && ! [ -f "${POSTFIX_CONF_DIR}/master.cf" ]; then

    echo "Configuration files not found in the '${POSTFIX_CONF_DIR}'"
    echo "Provisioning default configuration awkwardly by reinstalling the postfix package."

    apk fix postfix

else

    echo "Found both main.cf and master.cf."
    echo "Considering configuration under the user's control."

fi


echo "Starting postfix..."
postfix -v start-fg &

wait
exit $?

