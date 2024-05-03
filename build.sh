cat <<-'EOF' | docker run -i --rm -v $PWD:/output debian bash -
NVIM_VERSION=0.9.5
apt-get update && apt-get -y install ninja-build gettext cmake unzip curl build-essential git file
git clone --depth 1 --branch "v${NVIM_VERSION}"  https://github.com/neovim/neovim
pushd neovim
cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build .deps
cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build
pushd build
cpack -G DEB -D CPACK_PACKAGE_FILE_NAME=nvim-${NVIM_VERSION}-$(uname -s | awk '{print tolower($0)}')-$(dpkg --print-architecture)
ls -la /neovim/build
mv /neovim/build/*.deb /output/
EOF
