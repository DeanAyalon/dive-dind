#!/bin/bash

# Constants
container=dive-dind     # Both container and service name
dir=/tmp/dive-dind      # Directory to store image archives
archive=img.tar         # Image archive name

# Fucntions
help() { cat help.txt; }

create_dind() {
    [ -z "$(docker ps | grep dive-dind)" ] && \
        docker compose up -d dive-dind && \
        sleep 2     # Initalization
}
# Save a local image and load it into DinD
load() {
    # Check input
    if [ -z "$1" ]; then
        echo Please specify a local image to dive into
        exit 1
    elif [ -z "$(docker images "$1" -q)" ]; then
        echo The $1 image does not exist locally
        exit 1
    fi

    # Save image to archive
    mkdir -p $dir
    rm $dir/$archive > /dev/null 2>&1
    docker save -o $dir/$archive "$1"

    # Copy archive to dive-dind
    docker exec dive-dind rm $archive > /dev/null 2>&1
    docker cp $dir/$archive dive-dind:/
    rm $dir/$archive

    # Load archive in dive-dind
    docker exec dive-dind \
        docker load -i $archive
}
dive() {
    docker exec -it dive-dind \
        docker compose run -it --rm dive "$1"
}

# SCRIPT EXECUTION

# Context
cd "$(dirname "$0")"

[ -z "$1" ] && help && exit 1
case "$1" in
    # docker save, docker cp, docker exec docker import
    local ) 
        create_dind
        load "$2"
        dive "$2" ;;
    
    # Copy dockerfile, dive build, delete
    build ) echo Not yet supported, please copy the file to DinD and manually build it ; exit 1 ;;

    # docker compose down -v
    clean ) 
        docker compose down -v ;;
    
    * ) create_dind ; dive $@ ;;
esac