FROM java:8

ADD product-data-processor-1.3.2.tar.gz /data01/microservices

VOLUME /data01/microservice-logs

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 11080