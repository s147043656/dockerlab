FROM java:8

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install adduser \
    curl \
    lsb-base \
    procps \
    zlib1g \
    gzip \
    python \
    python-support \
    sysstat \
    mc \
    ntp bash tree && \
    rm -rf /var/lib/apt/lists/*

ADD apache-cassandra-bin.tar.gz /opt

ENV CASSANDRA_HOME /opt/cassandra

RUN ln -s /opt/apache-cassandra-bin $CASSANDRA_HOME

# keep data here
VOLUME /data

# and logs here
VOLUME /logs

VOLUME /opt/cassandra

# starting node using custom entrypoint that configures paths, interfaces, etc.
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Running any other DSE/C* command should be done on behalf dse user
# Perform that using a generic command laucher
COPY cassandra-cmd-launcher.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cassandra-cmd-launcher.sh

# link dse commands to the launcher
RUN for cmd in cqlsh nodetool cassandra-stress; do \
        ln -sf /usr/local/bin/cassandra-cmd-launcher.sh /usr/local/bin/$cmd ; \
    done

# Cassandra
EXPOSE 7000 9042 9160
