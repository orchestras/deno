variable "REPO" {
  default = "lynsei"
}
variable "PROGRAM" {
  default = "homebrew"
}
variable "TAG" {
  default = "latest"
}

target "brew" {
  context = "."
  dockerfile = "Dockerfile.brew"
  tags = ["${REPO}/${PROGRAM}:${TAG}"]
  no-cache = true
  platforms = ["linux/arm64","linux/amd64"]
}