variable "REPO" {
    default = "deanayalon/dive-dind"
}
variable "FORK" {
    default = "jauderho"
}

group "all" {
    targets = ["default", "dhub"]
}

target "default" {
    dockerfile = "dockerfile"
    tags = [REPO, "ghcr.io/${REPO}"]
    platforms = ["linux/amd64", "linux/arm64/v8"]
}
target "dhub" {
    dockerfile = "dockerfile.dhub"
    tags = ["${REPO}:${FORK}", "ghcr.io/${REPO}:${FORK}"]
    args = {
        FORK = FORK
    }
    labels = {
        "wagoodman.dive.fork" = FORK
    }
    platforms = target.default.platforms
}