#!/bin/bash

for file in "$1"/var/log/*
do
	#       Capture the month,               date     time.        check for 0 or 1 invalid user, capture username, and then IP.            Print every last one of them, 1 by 1 so there is absolutely NO EXTRA WHITESPACE
        awk 'match($0, /([a-zA-Z]+)[[:space:]]+([0-9]+) ([0-9]+).*Failed password for (invalid user )?([[:alnum:]]+) from ([0-9\.]+)/, groups) {printf groups[1] " " groups[2] " "  groups[3] " " groups[5] " " groups[6] "\n"}' "$file" >> "$1"/failed_login_data.txt

done
