
"256bit color GUI
set t_Co=256

"Select utf-8
set encoding=utf-8
scriptencoding utf-8

"VIEW CONFIG

"Show line numbers
set number

"Highlight cursorline
set cursorline

"Always show status bar
set laststatus=2

"Highlight ()
set showmatch

"Visualization invisibility char
set list

"set replacement symbol
set listchars=tab:>-,eol:¬

"Hide start up message
set shortmess+=I

"Select font
set guifont=Source\ Code\ Pro\ for\ Powerline\ Semibold

"CURSOR CONFIG

"No limit backspace
set backspace=indent,eol,start

"Margin scroll
set scrolloff=8

"Margin scroll side
set sidescrolloff=16

"FILES CONFIG

"Auto read from outside changed
set autoread

"No backup files
set nobackup

"No swap files
set noswapfile


"SEARCH AND REPLACE CONFIG

"Highlight search words
set hlsearch

"Incremental search
set incsearch

"Ignore large or small
set ignorecase

"Distinction only mix word
set smartcase

"To first from last word
set wrapscan


"TAB/INDENT CONFIG

"Tab to Blanks
set expandtab

"Tab width
set tabstop=2

"Auto indent width
set shiftwidth=2

"Continuity tab width
set softtabstop=2

"Auto indent
set autoindent

"Indent according to input
set smartindent


"COMMAND LINE CONFIG

"Enable command line completion
set wildmenu wildmode=list:longest,full

"Command history
set history=1000


"BEEP CONFIG

"Disable beep
set visualbell t_vb=




"PLUGINS CONFIG

"Manage directory by bundle
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

"Manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

"Code complete
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

"Coloring status line
NeoBundle 'itchyny/lightline.vim'
"Coloring html5 tags
NeoBundle 'othree/html5.vim'
"Coloring CSS3
NeoBundle 'hail2u/vim-css3-syntax'

"Color scheme
NeoBundle 'tomasr/molokai'

"Show indent line
NeoBundle 'Yggdroot/indentLine'

"Comment out at once
NeoBundle 'tomtom/tcomment_vim'

"file and directory
NeoBundle 'Shougo/unite.vim'

"git
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

call neobundle#end()


filetype plugin indent on

NeoBundleCheck




"Enable color scheme
syntax enable

"Select color scheme
colorscheme molokai



"molokai config
let g:molokai_original = 1
let g:rehash256 = 1



"unite config
let g:unite_force_overwrite_statusline = 0




"neo complete config
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'




"lightline config
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'git-branch', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencodinf', 'filetype'],
  \              [ 'gitgutter'] ]
  \ },
  \ 'component_function': {
  \   'git-branch': 'LightLineGitBranch',
  \   'readonly': 'LightLineReadonly',
  \   'modified': 'LightLineModified',
  \   'filename': 'LightLineFilename',
  \   'gitgutter': 'LightLineGitGutter'
  \ },
  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3"},
  \ }

function! LightLineModified()
  return &modifiable && &modified ? '+' : ''
endfunction

function! LightLineReadonly()
  return &readonly ? "\ue0a2" : ''
endfunction


function LightLineFilename()
  return &ft == 'unite' ? unite#get_status_string() :
         \ expand('%:t') != '' ? expand('%:t') : '[No Name]'
endfunction

function LightLineGitBranch()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return _ != '' ? "\ue0a0 "._ : ''
  endif
  return ''
endfunction

function LightLineGitGutter()
  if !exists('*GitGutterGetHunkSummary') || !get(g:, 'gitgutter_enabled', 0)
    return ''
  endif
  let symbols = [
              \ g:gitgutter_sign_added,
              \ g:gitgutter_sign_modified,
              \ g:gitgutter_sign_removed ]
  let hunks = GitGutterGetHunkSummary()
  let _ = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(_, symbols[i].' '.hunks[i])
    endif
  endfor
  return join(_,' ')
endfunction



"gitgutter config
let g:gitgutter_max_signs = 1000
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➡'
let g:gitgutter_sign_modified_removed = '➡'
let g:gitgutter_sign_removed = '✘'
