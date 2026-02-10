FROM quay.io/keycloak/keycloak:26.5.2

COPY docker-entrypoint.sh /opt/keycloak/bin/

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build --db=postgres

ENTRYPOINT ["/opt/keycloak/bin/docker-entrypoint.sh"]
