" Windows
"$HOME/AppData/Local/nvim/vim-with-plugins.vimrc
" Linux
" $HOME/.config/nvim/vim-with-plugins.vimrc
let s:my_vimrc = expand('$HOME/.config/nvim/vim-with-plugins.vimrc')
if filereadable(s:my_vimrc)
  execute 'source ' . s:my_vimrc
endif
