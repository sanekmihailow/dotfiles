runtime! debian.vim
au BufRead *access.log* setf httplog

if has("syntax")
  syntax on
endif

set background=dark
colorscheme sm

# ------------------------------------- maps
nmap <F1> :set autoread<CR>
nmap <F2> :au CursorMoved * checktime<CR>
nmap <F3> :q!<CR>
nmap <F5> :colorscheme sm<CR>
nmap <F6> :colorscheme desert<CR>
nmap <F7> :colorscheme xoria256<CR>
nmap <F8> :colorscheme noctu<CR>
nmap <F9> zfa(<CR>
nmap <F10> zfa[<CR>
nmap <F11> zfa{<CR>
nmap <F12> zO<CR>
nmap <F4> :set syntax=log<CR>

# ------------------------------------ reg
set showcmd        
set showmatch      
set ignorecase     
set hlsearch
set number
set infercase
set incsearch
set smartcase      

if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"--------------------------------------- screen title
if &term == "screen"
  let &titlestring = "vim(" . expand("%:t") . ")"
"  set t_ts=^[k
"  set t_fs=^[\
"  set title
endif
autocmd TabEnter,WinEnter,BufReadPost,FileReadPost,BufNewFile * let &titlestring = 'vim(' . expand("%:t") . ')'

