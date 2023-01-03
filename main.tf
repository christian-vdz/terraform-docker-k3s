resource "docker_image" "k3s" {
  name         = "${var.k3s_cluster.image}:${var.k3s_cluster.image_tag}"
  keep_locally = true
}

resource "docker_volume" "k3s_master-volume" {
  name = "${var.k3s_cluster.name}_master-volume"
}

resource "random_string" "k3s_token" {
  length      = 14
  min_numeric = 14
}

resource "docker_container" "k3s_master" {
  name    = "${var.k3s_cluster.name}_master"
  image   = docker_image.k3s.image_id
  command = ["server"]
  mounts {
    target = "/run"
    type   = "tmpfs"
  }
  mounts {
    target = "/var/run"
    type   = "tmpfs"
  }
  ulimit {
    name = "nofile"
    hard = 65536
    soft = 65536
  }
  privileged = true
  restart    = "always"
  env = [
    "K3S_TOKEN=${random_string.k3s_token.result}",
    "K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml",
    "K3S_KUBECONFIG_MODE=644"
  ]
  volumes {
    container_path = "/var/lib/rancher/k3s"
    volume_name    = docker_volume.k3s_master-volume.name
  }
  volumes {
    container_path = "/output"
    host_path      = abspath(path.module)
  }
  ports {
    internal = 6443
    external = 6443
  }
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }
}

resource "docker_container" "k3s_workers" {
  count = var.k3s_cluster.worker_count
  name  = "${var.k3s_cluster.name}_worker-${count.index}"
  image = docker_image.k3s.image_id
  ulimit {
    name = "nofile"
    hard = 65536
    soft = 65536
  }
  privileged = true
  restart    = "always"
  env = [
    "K3S_URL=https://${docker_container.k3s_master.network_data[0].ip_address}:6443",
    "K3S_TOKEN=${random_string.k3s_token.result}"
  ]
}
