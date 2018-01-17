set nocompatible              " be iMproved, required
filetype off                  " required

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

" CtrlP auto cache clearing.
function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained  * CtrlPClearCache
      autocmd BufWritePost * CtrlPClearCache
    augroup END
  endif
endfunction
if has("autocmd")
  autocmd VimEnter * :call SetupCtrlP()
endif

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$',
      \ 'file': '\.so$\|\.dat$|\.DS_Store$'
      \ }

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
