set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim  " set the runtime path to include Vundle
let path='$HOME/.vim/bundle'

" === Plugins

call vundle#begin('$HOME/.vim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'itchyny/lightline.vim'
Plugin 'itchyny/vim-gitbranch'
Plugin 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plugin 'terryma/vim-multiple-cursors'
Plugin 'zhou13/vim-easyescape'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on     " re-enable filetype functionality

" Color scheme
syntax enable
set background=dark
colorscheme edge

" === Pluging Configuration

" -> Lightline
set laststatus=2
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',
      \ },
      \ }

" -> Easy Escape
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 100
cnoremap jk <ESC>
cnoremap kj <ESC>

" -> CtrlP

" Use with Silver Searcher 
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif


" === Auto Commands
autocmd VimEnter * NERDTree                                        " Start NERDTree on startup
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") 
  \ && b:NERDTree.isTabTree()) | q | endif                         " Close NERDTree explore after last window closes

" === Settings

let mapleader = ","     " Set `<leader>` key

set cursorline						                              " Highlight the current line
set colorcolumn=80                                      " Show vertical line @80
set number						                                  " Show line numbers
set noshowmode						                              " Disable showing mode (e.g. INSERT) because lightline pluging already does
set nowrap						                                  " Don't wrap code
set linebreak                                           " Wrap lines at convenient points
set tabstop=2 						                              "
set shiftwidth=2					                              "
set expandtab						                                "
set undofile						                                " Undo changes even after a file as been closed then reopened
set undodir=~/.vim/undodir

let &t_SI = "\e[5 q"    " Blinking vertical cursor
let &t_EI = "\e[5 q"    " Blinding vertical cursor

let NERDTreeMinimalUI  = 1  " NERDTree Minimal UI
let NERDTreeDirArrows  = 1  " NERDTREE Directional Arrows
let NERDTreeShowHidden = 1   " Show hidden files

" === Mappings

" Window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

" Undo / Redo
nnoremap <C-Z> u
nnoremap <C-Y> <C-R>
inoremap <C-Z> <C-O>u
inoremap <C-Y> <C-O><C-R>

" Delete Lines
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d

" Move lines up/down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Grep word under cursor
nnoremap <Leader>g :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>

" === Search

set hlsearch
set incsearch

nnoremap <C-f> <ESC>:set hls! hls?<cr>
inoremap <C-f> <C-o>:set hls! hls?<cr>
vnoremap <C-f> <ESC>:set hls! hls?<cr> <bar> gv

" Enable mouse selection
set mouse=a
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>:CountWord<cr>

" Define a function to count the number of words
fun! CountWordFunction()
    try
        let l:win_view = winsaveview()
        let l:old_query = getreg('/')
        let var = expand("<cword>")
        exec "%s/" . var . "//gn"
    finally
        call winrestview(l:win_view)
        call setreg('/', l:old_query)
    endtry
endfun

command! -nargs=0 CountWord :call CountWordFunction()

