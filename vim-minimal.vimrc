" Minimal Vim configuration - Ultra lightweight version
" This is a stripped-down version focusing on essential settings only

" WSL configuration
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
else
  set clipboard=unnamedplus
endif

set nocompatible
set number
set ambiwidth=double
set tabstop=2
set expandtab
set shiftwidth=2
set smartindent
set ignorecase
set smartcase
set hlsearch
set backspace=indent,eol,start
set mouse=a

" Leader key
let mapleader = " "

" Essential mappings only
" Quick escape
imap jj <Esc>

" Quick quit all
nnoremap <Leader>qq :qall<CR>

nnoremap <S-a> ggVG
nnoremap <S-f> gg=G
nnoremap <S-w> :w<CR>
nnoremap <leader>hh :nohlsearch<CR>

" Basic navigation
nnoremap <C-j> :bprevious<CR>
nnoremap <C-k> :bnext<CR>

" Enable syntax and filetype
syntax enable
filetype plugin indent on

" GitHub Copilot support (uncomment if you want to add copilot.vim plugin)
" " Add this to your vim-plug setup:
" " Plug 'github/copilot.vim'
" "
" " Configuration:
" " let g:copilot_enabled = 1
" " imap <silent><script><expr> <C-J> copilot#Accept(\"\\<CR>\")
" " let g:copilot_no_tab_map = v:true
" " imap <C-]> <Plug>(copilot-next)
" " imap <C-[> <Plug>(copilot-previous)
" " imap <C-\\> <Plug>(copilot-dismiss)
