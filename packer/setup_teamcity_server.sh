#!/usr/bin/env bash
set -e

CONTAINERD_VERSION="1.2.6-3"
DOCKER_CE_CLI_VERSION="19.03.8~3-0~ubuntu-xenial"
DOCKER_CE_VERSION="19.03.8~3-0~ubuntu-xenial"
TEAMCITY_SERVER_VERSION="2019.2.4"

# install packages that are required to mount EFS
sudo apt update
sudo apt install -y nfs-common curl

# install Docker
curl -L -o /tmp/containerd.deb https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/containerd.io_${CONTAINERD_VERSION}_amd64.deb
curl -L -o /tmp/docker-ce-cli.deb https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce-cli_${DOCKER_CE_CLI_VERSION}_amd64.deb
curl -L -o /tmp/docker-ce.deb https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_${DOCKER_CE_VERSION}_amd64.deb
sudo dpkg -i /tmp/containerd.deb
sudo dpkg -i /tmp/docker-ce-cli.deb
sudo dpkg -i /tmp/docker-ce.deb
sudo systemctl enable docker
sudo systemctl start docker

sudo docker pull jetbrains/teamcity-server:${TEAMCITY_SERVER_VERSION}

# clean up
rm -vf /tmp/containerd.deb /tmp/docker-ce-cli.deb /tmp/docker-ce.deb
sudo apt clean cache
