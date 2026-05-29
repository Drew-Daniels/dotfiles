" Shared settings sourced by both Neovim (init.lua) and Vim (.vimrc)

" ── Options ──────────────────────────────────────────────────────────

set termguicolors
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set ignorecase
set smartcase
set number
set relativenumber
set splitbelow
set splitright
set nohlsearch
set wildignore=node_modules/*
set syntax=on
set virtualedit=block
set foldopen-=search
set shellcmdflag=-ic

autocmd FileType * set formatoptions-=ro

" ── Keymaps ──────────────────────────────────────────────────────────

let mapleader = " "
let maplocalleader = ","

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
inoremap <silent> <C-b> <CR><ESC>kA<CR>
inoremap <C-o> <CR><ESC>I
tnoremap <Esc> <C-\><C-n>

function! YankBufferAbsFilePath()
  let l:path = expand('%:p')
  let @+ = l:path
  echo "Copied Buffer File Path to Clipboard: " . l:path
endfunction

function! YankBufferRelFilePath()
  let l:path = fnamemodify(expand('%:p'), ':.')
  let @+ = l:path
  echo "Copied Buffer File Path to Clipboard: " . l:path
endfunction

function! YankBufferFileName()
  let l:name = fnamemodify(expand('%:p'), ':t')
  let @+ = l:name
  echo "Copied Buffer File Name to Clipboard: " . l:name
endfunction

nnoremap <silent> <leader>Ya :call YankBufferAbsFilePath()<CR>
nnoremap <silent> <leader>Yr :call YankBufferRelFilePath()<CR>
nnoremap <silent> <leader>Yf :call YankBufferFileName()<CR>

" ── Filetypes ────────────────────────────────────────────────────────

augroup shared_filetypes
  autocmd!
  autocmd BufNewFile,BufRead *.html.en set filetype=html
  autocmd BufNewFile,BufRead *.js.map set filetype=json
  autocmd BufNewFile,BufRead *.mdc set filetype=markdown
  autocmd BufNewFile,BufRead *.jira set filetype=jira
  autocmd BufNewFile,BufRead *.swcrc set filetype=json
  autocmd BufNewFile,BufRead *.snapshot set filetype=javascript
  autocmd BufNewFile,BufRead *.gotmpl set filetype=gotmpl
  autocmd BufNewFile,BufRead *.yaml.gotmpl set filetype=yaml
  autocmd BufNewFile,BufRead */templates/*.yml,*/templates/*.yaml set filetype=helm
  autocmd BufNewFile,BufRead */templates/NOTES.txt set filetype=helm
  autocmd BufNewFile,BufRead helmfile*.yml,helmfile*.yaml set filetype=helm
augroup END
