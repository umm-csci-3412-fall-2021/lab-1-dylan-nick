#!/bin/bash

#Save working directory for output and create our temporary dir
here=$(pwd)
temp_dir="/tmp/tmp_logs"
mkdir "$temp_dir"


# Loop through every argument
for arg
do
	# Define the directory that we're going to extract the supplied tgz into and then create it
	working_dir="$temp_dir"/$(basename -s _secure.tgz "$arg")
	mkdir "$working_dir"

	# Extract the log file into our working dir
	tar zxf "$arg" --directory "$working_dir"

	# Process those logs once we've extracted them using our working dir
	./bin/process_client_logs.sh "$working_dir"
done

# Run all of our shell scripts to aggregate and assemble the data
./bin/create_hours_dist.sh "$temp_dir"
./bin/create_country_dist.sh "$temp_dir"
./bin/create_username_dist.sh "$temp_dir"
./bin/assemble_report.sh "$temp_dir"

# Finally, move the summary to our current working directory we saved about!
mv $temp_dir/failed_login_summary.html "$here"

# Clean.
rm -rf $temp_dir
