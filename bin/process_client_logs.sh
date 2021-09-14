#!/bin/bash

cd "$1" || return

for file in var/log/*
do
	#               Capture the month, date and the hours of the time.         check for 0 or 1 invalid user, capture username, and then capture the IP
	awk 'match($0, /(([a-zA-Z]+[[:space:]]+[0-9]+ [0-9]+).*Failed password for (invalid user )?([[:alnum:]]+) from ([0-9\.]+))/, groups) {printf groups[2] " " groups[4] " "  groups[5] "\n"}' "$file" >> failed_login_data.txt
done
