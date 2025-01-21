mkdir -p $PWD/output
export DEB_DIST=trixie
cat <<-'EOF' | docker run -i --rm -e DEB_DIST -v $PWD/output:/output debian:${DEB_DIST} bash -
# cat <<-'EOF' | docker run -i --rm -v $PWD/output:/output debian:bullseye bash -
NVIM_VERSION=0.10.3
apt-get update && apt-get -y install ninja-build gettext cmake unzip curl build-essential git file

git clone --depth 1 --branch "v${NVIM_VERSION}"  https://github.com/neovim/neovim

pushd neovim
cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build .deps
cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo -D OUTPUT_NAME=nvim-${NVIM_VERSION}-$(uname -s | awk '{print tolower($0)}')-$(dpkg --print-architecture)
cmake --build build

pushd build
cpack -G DEB -D CPACK_PACKAGE_DIRECTORY=/output -D CPACK_PACKAGE_FILE_NAME=nvim-${NVIM_VERSION}-${DEB_DIST}-$(uname -s | awk '{print tolower($0)}')-$(dpkg --print-architecture)
cpack -G TGZ -D CPACK_PACKAGE_DIRECTORY=/output -D CPACK_PACKAGE_FILE_NAME=nvim-${NVIM_VERSION}-${DEB_DIST}-$(uname -s | awk '{print tolower($0)}')-$(dpkg --print-architecture)
cpack -G TXZ -D CPACK_PACKAGE_DIRECTORY=/output -D CPACK_PACKAGE_FILE_NAME=nvim-${NVIM_VERSION}-${DEB_DIST}-$(uname -s | awk '{print tolower($0)}')-$(dpkg --print-architecture)
cpack -G TBZ2 -D CPACK_PACKAGE_DIRECTORY=/output -D CPACK_PACKAGE_FILE_NAME=nvim-${NVIM_VERSION}-${DEB_DIST}-$(uname -s | awk '{print tolower($0)}')-$(dpkg --print-architecture)

EOF
