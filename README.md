gpx-stats
=========

A ruby script to provide distance and elevation statistics from GPX files.

Usage
-----

gpx-stats uses the `gpx` and `haversine` gems. With these installed, `cd` to the directory containing the script and run `ruby gpx-stats.rb /path/to/gpx/file`. If it is a valid GPX file containing elevation data, you will see several lines of data output below, e.g.:

    3172 ft. ascent, 204 ft. descent
    3.92 mi. ascending, 0.24 mi. descending, 0.66 mi. flat, 4.81 mi. total
    15.3% ascent grade, 16.2% descent grade, 11.7% total grade
