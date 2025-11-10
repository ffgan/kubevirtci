#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build --platform linux/riscv64 --build-arg BUILDARCH=$(uname -m) . -t quay.io/kubevirtci/fedorariscv:41
