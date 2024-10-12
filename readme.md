# What Is This?
This repository was made to easily run [Docker Dive](https://github.com/wagoodman/dive) from within Docker-in-Docker.<br>
[![Source](https://img.shields.io/badge/Source-121011?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DeanAyalon/docker-bind-init)
[![Docker](https://img.shields.io/badge/docker%20hub-1D63ED?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/repository/docker/deanayalon/dive-dind)

## Why? 
Docker Dive is no longer maintained, and currently fails inspecting images when running on an engine using the containrd image store.<br>
Although forks have fixed some issues - No image fixing the issue was introduced yet.<br>
[GitHub Issue](https://github.com/wagoodman/dive/issues/534)

Disabling the containerd image store does make Dive run properly, but disables the option to execute multi-platform builds

Instead - Enter Docker-in-Docker!<br>
The DinD container runs the regular docker image store, with Docker's contents managed within a volume

> **Note:** This image does not use the `:dind` variant of the docker image, so it might not, technically, be DinD, proper rename will come

# Use
## Script
The [`run.sh`](./run.sh) script is a wrapper around dive that starts the DinD automatically and offers automation for the following features:
- **Local images:** Save a local image, load it into DinD and Dive
  ```sh
  ./run.sh local [image]
  ```
- **Clean:** Removes the DinD and volume, cleans up all stored images
  ```sh
  ./run.sh clean
  ```

### Limits
The script disables the `build` command, as Dive uses a thin wrapper for legacy Docker builder.<br>
Instead, build your image locally using Buildx and use the `local` command to transfer it to the DinD for diving.

## Manual execution
```sh
docker compose up -d dive-dind
sleep 2
docker exec -it dive-dind docker compose run -it --rm dive [image]
```

Cleanup:
```sh
docker compose down -v
```

## Alternative
You can of course use dive within docker yourself without the image and script here, simply by running
```sh
docker run -dt --privileged --name dive-dind
sleep 2  # Docker needs time to start
docker exec -it dive-dind \
    docker run --rm -it \
    dive [image/command]
```
This repository just provides a convenient approach to managing it

# Available Tags
- **latest:** Gets the dive binary from the [wagoodman/dive](https://github.com/wagoodman/dive/releases/latest) GitHub releases
- **jauderho:** Gets the dive binary from the [jauderho/dive](https://hub.docker.com/r/jauderho/dive) Docker image, as it lacks GitHub releases

## Featured Technologies
[![Docker](https://img.shields.io/badge/docker-1D63ED?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/repository/docker/deanayalon/dive-dind)
[![Dive](https://custom-icon-badges.demolab.com/badge/dive-10151a?style=for-the-badge&logoColor=white&logo=docker-container)](https://github.com/wagoodman/dive)
![Shell](https://img.shields.io/badge/shell-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)