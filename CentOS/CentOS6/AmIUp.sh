#!/bin/bash
# Checks which hosts in your /etc/hosts file are up or down
# Prints output in colour

ENABLE_IPV6=true
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

#ipv4
grep -Ev '(^[#$]|::)' /etc/hosts | tr '\t' ' ' | \
cut -d ' ' -f1 | xargs -I@ echo ping -W2 -c1 @ '&>/dev/null' '&&' echo -e @ \
"\"[${GREEN}OK${RESET}]\"" '||' echo -e @ "\"[${RED}DOWN${RESET}]\"" | bash | awk '{ printf "%-22s %s\n", $1, $2 }'

if [ $ENABLE_IPV6 == true ]
then
    #ipv6
    grep "::" /etc/hosts | grep -v "^$" | tr '\t' ' ' | \
    cut -d ' ' -f1 | xargs -I@ echo ping6 -W2 -c1 @ '&>/dev/null' '&&' echo -e @ \
    "\"[${GREEN}OK${RESET}]\"" '||' echo -e @ "\"[${RED}DOWN${RESET}]\"" \
    | bash | awk '{ printf "%-22s %s\n", $1, $2 }'
fi
