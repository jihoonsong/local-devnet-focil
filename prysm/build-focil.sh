#!/bin/bash

set -euo pipefail

ARCH="$(uname -m)"

# Function to clean extended attributes from a tarball and repack it.
clean_and_repack_tarball() {
  local tarball_path="$1"
  local temp_dir=$(mktemp -d ./temp_dir)
  local temp_tar="./temp.tar"
  
  # Important: if you're on macOS Ventura or later, make sure you use gnu-tar not bsdtar.
  tar -xf "$tarball_path" -C "$temp_dir"
  tar -cf "$temp_tar" -C "$temp_dir" .
  mv -f "$temp_tar" "$tarball_path"
  rm -rf "$temp_dir" "$temp_tar"
}

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
    echo "Cleaning and repacking tarballs..."
    clean_and_repack_tarball "bazel-bin/cmd/beacon-chain/oci_image_tarball/tarball.tar"
    clean_and_repack_tarball "bazel-bin/cmd/validator/oci_image_tarball/tarball.tar"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Load the Docker images.
echo "Loading Docker images from tarballs..."
docker load -i "bazel-bin/cmd/beacon-chain/oci_image_tarball/tarball.tar"
docker load -i "bazel-bin/cmd/validator/oci_image_tarball/tarball.tar"

# Retag the Docker image.
echo "Retagging Docker image..."
docker image tag gcr.io/offchainlabs/prysm/beacon-chain:latest prysm-beacon-chain-focil:latest
docker image tag gcr.io/offchainlabs/prysm/validator:latest prysm-validator-focil:latest

# Remove the intermediate Docker images.
echo "Removing the intermediate Docker images..."
docker image rm gcr.io/offchainlabs/prysm/beacon-chain:latest
docker image rm gcr.io/offchainlabs/prysm/validator:latest

echo "Done!"
