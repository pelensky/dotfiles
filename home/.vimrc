set nocompatible              " be iMproved, required
filetype off                  " required

syntax on
filetype plugin indent on    " required

set backspace=indent,eol,start
set nosmartindent
set autoindent
set cursorline    " highlight the current line the cursor is on

set laststatus=2
set cmdheight=2

" Numbers
set number
set numberwidth=5

"sm: flashes matching brackets or parentheses
set showmatch

" When scrolling off-screen do so 3 lines at a time, not 1
set scrolloff=3

map , \
let mapleader = ","

map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
"map <leader>r :!rspec <CR>

:set autoread
:set noswapfile
:set background=dark

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

" tComment
map <c-c> <c-_><c-_>

" pymode
let g:pymode_python = 'python3'

if has('python3')
  silent! python3 1
endif

" find corresponding divs with %
packadd! matchit

" Spell check
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Svelte
let g:vim_svelte_plugin_load_full_syntax = 1
let g:svelte_preprocessor_tags = [
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
  \ ]
let g:svelte_preprocessors = ['typescript']

" Codeium
nnoremap <leader>c :call codeium#Chat()<CR>

" Line endings
set fileformat=unix

" Linter
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:ale_fixers = {
  \ 'ruby': ['rubocop'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'tslint'],
  \ 'css': ['prettier'],
  \ 'scss': ['prettier', 'stylelint'],
  \ 'html': ['prettier']
\ }

let g:ale_fix_on_save = 1


