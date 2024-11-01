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

-- &outboundDepartureDaysOfWeek=MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY
-- &outboundDepartureTimeFrom=00:00&outboundDepartureTimeTo=23:59
-- &inboundDepartureTimeFrom=00:00&inboundDepartureTimeTo=23:59

CREATE MACRO generate_flight_url(departure_airport, flight_params) AS
    'https://www.ryanair.com/api/farfnd/v4/roundTripFares?departureAirportIataCode=' || departure_airport || '&adultPaxCount=1' ||
    '&outboundDepartureDateFrom=' || flight_params['outbound_from'] ||
    '&outboundDepartureDateTo=' || flight_params['outbound_to'] ||
    '&inboundDepartureDateFrom=' || flight_params['inbound_from'] ||
    '&inboundDepartureDateTo=' || flight_params['inbound_to'] ||
    '&durationFrom=' || flight_params['duration_from'] ||
    '&durationTo=' || flight_params['duration_to'] ||
    CASE
        WHEN flight_params['destination'] = 'ANY' THEN ''
        WHEN flight_params['destination'] is NULL THEN ''
        ELSE '&arrivalAirportIataCode=' || flight_params['destination'] || '&searchMode=ALL'
    END;

SET VARIABLE bfs_flights = (SELECT generate_flight_url('BFS', getvariable('flight_params')));
SET VARIABLE dub_flights = (SELECT generate_flight_url('DUB', getvariable('flight_params')));

SELECT
      r.outbound.departureAirport->>'iataCode' AS origin,
      r.outbound.arrivalAirport->>'iataCode' AS airport,
      r.outbound.arrivalAirport.city->>'name' AS city,
      r.outbound.arrivalAirport.city->>'countryCode' AS countryCode,
      r.outbound.arrivalAirport->>'countryName' as country,
      strftime('%a %d %b %H:%M', (r.outbound->>'departureDate')::TIMESTAMP) AS outboundDeparture,
      -- r.outbound->>'arrivalDate' AS outboundArrival,
      strftime('%a %d %b %H:%M', (r.inbound->>'departureDate')::TIMESTAMP) AS inboundDeparture,
      -- r.inbound->>'arrivalDate' AS inboundArrival,
      (r.outbound.price->>'value')::DOUBLE AS outboundPrice,
      (r.inbound.price->>'value')::DOUBLE AS inboundPrice,
      (r.summary.price->>'value')::DOUBLE AS total,
      (r.summary->>'tripDurationDays')::INTEGER AS totalDays,
      CONCAT(
        EXTRACT('hour' FROM (r.outbound->>'arrivalDate')::TIMESTAMP - (r.outbound->>'departureDate')::TIMESTAMP), 'h ',
        EXTRACT('minute' FROM (r.outbound->>'arrivalDate')::TIMESTAMP - (r.outbound->>'departureDate')::TIMESTAMP) % 60, 'm'
      ) AS duration,
      -- epoch_ms((r.outbound->>'priceUpdated')::LONG) as outboundUpdated,
      -- epoch_ms((r.inbound->>'priceUpdated')::LONG) as inboundUpdated
    FROM (
      SELECT unnest(fares) AS r
      FROM read_json([
      getvariable('bfs_flights'),
      getvariable('dub_flights'),
      ], columns={fares: 'JSON[]'})
    )
    WHERE (r.outbound.arrivalAirport.city->>'countryCode') not in getvariable('excluded_destinations') and total < 100
    ORDER BY total ASC;
