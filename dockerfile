FROM docker

ARG TARGETARCH 
ARG SRC=wagoodman

LABEL dive.source.registry="GitHub"
LABEL dive.source.repo="${SRC}/dive"
LABEL dive.source.link="https://github.com/${SRC}/dive"

RUN <<EOF
    mkdir install; cd install
    DIVE_VERSION=$(
        wget -qO- "https://api.github.com/repos/${SRC}/dive/releases/latest" | 
        grep '"tag_name":' | 
        sed -E 's/.*"v([^"]+)".*/\1/')
    FILE=dive_${DIVE_VERSION}_linux_${TARGETARCH}.tar.gz

    wget -O dive.tar.gz https://github.com/${SRC}/dive/releases/download/v${DIVE_VERSION}/${FILE}
    tar xf dive.tar.gz 
    mv dive /usr/local/bin/
    cd ..; rm -rf /install
EOF