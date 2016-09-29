#!/usr/bin/env sh
set -e

# Note these variables are read by the program definitions in metrics.conf
export AMQP_HOST="${AMQP_HOST:-localhost}"
export AMQP_PORT="${AMQP_PORT:-5672}"
export AMQP_VHOST="${AMQP_VHOST:-/}"
export AMQP_USERNAME="${AMQP_USERNAME:-guest}"
export AMQP_PASSWORD="${AMQP_PASSWORD:-guest}"

# Config file not set, generate one
cat > /app/config.yml <<EOF
# Generated config file
${URL_PATH_PREFIX:+url_path_prefix: $URL_PATH_PREFIX}
${STATIC_OWNER_ID:+static_owner_id: $STATIC_OWNER_ID}
backend:
  {$AUTH_USERNAME:+basicauth_username: '$AUTH_USERNAME'}
  {$AUTH_PASSWORD:+basicauth_password: '$AUTH_PASSWORD'}
  ${GRAPHITE_URL:+graphite_url: '$GRAPHITE_URL'}
  ${GRAPHITE_USERNAME:+username: '$GRAPHITE_USERNAME'}
  ${GRAPHITE_PASSWORD:+password: '$GRAPHITE_PASSWORD'}
  ${GRAPHITE_PREFIX:+prefix: '$GRAPHITE_PREFIX'}
  ${GRAPHITE_DISABLE_AUTO_PREFIX:+disable_auto_prefix: '$GRAPHITE_DISABLE_AUTO_PREFIX'}
  ${AMQP_HOST:+amqp_hostname: '$AMQP_HOST'}
  ${AMQP_PORT:+amqp_port: $AMQP_PORT}
  ${AMQP_VHOST:+amqp_vhost: '$AMQP_VHOST'}
  ${AMQP_USERNAME:+amqp_username: '$AMQP_USERNAME'}
  ${AMQP_PASSWORD:+amqp_password: '$AMQP_PASSWORD'}
EOF

echo "Starting Metrics API with config: "
cat /app/config.yml

# Generate Twisted's plugin cache just before running -- all plugins should be
# installed at this point. Twisted is installed site-wide, so the root user is
# needed to perform this operation. See:
# http://twistedmatrix.com/documents/current/core/howto/plugin.html#plugin-caching
python -c 'from twisted.plugin import IPlugin, getPlugins; list(getPlugins(IPlugin))'

supervisord -c /etc/supervisor/supervisord.conf
