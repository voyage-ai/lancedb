#!/bin/bash
set -e
ARCH=${1:-x86_64}
TARGET_TRIPLE=${2:-x86_64-unknown-linux-gnu}

# We pass down the current user so that when we later mount the local files
# into the container, the files are accessible by the current user.
pushd ci/manylinux_node
docker build \
    -t lancedb-node-manylinux \
    --build-arg="ARCH=$ARCH" \
    --build-arg="DOCKER_USER=$(id -u)" \
    --progress=plain \
    .
popd

# We turn on memory swap to avoid OOM killer
docker run \
    -v $(pwd):/io -w /io \
    --memory-swap=-1 \
    lancedb-node-manylinux \
    bash ci/manylinux_node/build_vectordb.sh $ARCH $TARGET_TRIPLE
