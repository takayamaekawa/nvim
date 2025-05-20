#!/bin/bash

cd "$(dirname "$0")"

mkdir -p ./tmp/

git clone --depth=1 https://github.com/neovim/nvim-lspconfig.git ./tmp/

mkdir -p ./lsp/

mv ./tmp/lsp/*.lua ./lsp/

rm -rf ./tmp/
