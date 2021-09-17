#!/bin/bash

temp_names=$(mktemp)
temp_JSOutput=$(mktemp)

# Iterate through every folder in the given data directory
for file in "$1"/*/
do
	# Print column 4 of our data (the names) and add all of them to a temporary txt file. We need ALL of the names from every computer before we can begin sorting
	awk '{print $4}' "$file/failed_login_data.txt" >> "$temp_names"
done

# Sort the txt so uniq has the proper input, sort alphabetally (default of sort so no flag needed)
sort "$temp_names" | \

	# count the number of each unique entry
	uniq -c | \

	# use awk to imbed the values of each line into a new row of javascript and output it
	# to a new temporary txt file. 	
	awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' >> "$temp_JSOutput"

# Finally, wrap the contents of that output with the proper header and footer
./bin/wrap_contents.sh "$temp_JSOutput" "html_components/username_dist" "$1/username_dist.html"

# Cleanup
rm "$temp_names"
rm "$temp_JSOutput"
