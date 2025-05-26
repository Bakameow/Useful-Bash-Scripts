#!/bin/bash

url1="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
url2="https://githubfast.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
# 下载 nvim 压缩包
echo "下载 nvim-linux-x86_64.tar.gz..."
if wget --timeout=3 $url1 -O nvim-linux-x86_64.tar.gz; then
        echo "下载成功"
else
        if wget --timeout=3 $url2 -O nvim-linux-x86_64.tar.gz; then
                echo "下载成功"
        else
                echo "下载失败"
                exit 1
        fi
fi

# 解压 nvim 压缩包
echo "解压 nvim-linux-x86_64.tar.gz..."
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# 检查.zshrc文件中是否已经包含指定的export路径
if ! grep -q 'export PATH="\$PATH:/opt/nvim-linux-x86_64/bin"' "$HOME/.zshrc"; then
  # 如果没有找到，则添加该行
  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> "$HOME/.zshrc"
  echo "Added '/opt/nvim-linux-x86_64/bin' to PATH in .zshrc"
else
  # 如果已经存在，输出提示
  echo "The PATH entry is already in .zshrc"
fi

mkdir -p $HOME/.config

cd $HOME/.config

url3="https://github.com/Bakameow/nvim.git"
url4="https://githubfast.com/Bakameow/nvim.git"

echo "下载neovim配置..."

if git clone $url3; then
        echo "下载成功"
else
        if git clone $url4; then
                echo "下载成功"
        else
                echo "下载失败"
                exit 1
        fi
fi

rm nvim-linux-x86_64.tar.gz
