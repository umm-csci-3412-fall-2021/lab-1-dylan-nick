#!/bin/bash

temp_IPs=$(mktemp)
temp_JSOutput=$(mktemp)


# Iterate through every folder in the given data directory
for file in "$1"/*/
do
        # Print column 5 of our data (the IPs) and add all of them to a temporary txt file. We need ALL of the IPs from every computer before we can begin sorting
        awk '{print $5}' "$file/failed_login_data.txt" >> "$temp_IPs"
done


# Join the IPs to the character code, sorting each file before it's input into join
join <(sort "$temp_IPs") <(sort etc/country_IP_map.txt) | \
	
	# Sort based on the 2nd (new) column, the country codes
	sort -k 2 | \

	# Print only the country codes so unique don't have a bunch of duplicates
	awk '{print $2}' | \

        # count the number of each unique country code
        uniq -c | \

        # use awk to imbed the values of each line into a new row of javascript and output it
        # to a new temporary txt file.
	awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' >> "$temp_JSOutput"

# Finally, wrap the contents of that output with the porper header and footer
./bin/wrap_contents.sh "$temp_JSOutput" "html_components/country_dist" "$1/country_dist.html"

# Cleanup
rm "$temp_IPs"
rm "$temp_JSOutput"

