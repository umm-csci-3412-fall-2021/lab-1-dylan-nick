#!/bin/bash

# Iterate through every folder in the given data directory
for file in "$1"/*/
do
	# Add all of our data to a temporary txt file since we need ALL of the data before we can begin sorting
	awk '{print $4}' "$file/failed_login_data.txt" >> allnames.txt
done

# Sort the txt so uniq has the proper input, sort alphabetally
sort allnames.txt | \

	# count the number of each unique entry
	uniq -c | \

	# use awk to imbed the values of each line into a new row of javascript and output it
	# to a new temporary txt file. 	
	awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' >> output.txt

# Finally, wrap the contents of that output with the porper header and footer
./bin/wrap_contents.sh "output.txt" "html_components/username_dist" "$1/username_dist.html"

# Cleanup
rm output.txt
rm allnames.txt
