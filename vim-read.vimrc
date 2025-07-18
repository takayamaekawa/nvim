" Windows
"$HOME/AppData/Local/nvim/vimrc
" Linux
" $HOME/.config/nvim/vimrc
let s:my_vimrc = expand('')
if filereadable(s:my_vimrc)
  source %s:my_vimrc
endif
