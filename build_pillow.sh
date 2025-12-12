#!/usr/bin/env bash
set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: bash build_pillow.sh <PILLOW_VERSION>"
    exit 1
fi

echo "============================================"
echo "Building Pillow $VERSION in manylinux2014"
echo "============================================"

mkdir -p dist
mkdir -p wheels

# Download Pillow source
wget https://github.com/python-pillow/Pillow/archive/refs/tags/${VERSION}.tar.gz -O pillow.tar.gz
tar -xf pillow.tar.gz
SRC_DIR=Pillow-${VERSION}

# Run manylinux container
docker run --rm -it \
    -v $(pwd)/${SRC_DIR}:/work/src \
    -v $(pwd)/wheels:/work/wheels \
    quay.io/pypa/manylinux2014_x86_64 bash -c "
        set -e
        # Install build dependencies inside manylinux2014
        yum install -y \
            libjpeg-turbo-devel \
            zlib-devel \
            libpng-devel \
            freetype-devel \
            lcms2-devel \
            libwebp-devel \
            tcl-devel tk-devel \
            harfbuzz-devel fribidi-devel

        # Use CPython 3.11 inside manylinux
        export PYBIN=/opt/python/cp311-cp311/bin

        \$PYBIN/pip install -U pip wheel setuptools
        cd /work/src
        \$PYBIN/python setup.py bdist_wheel -d /work/wheels

        # Repair wheel (embed shared libs)
        auditwheel repair /work/wheels/*.whl -w /work/wheels
    "

cp wheels/*.whl dist/

echo "============================================"
echo "Finished! Wheel saved in ./dist/"
ls -lh dist/
echo "============================================"
