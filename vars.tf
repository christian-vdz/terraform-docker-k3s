variable "k3s_cluster" {
  description = "K3s cluster configuration"
  type = object({
    name         = string
    image        = string
    image_tag    = string
    worker_count = number
  })
  default = ({
    name         = "k3s-cluster"
    image        = "rancher/k3s"
    image_tag    = "latest" # from https://hub.docker.com/r/rancher/k3s/tags
    worker_count = 2
  })
}
