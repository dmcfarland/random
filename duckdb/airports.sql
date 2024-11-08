FROM read_csv(
    'https://raw.githubusercontent.com/ip2location/ip2location-iata-icao/master/iata-icao.csv',
    skip = 1,
    columns
    = {
        'country_code': 'VARCHAR',
        'region_name': 'VARCHAR',
        'iata': 'VARCHAR',
        'icao': 'VARCHAR',
        'airport': 'VARCHAR',
        'latitude': 'VARCHAR',
        'longitude': 'VARCHAR'
    },
    ignore_errors = true
);
