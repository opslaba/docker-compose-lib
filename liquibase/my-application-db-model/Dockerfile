FROM docker.io/liquibase/liquibase:4.28

USER root

COPY src/sh/migrate.sh /app/
COPY src/main/resources /app/config/

RUN chgrp -R 0 /app && chmod -R g+rwX /app && chmod +x /app/migrate.sh

WORKDIR "/app"

ENTRYPOINT ["/bin/bash", "-c", "/app/migrate.sh" ]
