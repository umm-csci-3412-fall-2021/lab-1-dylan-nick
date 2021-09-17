#!/bin/bash

temp_hours=$(mktemp)
temp_JSOutput=$(mktemp)

# Iterate through every folder in the given data directory
for file in "$1"/*/
do
	# Print column 3 of our data (the hours) and add all of them to a temporary txt file. We need ALL of the hours from every computer before we can begin sorting

	awk '{print $3}' "$file/failed_login_data.txt" >> "$temp_hours"
done

# Sort the txt so uniq has the proper input
sort "$temp_hours" | \

	# count the number of each unique entry
	uniq -c | \

	# use awk to imbed the values of each line into a new row of javascript and output it
	# to a new temporary txt file.
	awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' >> "$temp_JSOutput"

# Finally, wrap the contents of that output with the porper header and footer
./bin/wrap_contents.sh "$temp_JSOutput" "html_components/hours_dist" "$1/hours_dist.html"

# Cleanup
rm "$temp_hours"
rm "$temp_JSOutput"
