# A fattish container for Vumi's metrics subsystem.

This container runs the following components:

1. GraphiteMetricsCollector
2. 3x MetricAggregators with bucket size set to 10
3. 1x TimeBucket with buckets count set to 3 and bucket size set to 10
4. 1x [Go Metrics API](http://go-metrics-api.rtfd.io) exposed on port 8000

## Environment variables

- **URL_PATH_PREFIX**
- **STATIC_OWNER_ID**
- **AUTH_USERNAME** not set by default and therefor disabled
- **AUTH_PASSWORD** not set by default and therefor disabled
- **GRAPHITE_URL**
- **GRAPHITE_USERNAME** not set by default
- **GRAPHITE_PASSWORD** not set by default
- **GRAPHITE_PREFIX**
- **GRAPHITE_DISABLE_AUTO_PREFIX**
- **AMQP_HOST** defaults to `localhost`
- **AMQP_PORT** defaults to `5672`
- **AMQP_VHOST** defaults to `/`
- **AMQP_USERNAME** defaults to `guest`
- **AMQP_PASSWORD** defaults to `guest`

The application will display the config used when it starts up.
