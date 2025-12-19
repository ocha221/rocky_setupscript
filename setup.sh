#!/bin/bash
set -e
sudo dnf update -y

sudo dnf install epel-release -y
sudo dnf config-manager --enable crb
sudo dnf groupinstall "Development Tools" -y
sudo dnf install kernel-devel-matched kernel-headers -y


sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel10/$(uname -m)/cuda-rhel10.repo
sudo dnf clean expire-cache


sudo dnf install nvidia-open -y
sudo grubby --args="nouveau.modeset=0 rd.driver.blacklist=nouveau" --update-kernel=ALL


