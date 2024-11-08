# Duckdb

Find flight information from the command line.
```
cat flights.sql | duckdb
```

Update variable at top of file to target different airports, dates etc.

```
SET VARIABLE flight_params = {
    'destination': 'ANY', -- iata airport code
    'outbound_from': '2024-12-01',
    'outbound_to': '2024-12-29',
    'inbound_from': '2024-12-03',
    'inbound_to': '2024-12-31',
    'duration_from': '2',
    'duration_to': '4'
};
SET VARIABLE excluded_destinations = ['gb', 'ie'];
...
SET VARIABLE bfs_flights = (SELECT generate_flight_url('BFS', getvariable('flight_params')));
SET VARIABLE dub_flights = (SELECT generate_flight_url('DUB', getvariable('flight_params')));
```

Sniff Columns for csv file.
```
echo "select Columns FROM sniff_csv('https://raw.githubusercontent.com/ip2location/ip2location-iata-icao/master/iata-icao.csv', ignore_errors=true);" | duckdb --csv
```
