#!/bin/bash

# cd "$1" || return

for file in $1/*/
do
awk '{print $4}' "$file/failed_login_data.txt" | \

	sort | \

	uniq -c | \

	sort -nr | \
       
	awk '{print "data.addRow([\x27" $2 "\x27, " $1 ");"}' | \

	./wrap_contents.sh "html_components/username_dist" "username_dist.html"
done



