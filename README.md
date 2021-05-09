# Usage

```bash
ruby traffic_analyzer.rb path_to_webserver.log
```

The output will include two lists:

* A list of all sites in the log with their views summed up and sorted in a descending order
* A list of all sites in the log with their unique views summed up and sorted in a descending order

# Structure

## `TrafficAnalyzer::AddressViewsMap`

This class is responsible for holding traffic information for a single site.
It does so by mapping addresses that visited the given site to the number
of their visits, like so: { '123.123.123.123': 5, 212.212.212.212: 2 }

Thanks to this structure we're able to easily count the number of all views
(by adding up all the values in the internal hash), as well as unique ones
(by counting the number of keys)

## `Trafficanalyzer::Summary`

This class is responsible for holding traffic information for all sites
by maintaining one AddressViewsMap object for each. It is used to
compose the final views breakdown.

## `TrafficAnalyzer::LogParsingError`

It is raised in case of malformed log file, which means in case of
encountering line that's either too short or too long (in terms of words)
