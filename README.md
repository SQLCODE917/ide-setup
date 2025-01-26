# ide-setup
Dotfiles and configs:

## bash

.inputrc - bash command completion based on command history

## Vim

### Tmux

.tmux-conf - for tmux/Vim integration to normalize terminal sessions, Vim tabs and splits

### Vim

axiomatic understandings:
- `<leader>` key is `\`
- `<c-[KEY]` - c for the control key
- `<c-o>` - go back to previous position
- `<c-g>` - print the current file name

.vimrc
- [vim-plug](https://github.com/junegunn/vim-plug) for plugins management
    - `:PlugInstall` to install plugins
- [fzf](https://github.com/junegunn/fzf) for fuzzy search
    - `<leader>g` - search for a word under cursor
    - `:Ag [PATTERN]` - [ag](https://github.com/ggreer/the_silver_searcher) search result
    - `:Rg [PATTERN]` - [rg](https://github.com/BurntSushi/ripgrep) search in current repo
    - `:RG [PATTERN]` - [rg](https://github.com/BurntSushi/ripgrep) search in current repo; relaunch ripgrep on every keystroke
    - `<c-t>` / `CTRL-X` / `CTRL-V` - open in a new tab, a new split, or in a new vertical split
- [ALE](https://github.com/dense-analysis/ale) for linting w/prettier and eslint
    - `<leader>aj` / `<leader` - jump to the next / previous error
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

- `brew install llama.cpp`
- Recommended LLM for >16GB VRAM
```
llama-server \
    -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF \
    --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 \
    --ctx-size 0 --cache-reuse 256
```
