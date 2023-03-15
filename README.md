# Terraform Docker K3s

This repository contains the Terraform code to deploy a cluster K3s using Docker containers on your local machine.

## Requirements

In order to run this Terraform code, a few things are required:
- a working terraform ~> 1.3 installation
- a working docker installation

## Execute Terraform

Run `terraform init` to initialize the working directory and download all required providers or modules.

Run `terraform plan` to preview the changes that Terraform will make if you run the `terraform apply` command.

Run `terraform apply` to apply the changes.

## Variables 

|Name|Description|Type|Default|
|----|----|----|----|
|k3s_cluster|K3s cluster configuration|`object`|Below|
|k3s_cluster.name|K3s cluster name|string|`k3s-cluster`|
|k3s_cluster.image|K3s Docker image|string|`rancher/k3s`|
|k3s_cluster.image_tag|K3s Docker image tag|string|`latest`|
|k3s_cluster.worker_count|K3s cluster worker count|number|`2`|

## Outputs

Once the Terraform apply has been executed succesfully, you'll find a `kubeconfig.yaml` file in this same directory.

Use command `export KUBECONFIG=$(PWD)/kubeconfig.yaml` to load the configuration for kubectl.
