call plug#begin()
  Plug 'junegunn/fzf.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'dense-analysis/ale'
  Plug 'ggml-org/llama.vim'
call plug#end()

" FZF
set rtp+=/opt/homebrew/opt/fzf
" Default fzf options
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --no-ignore --glob "!**/.git/*"'
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline --height=40%'
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

syntax on
set number
set autoindent
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

let g:tmux_navigator_no_mappings = 1

noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>

augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

augroup json_folding
    au!
    au FileType json setlocal foldmethod=syntax
augroup END

augroup FileTypeSettings
  au!
  autocmd FileType javascript,json,typescript,*.scss setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType html setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd BufRead,BufNewFile */aftershock/*.js setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
  autocmd FileType h,c setlocal tabstop=2 shiftwidth=2 expandtab
augroup END

" Initialize configuration dictionary
" # Installing dependencies using Homebrew
" brew install fzf bat ripgrep the_silver_searcher perl universal-ctags
let g:fzf_vim = {}
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --no-ignore'

function! FzfSearchWordUnderCursor()
  let word = expand('<cword>')
  if !empty(word)
    execute 'Rg ' . word
  else
    echo 'No word under the cursor.'
  endif
endfunction

nnoremap <leader>g :call FzfSearchWordUnderCursor()<CR>

autocmd BufRead,BufNewFile *.ts,*.tsx set filetype=typescript
autocmd BufRead,BufNewFile *.js,*.jsx set filetype=javascript

" ALE

" Pressing ,aj/,ak in my case jumps to next/previous info/warning/error message in file.
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

autocmd FileType javascript map <buffer> <c-]> :ALEGoToDefinition<CR>
autocmd FileType typescript map <buffer> <c-]> :ALEGoToDefinition<CR>
autocmd FileType typescriptreact map <buffer> <c-]> :ALEGoToDefinition<CR>
nnoremap K :ALEHover<CR>
" Use gr when you want to find locations where your function is used.
nnoremap <silent> gr :ALEFindReferences<CR>
" If you need to rename something in a smart way use this command.
nnoremap <leader>rn :ALERename<CR>

nnoremap <leader>qf :ALECodeAction<CR>
vnoremap <leader>qf :ALECodeAction<CR>

let js_fixers = ['prettier', 'eslint']

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['ruff'],
\   'javascript': js_fixers,
\   'javascript.jsx': js_fixers,
\   'typescript': js_fixers,
\   'typescriptreact': js_fixers,
\   'css': ['prettier'],
\   'json': ['prettier']
\}

let g:ale_linters = {
\   'python': ['ruff', 'flake8']
\}

let g:ale_enabled = 0
autocmd FileType python let b:ale_enabled = 1
autocmd FileType javascript,typescript,typescriptreact,json let b:ale_enabled = 1


let g:ale_fix_on_save = 1

" LA
let g:llama_config= {}
