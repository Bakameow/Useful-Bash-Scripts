#!/bin/bash
source var.sh
# 检查是否提供了模型名称
if [ -z "$1" ]; then
  echo -e "${RED}错误：请提供模型名称作为参数。${RESET}"
  echo -e "${GREEN}用法: $0 <model_name>${RESET}"
  exit 1
fi

# 获取模型名称
MODEL_NAME=$1

# 设置本地保存目录
LOCAL_DIR=~/Models/"$MODEL_NAME"

# 创建本地目录（如果不存在）
mkdir -p "$LOCAL_DIR"

# 下载模型
echo "正在下载模型 '$MODEL_NAME' 到目录 '$LOCAL_DIR'..."
modelscope download --model "$MODEL_NAME" --local_dir "$LOCAL_DIR"

# 检查是否下载成功
if [ $? -eq 0 ]; then
  echo "模型 '$MODEL_NAME' 已成功下载到 '$LOCAL_DIR'。"
else
  echo "错误：下载模型 '$MODEL_NAME' 失败。"
  exit 1
fi
