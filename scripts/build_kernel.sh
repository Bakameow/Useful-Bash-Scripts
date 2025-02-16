#!/bin/bash -e
source var.sh

# 检查是否传入参数
if [ -z "$1" ]; then
  echo "请提供下载链接作为参数。下载的文件需要为*.tar格式"
  echo "用法：$0 <url> <kernel_local_version>"
  exit 1
fi
if [ -z "$2" ]; then
  echo "请提供内核版本名作为参数。"
  echo "用法：$0 <url> <kernel_local_version>"
  exit 1
fi

# 获取传入的链接
url=$1
fullname=$(basename "$url")
filename=$(basename "$url" | sed -r 's/\.tar\.(gz|xz)$//')
# 使用 wget 下载
wget --no-clobber "$url"
case "$fullname" in
    *.tar.gz)
        tar -xvzf "$fullname"
        ;;
    *.tar.xz)
        tar -xvf "$fullname"
        ;;
    *)
        echo "${RED}不支持的压缩包格式${RESET}"
        exit 1
        ;;
esac

sudo apt install -y git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison
sudo apt install -y debhelper-compat

cd ${filename}

cp /boot/config-$(uname -r) .config

make localmodconfig

scripts/config --disable SYSTEM_TRUSTED_KEYS &&
scripts/config --disable SYSTEM_REVOCATION_KEYS &&
scripts/config --set-str CONFIG_SYSTEM_TRUSTED_KEYS "" &&
scripts/config --set-str CONFIG_SYSTEM_REVOCATION_KEYS ""

make -j$(nproc) LOCALVERSION=-$2 bindeb-pkg
