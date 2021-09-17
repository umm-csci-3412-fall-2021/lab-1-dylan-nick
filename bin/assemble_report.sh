#!/bin/bash

# Concatenate all of the produced files in the supplied directory with cat, direct them to a temporary html file
# (For some reason, actual temporary files will absolutely not work for this)
cat "$1"/country_dist.html "$1"/hours_dist.html "$1"/username_dist.html > temp_summary.html

# Wrap that temporary summary around the header and footer of the summary
./bin/wrap_contents.sh temp_summary.html "html_components/summary_plots" "$1"/failed_login_summary.html

# Clean
rm temp_summary.html
