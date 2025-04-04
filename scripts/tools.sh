#! /bin/bash
set -e
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update

cargo install --locked yazi-fm yazi-cli

curl -LsSf https://astral.sh/uv/install.sh | sh

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
