
call plug#begin('~/.vim/plugged')

" tools

Plug 'mileszs/ack.vim'
Plug 'ap/vim-buftabline'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'mtth/scratch.vim'
Plug 'reedes/vim-wordy'
Plug 'digitaltoad/vim-pug'

" languages

Plug 'guns/vim-clojure-static',  {'for': 'clojure'}
Plug 'vim-scripts/paredit.vim',  {'for': 'clojure'}
Plug 'luochen1990/rainbow',      {'for': 'clojure'}
Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
Plug 'elixir-lang/vim-elixir',   {'for': 'elixir'}
Plug 'fatih/vim-go',             {'for': 'go'}
Plug 'fatih/vim-hclfmt',         {'for': ['hcl', 'nomad', 'tf']}
Plug 'pangloss/vim-javascript',  {'for': 'javascript'}
Plug 'mxw/vim-jsx',              {'for': 'javascript'}
Plug 'vim-ruby/vim-ruby',        {'for': 'ruby'}
Plug 'rust-lang/rust.vim',       {'for': 'rust'}
Plug 'sl4m/swift.vim',           {'for': 'swift', 'branch': 'vim-only'}
Plug 'cespare/vim-toml',         {'for': 'toml'}
Plug 'kana/vim-vspec',           {'for': 'vim'}
Plug 'pangloss/vim-javascript',  {'for': 'javascript'}
Plug 'mxw/vim-jsx',              {'for': 'jsx'}

" misc

Plug 'wikitopian/hardmode'

call plug#end()
