#! /bin/bash
CUDA_VERSION="12.9" # 请根据需要修改您的 CUDA 版本
EXPECTED_CUDA_BIN_PATH="/usr/local/cuda-${CUDA_VERSION}/bin"
EXPECTED_CUDA_LIB_PATH="/usr/local/cuda-${CUDA_VERSION}/lib64"
ZSHRC_FILE="$HOME/.zshrc"

path_configured=false
ld_path_configured=false

echo "--- 开始安装 NVIDIA GPU 驱动和 CUDA ---"

# 克隆仓库并切换到指定提交
echo "1. 克隆 NVIDIA open-gpu-kernel-modules 仓库..."
git clone https://github.com/NVIDIA/open-gpu-kernel-modules
if [ $? -ne 0 ]; then
    echo "[ERROR] 克隆仓库失败。"
    exit 1
fi
pushd open-gpu-kernel-modules
echo "切换到提交 575.51.02..."
git checkout 575.51.02
if [ $? -ne 0 ]; then
    echo "[ERROR] 切换提交失败。"
    exit 1
fi

echo "2. 应用补丁..."
if [ -f "../575.51.02-patch-for-6.15rc2.patch" ]; then
    git apply ../575.51.02-patch-for-6.15rc2.patch
    if [ $? -ne 0 ]; then
        echo "[ERROR] 应用补丁失败。"
        exit 1
    fi
    echo "补丁应用成功。"
else
    echo "补丁文件 ../0001-apply-575.51.02-patch-for-6.15rc2.patch 未找到。"
    exit 1
fi

echo "3. 编译内核模块..."
make modules -j`nproc`
if [ $? -ne 0 ]; then
    echo "[ERROR] 编译内核模块失败。"
    exit 1
fi
echo "编译完成。"

echo "4. 安装内核模块..."
sudo make modules_install -j$(nproc)
if [ $? -ne 0 ]; then
    echo "[ERROR] 安装内核模块失败。"
    exit 1
fi
echo "内核模块安装完成。"
popd

echo "5. 下载并安装 NVIDIA 驱动 (不包含内核模块)..."
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/575.51.02/NVIDIA-Linux-x86_64-575.51.02.run
if [ $? -ne 0 ]; then
    echo "[ERROR] 下载驱动失败。"
    exit 1
fi
chmod +x NVIDIA-Linux-x86_64-575.51.02.run
sudo ./NVIDIA-Linux-x86_64-575.51.02.run --no-kernel-modules
if [ $? -ne 0 ]; then
    echo "[ERROR] 安装驱动失败。"
    exit 1
fi
echo "NVIDIA 驱动安装完成。"

echo "6. 下载并安装 CUDA 工具包..."
wget https://developer.download.nvidia.com/compute/cuda/12.9.0/local_installers/cuda_12.9.0_575.51.03_linux.run
if [ $? -ne 0 ]; then
    echo "[ERROR] 下载 CUDA 工具包失败。"
    exit 1
fi
chmod +x cuda_12.9.0_575.51.03_linux.run
sudo ./cuda_12.9.0_575.51.03_linux.run
if [ $? -ne 0 ]; then
    echo "[ERROR] 安装 CUDA 工具包失败。"
    exit 1
fi
echo "CUDA 工具包安装完成。"

echo "7. 检查并配置环境变量 (${ZSHRC_FILE})..."
if [ ! -f "${ZSHRC_FILE}" ]; then
    echo "[ERROR] ${ZSHRC_FILE} 文件未找到，无法添加环境变量。"
    exit 1
fi

echo -n "检查 PATH 是否包含 ${EXPECTED_CUDA_BIN_PATH}... "
if grep -q "PATH.*${EXPECTED_CUDA_BIN_PATH}" "${ZSHRC_FILE}"; then
    echo "已找到配置。"
    path_configured=true
else
    echo "未找到或配置不正确。"
fi

echo -n "检查 LD_LIBRARY_PATH 是否包含 ${EXPECTED_CUDA_LIB_PATH}... "
if grep -q "LD_LIBRARY_PATH.*${EXPECTED_CUDA_LIB_PATH}" "${ZSHRC_FILE}"; then
    echo "已找到配置。"
    ld_path_configured=true
else
    echo "未找到或配置不正确。"
fi

if ! ${path_configured}; then
    echo "export PATH="${EXPECTED_CUDA_BIN_PATH}:$PATH"" >> "${ZSHRC_FILE}"
    echo "已添加 PATH 配置到 ${ZSHRC_FILE}。"
fi

if ! ${ld_path_configured}; then
    echo "export LD_LIBRARY_PATH="${EXPECTED_CUDA_LIB_PATH}:$LD_LIBRARY_PATH"" >> "${ZSHRC_FILE}"
    echo "已添加 LD_LIBRARY_PATH 配置到 ${ZSHRC_FILE}。"
fi

