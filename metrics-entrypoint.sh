#!/usr/bin/env sh
set -e

# Note these variables are read by the program definitions in metrics.conf
export AMQP_HOST="${AMQP_HOST:-localhost}"
export AMQP_PORT="${AMQP_PORT:-5672}"
export AMQP_VHOST="${AMQP_VHOST:-/}"
export AMQP_USERNAME="${AMQP_USERNAME:-guest}"
export AMQP_PASSWORD="${AMQP_PASSWORD:-guest}"

# Generate Twisted's plugin cache just before running -- all plugins should be
# installed at this point. Twisted is installed site-wide, so the root user is
# needed to perform this operation. See:
# http://twistedmatrix.com/documents/current/core/howto/plugin.html#plugin-caching
python -c 'from twisted.plugin import IPlugin, getPlugins; list(getPlugins(IPlugin))'

supervisord -c /etc/supervisor/supervisord.conf
