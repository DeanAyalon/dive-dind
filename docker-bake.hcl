variable "REPO" {
    default = "deanayalon/dive-dind"
}

group "all" {
    targets = ["default", "forks"]
}
target "_common" {
    platforms = ["linux/amd64", "linux/arm64/v8"]
}

// Official repo
group "default" {
    targets = ["github", "dockerhub"]
}
target "github" {
    dockerfile = "dockerfile"
    inherits = ["_common"]
    args = { src = "wagoodman" }
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
}
target "dockerhub" {
    dockerfile = "dockerfile.dh"
    inherits = ["_common"]
    args = { src = "wagoodman" }
    tags = [
        "${REPO}:dh",           "ghcr.io/${REPO}:dh",
        "${REPO}:wagoodman-dh", "ghcr.io/${REPO}:wagoodman-dh",
    ]
    labels = {
        "dive.src.registry" = "dockerhub"
        "dive.src.repo" = "wagoodman/dive"
    }
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
        src = []
        tag = ["", "-gh"]
    }
    inherits = ["_common"]
    tags = ["${REPO}:${src}${tag}", "ghcr.io/${REPO}:${src}${tag}"]
    args = { SRC = src }
    labels = {
        "dive.src.registry" = "github"
        "dive.src.repo" = "${src}/dive"
    }
}
// Copies from Docker image
target "dh-forks" {
    name = "dockerhub-${fork.src}" 
    matrix = { 
        fork = [
            // Repo namespace   No GitHub releases
            { src = "jauderho", onlydh = true }
        ]
    }
    inherits = ["_common"]
    dockerfile = "dockerfile.dh"
    tags = [
        "${REPO}:${fork.src}-dh", 
        "ghcr.io/${REPO}:${fork.src}-dh",
        fork.onlydh ? "${REPO}:${fork.src}" : "",               // No GH Releases - Use DockerHub as default source
        fork.onlydh ? "ghcr.io/${REPO}:${fork.src}" : "",
    ]
    args = { SRC = fork.src }
    labels = {
        "dive.src.registry" = "dockerhub"
        "dive.src.repo" = "${fork.src}/dive"
    }
}