#!/bin/bash -e
source var.sh

if ! which conda &> /dev/null
then
    echo -e "${GREEN}conda is already installed.${RESET}"
    exit 1
fi

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x ./Miniconda3-latest-Linux-x86_64.sh
sudo ./Miniconda3-latest-Linux-x86_64.sh
# 定义要写入的内容
CONDARC_CONTENT="channels:
  - https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
  - https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - defaults
show_channel_urls: true"

# 将内容写入 ~/.condarc 文件
echo "$CONDARC_CONTENT" > "$HOME/.condarc"

echo "$HOME/.condarc 文件已成功更新。"

# 创建或更新 ~/.pip/pip.conf 文件
mkdir -p $HOME/.pip
echo "[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn" > $HOME/.pip/pip.conf

# 输出成功信息
echo "pip 源已成功更改为清华大学镜像源。"

echo "$HOME/.pip.conf 文件已成功更新。"
rm ./Miniconda3-latest-Linux-x86_64.sh
