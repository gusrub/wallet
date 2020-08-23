#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid /app/shared/pids/puma.pid

# Run any pending migrations
rake db:migrate

# Start the 'bank simulator'
php -S 127.0.0.1:8080 -t /app &

if [ $? -eq 0 ]
then
  # Then exec the container's main process (what's set as CMD in the Dockerfile).
    exec "$@"
else
    echo -e "\nError trying to run bank simulator\n"
    exit -1
fi
