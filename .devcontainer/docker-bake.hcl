variable "REPO" {
  default = "lynsei"
}
variable "PROGRAM" {
  default = "devcontainer"
}
variable "TAG" {
  default = "latest"
}

target "brew" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["${REPO}/${PROGRAM}:${TAG}"]
  no-cache = true
  platforms = ["linux/arm64","linux/amd64"]
}