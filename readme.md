# What Is This?
This repository was made to easily run [Docker Dive](https://github.com/wagoodman/dive) from within Docker-in-Docker.

## Why?
Docker Dive is no longer maintained, and although forks have fixed some issues (Such as the introduction of an ARM64 image) - Dive still fails inspecting many images when using **the containerd image store**

Disabling the containerd image store does make Dive run smoothly, but that disables the option to execute multi-platform builds

Instead - Enter Docker-in-Docker!<br>
The DinD container runs the regular docker image store, with Docker's contents managed within a volume

# Use
```sh
docker compose up -d dive-dind
sleep 2
docker compose exec -it dive-dind docker compose run -it --rm dive [image]
```

Cleanup:
```sh
docker compose down -v
```