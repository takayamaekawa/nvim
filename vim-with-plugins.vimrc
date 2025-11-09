" Vim configuration with plugins - Port from Neovim
" This configuration includes LSP, formatters, and file manager

" Clipboard configuration
if exists('$WSL_DISTRO_NAME') || (has('win32') || has('win64'))
  " WSL clipboard configuration for Vim
  set clipboard=unnamed

  if executable('win32yank.exe')
    " Auto-sync yank to win32yank
    augroup Yank
      au!
      " Yankにフックしてレジスタに登録された文字をwin32yankにも出力する
      autocmd TextYankPost * :call system('win32yank.exe -i', @")
    augroup END

    " win32yank内の文字を一旦vimのレジスタに登録してからペイストする
    function! WSLPaste()
      let clipboard_content = system('win32yank.exe -o')
      let clipboard_content = substitute(clipboard_content, '\r\n', '\n', 'g')
      let clipboard_content = substitute(clipboard_content, '\r', '\n', 'g')
      call setreg('"', clipboard_content)
      return '""p'
    endfunction

    nnoremap <expr> p WSLPaste()

    " デバッグ用コマンド
    command! WSLClipboardTest echo system('win32yank.exe -o')
  endif

  " Disable bell sounds
  if exists('&belloff')
    set belloff=all
  endif
elseif exists('$SSH_CLIENT') || exists('$SSH_TTY') || exists('$SSH_CONNECTION')
  " SSH/Remote clipboard configuration using OSC 52
  set clipboard=unnamed

  " OSC 52 clipboard functions
  function! OSC52Copy(text)
    let encoded = substitute(system('base64 -w 0', a:text), '\n', '', 'g')
    let osc52 = printf('\e]52;c;%s\a', encoded)
    silent! call writefile([osc52], '/dev/tty', 'b')
  endfunction

  function! OSC52Paste()
    " OSC 52 doesn't support paste, so we just use the normal register
    return '""p'
  endfunction

  " Auto-sync yank to OSC 52
  augroup OSC52Yank
    au!
    autocmd TextYankPost * call OSC52Copy(@")
  augroup END

  " OSC 52 paste (fallback to normal register)
  nnoremap <expr> p OSC52Paste()

  " Manual OSC 52 copy command
  command! -range OSC52CopyRange call OSC52Copy(join(getline(<line1>, <line2>), "\n"))

  " Disable bell sounds
  if exists('&belloff')
    set belloff=all
  endif
else
  " Standard clipboard configuration
  set clipboard=unnamedplus
endif

set nocompatible
filetype off

" vim-plug setup
" Debug mode setting (set to 0 to disable all debug output)
let g:vim_debug = 0

" Logging function for debugging
function! LogMessage(msg)
  if g:vim_debug
    let timestamp = strftime("%Y-%m-%d %H:%M:%S")
    let logfile = "./vim_startup.log"
    call writefile([timestamp . " - " . a:msg], logfile, "a")
    echom a:msg
  endif
endfunction

" vim-plug installation check (simplified, no logging)
if has('win32') || has('win64')
  let g:vim_plug_path = expand('~/.vim/autoload/plug.vim')
  
  if empty(glob(g:vim_plug_path))
    " Create directory and download vim-plug
    let vim_autoload_dir = expand('~/.vim/autoload')
    call mkdir(vim_autoload_dir, 'p')
    
    let download_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    let target_file = vim_autoload_dir . "/plug.vim"
    let ps_cmd = 'powershell -Command "Invoke-WebRequest -Uri ''' . download_url . ''' -OutFile ''' . target_file . ''' -UseBasicParsing"'
    silent! call system(ps_cmd)
  endif
else
  " Auto-install vim-plug if not found (Linux/Mac)
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | if !empty($MYVIMRC) | source $MYVIMRC | endif
  endif
endif

" Plugin setup (simplified)
if !empty(glob('~/.vim/autoload/plug.vim'))
  " Source vim-plug if needed
  if !exists('*plug#begin')
    silent! execute 'source ' . expand('~/.vim/autoload/plug.vim')
  endif
  
  " Start plugin setup
  if exists('*plug#begin')
    call plug#begin('~/.vim/plugged')
  endif
endif

  " LSP and completion
  Plug 'dense-analysis/ale'                    " LSP and linting
  Plug 'prabirshrestha/vim-lsp'               " LSP client
  Plug 'mattn/vim-lsp-settings'               " Auto LSP setup
  Plug 'prabirshrestha/asyncomplete.vim'      " Async completion
  Plug 'prabirshrestha/asyncomplete-lsp.vim'  " LSP completion source

  " AI assistance
  Plug 'github/copilot.vim'                   " GitHub Copilot

  " File manager
  Plug 'preservim/nerdtree'                   " File tree
  Plug 'Xuyuanp/nerdtree-git-plugin'          " Git integration for NerdTree
  Plug 'ryanoasis/vim-devicons'               " File icons (optional)

  " Fuzzy finder (telescope alternative)
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Formatters
  Plug 'vim-autoformat/vim-autoformat'        " Auto formatting
  Plug 'editorconfig/editorconfig-vim'        " EditorConfig support

  " Git integration
  Plug 'tpope/vim-fugitive'                   " Git wrapper
  Plug 'airblade/vim-gitgutter'               " Git diff in gutter

  " UI and status
  Plug 'vim-airline/vim-airline'              " Status line
  Plug 'vim-airline/vim-airline-themes'       " Status line themes

  " Editing enhancements
  Plug 'tpope/vim-commentary'                 " Comment toggling
  Plug 'tpope/vim-surround'                   " Surround text objects
  Plug 'jiangmiao/auto-pairs'                 " Auto pairs

  " Syntax highlighting
  Plug 'sheerun/vim-polyglot'                 " Language pack

  " Session management
  Plug 'tpope/vim-obsession'                  " Session management

  " Terminal (for older Vim versions)
  if has('terminal') || has('nvim')
    Plug 'voldikss/vim-floaterm'              " Floating terminal
  endif

  " End plugin setup
  if exists('*plug#end')
    call plug#end()
    
    " Auto-install missing plugins
    if exists('g:plugs')
      let missing_plugins = filter(values(g:plugs), '!isdirectory(v:val.dir)')
      if len(missing_plugins) > 0
        autocmd VimEnter * PlugInstall --sync | if !empty($MYVIMRC) | source $MYVIMRC | endif
      endif
    endif
  endif


" Enable filetype plugins
filetype plugin indent on
syntax enable

" Basic settings (from original vimrc)
set number
set notitle
set ambiwidth=double
set tabstop=2
set expandtab
set shiftwidth=2
set smartindent
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set nrformats=hex
set hidden
set virtualedit=block
set whichwrap=b,s,<,>,[,],h,l
set backspace=indent,eol,start
set wildmenu
set ignorecase
set smartcase
set wrapscan
set hlsearch
set showmatch
set matchtime=1
set showtabline=0
set termguicolors
set laststatus=0
set statusline=
set conceallevel=2
set updatetime=100
set mouse=a

" Leader key
let mapleader = " "

" ============================================================================
" GitHub Copilot Configuration
" ============================================================================
" Enable Copilot for all file types
let g:copilot_enabled = 1

" Copilot key mappings
" Ctrl+J to accept suggestion
imap <silent><script><expr> <C-J> copilot#Accept(\"\\<CR>\")
let g:copilot_no_tab_map = v:true

" Ctrl+] to next suggestion
imap <C-]> <Plug>(copilot-next)
" Ctrl+[ to previous suggestion
imap <C-[> <Plug>(copilot-previous)
" Ctrl+\\ to dismiss suggestion
imap <C-\\> <Plug>(copilot-dismiss)

" Disable Copilot for specific filetypes if needed
" let g:copilot_filetypes = {'*': v:false, 'python': v:true, 'javascript': v:true}

" ============================================================================
" ALE Configuration (LSP replacement)
" ============================================================================
let g:ale_enabled = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1

" ALE linters
let g:ale_linters = {
\   'javascript': ['biome'],
\   'typescript': ['biome'],
\   'python': ['pyright'],
\   'rust': ['analyzer'],
\   'go': ['gopls'],
\   'c': ['clangd'],
\   'cpp': ['clangd'],
\   'java': ['eclipse-jdt-ls'],
\   'scala': ['metals'],
\   'vim': ['vimls'],
\   'lua': ['lua-language-server'],
\   'json': ['jsonls'],
\   'yaml': ['yamlls'],
\   'html': ['html-languageserver'],
\   'css': ['cssls'],
\}

" ALE fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['biome'],
\   'typescript': ['biome'],
\   'python': ['black', 'isort'],
\   'rust': ['rustfmt'],
\   'go': ['gofmt'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'java': ['google_java_format'],
\   'scala': ['scalafmt'],
\   'json': ['prettier'],
\   'yaml': ['prettier'],
\   'html': ['prettier'],
\   'css': ['prettier'],
\}

" ============================================================================
" NERDTree Configuration
" ============================================================================
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeAutoCenter = 1
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeNaturalSort = 1
let g:NERDTreeSortHiddenFirst = 1

" Auto-open NERDTree when starting Vim with a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) | exe 'NERDTree' argv()[0] | wincmd p | endif

" Close Vim if NERDTree is the only window remaining
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ============================================================================
" FZF Configuration
" ============================================================================
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_preview_window = 'right:50%'

" ============================================================================
" Asyncomplete Configuration
" ============================================================================
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200
let g:asyncomplete_close_popup_on_insert = 1

" ============================================================================
" Airline Configuration
" ============================================================================
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1

" ============================================================================
" Key Mappings
" ============================================================================

" Basic editing (from original vimrc)
" Quick escape
inoremap jj <Esc>

" Quick quit all
nnoremap <Leader>qq :qall<CR>

nnoremap <S-a> ggVG
nnoremap <S-f> gg=G
nnoremap <S-w> :w<CR>
nnoremap <leader>o :put =''<CR>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <Tab> >>
nnoremap <S-Tab> <<
inoremap <Tab> <C-t>
inoremap <S-Tab> <C-d>
nnoremap <leader>hh :nohlsearch<CR>

" Navigation
nnoremap <A-Left> <C-w>h
nnoremap <A-Down> <C-w>j
nnoremap <A-Up> <C-w>k
nnoremap <A-Right> <C-w>l
nnoremap <C-w>0 :close<CR>
nnoremap <leader>wc :close<CR>
nnoremap <C-\><C-_> :tabnext<CR>
nnoremap <C-\><C-\> :tabprevious<CR>
nnoremap <C-\><C-w> :tabclose<CR>
nnoremap <leader>tc :tabclose<CR>

" Buffer navigation
nnoremap <C-j> :bprevious<CR>
nnoremap <C-k> :bnext<CR>
nnoremap <leader>ww :bdelete<CR>

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fr :Rg<CR>

" LSP/ALE mappings
nnoremap <leader>gd :ALEGoToDefinition<CR>
nnoremap <leader>gr :ALEFindReferences<CR>
nnoremap <leader>gh :ALEHover<CR>
nnoremap <leader>rn :ALERename<CR>
nnoremap <leader>ca :ALECodeAction<CR>
nnoremap <leader>d :ALEDetail<CR>
nnoremap [d :ALEPreviousWrap<CR>
nnoremap ]d :ALENextWrap<CR>

" Formatting
nnoremap <leader>df :ALEFix<CR>
nnoremap <leader>af :Autoformat<CR>

" Git
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Git diff<CR>
nnoremap <leader>gb :Git blame<CR>

" Completion mappings
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" Tab size functions (from original vimrc)
function! SetTabstop(tabstop)
  let &shiftwidth = a:tabstop
  echo "Set tab size to " . a:tabstop
endfunction

for i in range(1, 8)
  execute "nnoremap <leader>t" . i . " :call SetTabstop(" . i . ")<CR>"
endfor

" dos2unix function (from original vimrc)
function! Dos2unix()
  let filename = expand('%')
  if filename == ''
    echo 'No file is currently open'
    return
  endif

  if &modified
    write
  endif

  silent execute '!dos2unix ' . shellescape(filename)
  edit!
  echo 'dos2unix executed on: ' . filename
endfunction

nnoremap <leader>du :call Dos2unix()<CR>

" Terminal mappings (if available)
if has('terminal')
  tnoremap <C-\><C-_> <C-\><C-n>:tabnext<CR>
  tnoremap <C-\><C-\> <C-\><C-n>:tabprevious<CR>
  tnoremap <C-\><C-w> <C-\><C-n>:tabclose<CR>
  tnoremap <C-\><C-h> <C-\><C-n><C-w>h
  tnoremap <C-\><C-j> <C-\><C-n><C-w>j
  tnoremap <C-\><C-k> <C-\><C-n><C-w>k
  tnoremap <C-\><C-l> <C-\><C-n><C-w>l
endif

" Floating terminal (if vim-floaterm is available)
if exists(':FloatermNew')
  nnoremap <leader>tt :FloatermNew<CR>
  nnoremap <leader>th :FloatermToggle<CR>
  nnoremap <leader>tk :FloatermKill<CR>
endif

" ============================================================================
" Auto commands
" ============================================================================

" Auto-format on save for specific filetypes
autocmd BufWritePre *.py,*.js,*.ts,*.json,*.yaml,*.yml,*.html,*.css :Autoformat

" Restore cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" ============================================================================
" Color scheme and appearance
" ============================================================================
if has('termguicolors')
  set termguicolors
endif

" Set color scheme (you can change this)
" colorscheme desert
" colorscheme slate

" Highlight current line
set cursorline

" Show line numbers
set number

" ============================================================================
" Performance optimizations
" ============================================================================
set lazyredraw
set ttyfast
set synmaxcol=200

" ============================================================================
" Backup and swap files
" ============================================================================
set nobackup
set nowritebackup
set noswapfile
