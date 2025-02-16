#!/bin/bash -e
source ./var.sh
# 安装 zsh
if ! which zsh &> /dev/null
then
    echo -e "${RED}Zsh is not installed, installing...${RESET}"
    sudo apt-get install -y zsh
else
    echo -e "${RED}Zsh is already installed.${RESET}"
fi

# 安装 oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${RED}Installing Oh My Zsh...${RESET}"
    wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | sh
else
    echo -e "${RED}Oh My Zsh is already installed.${RESET}"
fi

# 克隆 zsh-autosuggestions 插件
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo -e "${RED}Cloning zsh-autosuggestions plugin...${RESET}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo -e "${RED}zsh-autosuggestions plugin is already installed.${RESET}"
fi

# 克隆 zsh-syntax-highlighting 插件
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${RED}Cloning zsh-syntax-highlighting plugin...${RESET}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo -e "${RED}zsh-syntax-highlighting plugin is already installed.${RESET}"
fi

# 激活插件
echo -e "${RED}activating plugins...${RESET}"
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $HOME/.zshrc

chsh -s /usr/bin/zsh

echo -e "${GREEN}restart your terminal and 'source ~/.zshrc'${RESET}"
