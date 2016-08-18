#!/bin/bash

cmd=$(basename $0)

# prefer the command in CASSANDRA_HOME/bin
full_cmd_path=$(find -L "$CASSANDRA_HOME/bin" "$CASSANDRA_HOME" -type f -name $cmd | head -1)

export CQLSH_HOST="$(hostname --ip-address)"

exec "$full_cmd_path" "$@"

