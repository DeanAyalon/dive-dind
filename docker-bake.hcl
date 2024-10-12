variable "REPO" {
    default = "deanayalon/dive-dind"
}

group "default" {
    targets = ["default"]
}
group "all" {
    targets = ["default", "dockerhub"]
}

// Downloads from the GitHub Releases
target "default" {
    dockerfile = "dockerfile"
    tags = [REPO, "ghcr.io/${REPO}"]
    platforms = ["linux/amd64", "linux/arm64/v8"]
}
// Copies from Docker image
target "dockerhub" {
    name = "dockerhub-${src}" 
    matrix = {
        src = ["wagoodman", "jauderho"]
    }
    dockerfile = "dockerfile.dhub"
    tags = ["${REPO}:${src}", "ghcr.io/${REPO}:${src}"]
    args = {
        SRC = src
    }
    labels = {
        "dive.dockerhub.src" = "${src}/dive"
    }
    platforms = target.default.platforms
}