#!/bin/sh

# Provided without any warranty, these files are intended
# to accompany the whitepaper about DSE on Docker and are 
# not intended for production and are not actively maintained.

# Bind the various services
# These should be updated on every container start

export CASSANDRA_HOME=/opt/cassandra

if [ -z ${IP} ]; then
  IP=`hostname --ip-address`
fi

echo $IP > /data/ip.address

# tweak the cassandra config
tweak_cassandra_config() {
  env="$1/cassandra-env.sh"
  conf="$1/cassandra.yaml"

  # Set the cluster name
  if [ -z "${CLUSTER_NAME}" ]; then
    printf " - No cluster name provided; skipping.\n"
  else
    printf " - Setting up the cluster name: ${CLUSTER_NAME}\n"
    regexp="s/Test Cluster/${CLUSTER_NAME}/g"
    sed -i -- "$regexp" $conf
  fi

  # Set the commitlog directory, and various other directories
  # These are done only once since the regexep matches will fail on subsequent
  # runs.

  sed -i -- "$regexp" $conf
  regexp="s/^listen_address:.*/listen_address: ${IP}/g"
  sed -i -- "$regexp" $conf
  regexp="s/rpc_address:.*/rpc_address: ${IP}/g"
  sed -i -- "$regexp" $conf

  # seeds
  if [ -z "${SEEDS}" ]; then
    printf " - Using own IP address ${IP} as seed.\n";
    regexp="s/seeds:.*/seeds: \"${IP}\"/g";
  else
    printf " - Using seeds: $SEEDS\n";
    regexp="s/seeds:.*/seeds: \"${IP},${SEEDS}\"/g"
  fi
  sed -i -- "$regexp" $conf

  # JMX
  echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=127.0.0.1\"" >> $env
}

setup_node() {
  printf "* Setting up node...\n"
  printf " + Setting up node...\n"

  create_dirs ${cassandra_data_dir}
  tweak_cassandra_config "${CASSANDRA_HOME}/conf"

  # mark that we tweaked configs
  touch "$CASSANDRA_HOME/conf/tweaked_configs"

  printf "Done.\n"
}

# if marker file doesn't exist, setup node
[ ! -f "$CASSANDRA_HOME/conf/tweaked_configs" ] && setup_node

#exec gosu cassandra "$CASSANDRA_HOME/bin/cassandra" cassandra -f "$@"
exec "$CASSANDRA_HOME/bin/cassandra" -R  -f "$@"
#exec /bin/bash
