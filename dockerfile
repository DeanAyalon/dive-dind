FROM docker

LABEL    org.opencontainers.image.title="Dive-DinD"
LABEL  org.opencontainers.image.authors="Dean Ayalon - dev@deanayalon.com"
LABEL   org.opencontainers.image.source="https://github.com/deanayalon/dive-dind"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=jauderho/dive /usr/local/bin/dive /usr/local/bin/