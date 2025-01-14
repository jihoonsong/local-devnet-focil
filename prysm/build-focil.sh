#!/bin/bash

set -euo pipefail

ARCH="$(uname -m)"

# Build Docker images of beacon-chain and validator.
case "$ARCH" in
  amdx86_64)
    echo "Building beacon-chain for AMD / x86 architecture..."
    bazel build //cmd/beacon-chain:oci_image_tarball --config=release
    echo "Building valiator for AMD / x86 architecture..."
    bazel build //cmd/validator:oci_image_tarball --config=release
    ;;
  arm64|aarch64)
    echo "Building beacon-chain for ARM architecture (including Apple M1/M2/M3)..."
    bazel build //cmd/beacon-chain:oci_image_tarball --platforms=@io_bazel_rules_go//go/toolchain:linux_arm64_cgo --config=release
    echo "Building validator for ARM architecture (including Apple M1/M2/M3)..."
    bazel build //cmd/validator:oci_image_tarball  --platforms=@io_bazel_rules_go//go/toolchain:linux_arm64_cgo --config=release
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Load the Docker images.
echo "Loading Docker images from tarballs..."
docker load -i bazel-bin/cmd/beacon-chain/oci_image_tarball/tarball.tar
docker load -i bazel-bin/cmd/validator/oci_image_tarball/tarball.tar

# Retag the Docker image.
echo "Retagging Docker image..."
docker image tag gcr.io/prysmaticlabs/prysm/beacon-chain:latest prysm-beacon-chain-focil:latest
docker image tag gcr.io/prysmaticlabs/prysm/validator:latest prysm-validator-focil:latest

# Remove the intermediate Docker images.
echo "Removing the intermediate Docker images..."
docker image rm gcr.io/prysmaticlabs/prysm/beacon-chain:latest
docker image rm gcr.io/prysmaticlabs/prysm/validator:latest

echo "Done!"
