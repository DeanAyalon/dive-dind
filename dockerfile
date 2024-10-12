FROM docker

ARG TARGETARCH

LABEL org.opencontainers.image.title="Dive-DinD"
LABEL org.opencontainers.image.authors="Dean Ayalon - dev@deanayalon.com"
LABEL org.opencontainers.image.source="https://github.com/deanayalon/dive-dind"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.description="\
    This image is based on the [Docker Dive tool](https://github.com/wagoodman/dive) \n\
    It was made as a temporary solution to Dive failing to locate blobs when when using the containerd image store. \n\
    Running within its own Docker instance, it uses the docker image store and works as originally intended. \n\
    To use, start a privileged container, and then execute: \n\
        `docker exec -it [container] dive [image/command]` \n\
    \n\
    A wrapper script, which offers easy local image transfer, can be found within the source repository"

WORKDIR /install
RUN DIVE_VERSION=$(\
        wget -qO- "https://api.github.com/repos/wagoodman/dive/releases/latest" | \
        grep '"tag_name":' | \
        sed -E 's/.*"v([^"]+)".*/\1/') && \
    FILE=dive_${DIVE_VERSION}_linux_${TARGETARCH}.tar.gz && \
    \
    wget -O dive.tar.gz https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/${FILE} && \
    tar xf dive.tar.gz && mv dive /usr/local/bin/ && \
    rm -rf /install
WORKDIR /