set nocompatible              " be iMproved, required
filetype off                  " required

source ~/.homesick/repos/dotfiles/home/.vim/.fzf/fzf.vim

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

syntax on
filetype plugin indent on    " required

set backspace=indent,eol,start
set tabstop=2
set nosmartindent
set autoindent
set cursorline    " highlight the current line the cursor is on

set laststatus=2
set expandtab
set shiftwidth=2
set softtabstop=2
set cmdheight=2

" Numbers
set number
set numberwidth=5

"sm: flashes matching brackets or parentheses
set showmatch

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set smarttab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" When scrolling off-screen do so 3 lines at a time, not 1
set scrolloff=3

map , \
let mapleader = ","

map <C-n> :NERDTreeToggle<CR>
"map <leader>r :!rspec <CR>

:set autoread
:set noswapfile
:set background=dark

:colorscheme nova
:match Error /\s\+$/

" If ycu wantc:UltiSnipsEdit to split your windowc
let g:UltiSnipsEditSplit="vertical"
let g:NERDTreeIndicatorMapCustom = {
      \ "Modified"  : "✹",
      \ "Staged"    : "✚",
      \ "Untracked" : "✭",
      \ "Renamed"   : "➜",
      \ "Unmerged"  : "═",
      \ "Deleted"   : "✖",
      \ "Dirty"     : "✗",
      \ "Clean"     : "✔︎",
      \ "Unknown"   : "?"
      \ }

let g:rbpt_max = 16

let g:rbpt_loadcmd_toggle = 0

noremap, j gj
noremap k gk
noremap gj j
noremap gk k

" Disable arrow keys
nnoremap <up> <Nop>
nnoremap <down> <Nop>
nnoremap <left> <Nop>
nnoremap <right> <Nop>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

"bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Remap F1 from Help to ESC.  No more accidents.
nmap <F1> <Esc>
map! <F1> <Esc>

" Strip Whitespace
nnoremap <leader>ws :StripWhitespace<CR>

" Copy and Paste out of vim
set clipboard=unnamed

" Indentation
nnoremap == gg=G``

" JSX
let g:jsx_ext_required = 0

set statusline+=%#warningmsg#
set statusline+=%*

map <c-p> :execute 'FZF'<CR>
map <leader>g :execute 'GFiles?'<CR>
map :W :w
map :Q :q
map :WQ :wq
map :Wq :wq

" Add the pry debug line with \bp (or <Space>bp, if you did: map <Space> <Leader> )
map <Leader>bp orequire'pry';binding.pry<esc>:w<cr>
" Alias for one-handed operation:
map <Leader><Leader>p <Leader>bp

command! -bang -nargs=1 Search
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '. shellescape(expand('<args>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nmap <silent> <Leader>s :execute 'Find'<CR>
command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '. shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" tComment
map <c-c> <c-_><c-_>

" pymode
let g:pymode_python = 'python3'

if has('python3')
  silent! python3 1
endif

" find corresponding divs with %
packadd! matchit
