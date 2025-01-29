# ide-setup
Dotfiles and configs:

## bash

.inputrc - bash command completion based on command history

## Vim

### Tmux

.tmux-conf - for tmux/Vim integration to normalize terminal sessions, Vim tabs and splits

### Vim

- install [vim](https://github.com/vim/vim.git) from source because you need Vim 901 or above for llama.vim
(Assumes you already have Ruby and Python installed)
```
git clone https://github.com/vim/vim.git
cd vim && ./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp
make
sudo make install
```
- replace whatever vim you have with the new one. On my WSL2 Ubuntu:
```
sudo update-alternatives --install /usr/bin/vim vim [path-to-vim-repo]/src/vim 100
sudo update-alternatives --config vim

vim --version
```

axiomatic understandings:
- `<leader>` key is `\`
- `<c-[KEY]>` - c for the control key
- `<c-o>` - go back to previous position
- `<c-g>` - print the current file name
- Marks:
    - `ma` - set mark `a` at cursor
    - `'a` - jump to mark line `a`
    - `\a` - jump to mark `a`

.vimrc
- [vim-plug](https://github.com/junegunn/vim-plug) for plugins management
    - `:PlugInstall` to install plugins
- [fzf](https://github.com/junegunn/fzf) for fuzzy search
    - `<leader>g` - search for a word under cursor
    - `:Ag [PATTERN]` - [ag](https://github.com/ggreer/the_silver_searcher) search result
    - `:Rg [PATTERN]` - [rg](https://github.com/BurntSushi/ripgrep) search in current repo
    - `:RG [PATTERN]` - [rg](https://github.com/BurntSushi/ripgrep) search in current repo; relaunch ripgrep on every keystroke
    - `CTRL-t` / `CTRL-x` / `CTRL-v` - open in a new tab, a new split, or in a new vertical split
- [ALE](https://github.com/dense-analysis/ale) for linting w/prettier and eslint
    - `<leader>aj` / `<leader>ak` - jump to the next / previous error
    - `<c-]>` - go to the definition
    - `K` - hover info
    - `gr` - find references
    - `rn` - rename
    - `qf` - fix
- [llama.vim](https://github.com/ggml-org/llama.vim) for local LLM-assisted text completion
    - Auto-suggest on cursor movement in `Insert` mode
    - Toggle the suggestion manually by pressing `Ctrl+F`
    - Accept a suggestion with `Tab`
    - Accept the first line of a suggestion with `Shift+Tab`

### llama.cpp

#### OSX

- `brew install llama.cpp`

#### Ubuntu on WSL2

- download CUDA 12.4 (because that's what `nvidia-smi` reports) from [NVIDIA](https://developer.nvidia.com/cuda-12-4-0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local)

It will instruct something like

```
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda-repo-wsl-ubuntu-12-4-local_12.4.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-4-local_12.4.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-4
```

- when done, enrich your $PATH:

```
echo 'export PATH="/usr/local/cuda-12.4/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

- install curl so you can fetch models from huggingface

```
sudo apt-get update
sudo apt-get install libcurl4-openssl-dev
```

- clone the [llama.cpp repo](https://github.com/ggerganov/llama.cpp)

- configure for your card (I check ARCHITECTURE so it's right for you)

```
cmake -B build -DGGML_CUDA=ON -DLLAMA_CURL=ON -DCMAKE_CUDA_ARCHITECTURES=89
```

- build

```
cmake --build build --config Release -- -j1
```

- enrich your $PATH with `[wherever you cloned the llama.cpp repo]/build/bin`

#### LLM

- Recommended LLM for >16GB VRAM
```
llama-server \
    -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256
```
