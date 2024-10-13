variable "REPO" {
    default = "deanayalon/dive-dind"
}

group "all" {
    targets = ["default", "forks"]
}
target "_common" {
    annotations = [
        "index,manifest:org.opencontainers.image.title=Dive-DinD",
        "index,manifest:org.opencontainers.image.authors=Dean Ayalon - dev@deanayalon.com",
        "index,manifest:org.opencontainers.image.source=https://github.com/deanayalon/dive-dind"
    ]
    labels = {
        "org.opencontainers.image.title"    = "Dive-DinD"
        "org.opencontainers.image.authors"  = "Dean Ayalon - dev@deanayalon.com"
        "org.opencontainers.image.source"   = "https://github.com/deanayalon/dive-dind"
        "org.opencontainers.image.licenses" ="MIT"
        "org.opencontainers.image.description" = <<EOF
            This image is based on the [Docker Dive tool](https://github.com/wagoodman/dive) by wagoodman. \n
            It was made as a temporary solution to Dive failing to locate blobs when when using the containerd image store. \n
            Running within its own Docker instance, it uses the docker image store and works properly. \n
            To use, start a privileged container, and then execute: \n
                `docker exec -it [container] dive [image/command]` \n\n

            A wrapper script, which offers easy local image transfer, can be found within the source repository.
        EOF

        "dive.original-author"  = "wagoodman @ https://github.com/wagoodman"
    }
}

// Official repo
group "default" {
    targets = ["github", "dockerhub"]
}
target "github" {
    dockerfile = "dockerfile"
    inherits = ["_common"]
    tags = [
        "${REPO}",              "ghcr.io/${REPO}",
        "${REPO}:gh",           "ghcr.io/${REPO}:gh",
        "${REPO}:wagoodman",    "ghcr.io/${REPO}:wagoodman",
        "${REPO}:wagoodman-gh", "ghcr.io/${REPO}:wagoodman-gh",
    ]
    labels = {
        "dive.src.registry" = "github"
        "dive.src.repo" = "wagoodman/dive"
    }
    platforms = ["linux/amd64", "linux/arm64/v8"]
}
target "dockerhub" {
    dockerfile = "dockerfile.dh"
    inherits = ["_common"]
    tags = [
        "${REPO}:dh",           "ghcr.io/${REPO}:dh",
        "${REPO}:wagoodman-dh", "ghcr.io/${REPO}:wagoodman-dh",
    ]
    platforms = ["linux/amd64"]
}

// Forks
group "forks" {
    targets = [
        "dh-forks", 
        // "gh-forks"
    ]
}

// Downloads from various forks' GitHub latest releases
target "gh-forks" {
    name = "github-${src}${tag}"
    matrix = {
        fork = [] // [{ src: string, arm: bool, amd: bool }]
    }
    inherits = ["_common"]
    tags = [
        "${REPO}:${src}${tag}",    "ghcr.io/${REPO}:${src}${tag}",
        "${REPO}:${src}${tag}-gh", "ghcr.io/${REPO}:${src}${tag}-gh"
    ]
    args = { SRC = fork.src }
    platforms = [
        fork.amd ? "linux/amd64" : "", 
        fork.arm ? "linux/arm64/v8" : ""
    ]
}
// Copies from Docker image
target "dh-forks" {
    name = "dockerhub-${fork.src}" 
    matrix = { 
        fork = [
            // Repo namespace   No GitHub releases   AMD64/ARM64
            { src = "jauderho", onlydh = true, amd = true, arm = true }
        ]
    }
    inherits = ["_common"]
    dockerfile = "dockerfile.dh"
    tags = [
        "${REPO}:${fork.src}-dh", 
        "ghcr.io/${REPO}:${fork.src}-dh",
        // No GH Releases - Use DockerHub as default source:
        fork.onlydh ? "${REPO}:${fork.src}" : "",
        fork.onlydh ? "ghcr.io/${REPO}:${fork.src}" : "",
    ]
    args = { SRC = fork.src }
    platforms = [
        fork.amd ? "linux/amd64" : "", 
        fork.arm ? "linux/arm64/v8" : ""
    ]
}