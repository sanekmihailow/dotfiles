runtime! debian.vim

if has("syntax")
  syntax on
endif

set background=dark
colorscheme sm

" --------------------------- Autostart -------------------------- {
"log webserver
au BufRead *nginx/*.log*,*nginx/*_log* setf nginx
au BufRead *apache2/*.log*,*apache2/*.log*,*httpd/*.log*,*access.log* setf httplog
"conf asterisk
au BufNewFile,BufRead *asterisk*/*voicemail.conf* setf asteriskvm
au BufNewFile,BufRead *asterisk/*.conf* setf asterisk
au BufNewFile,BufRead *asterisk/*.ael* setf asterisk
"conf log
au BufNewFile,BufRead *.log* setf log

" yaml
"augroup FileTypeFolding
"    autocmd!
"    autocmd FileType yaml,yml setlocal expandtab ts=2 sw=2 sts=2 expandtab ai foldmethod=indent nofoldenable execute 'normal! zR'
"    autocmd FileType * if &filetype != 'yaml' && &filetype != 'yml' | setlocal foldmethod=manual nofoldenable | endif
"augroup END
autocmd FileType yaml,yml setlocal ts=2 sw=2 sts=2 et ai si foldmethod=indent nofoldenable | normal! zR'

execute "set <M-x>=\ex"
execute "set <M-z>=\ez"
let &t_EI = "\e[1 q"
let &t_SI = "\e[5 q"
let &t_SR = "\e[4 q"
" ------------- }



" -------------------------------- Syntax ------------------------------ {
syn match log_comment   '\c\#.*$'
syn match log_comment   '\c\^#.*$'
syn match log_comment   '\c\^;.*$'
syn match log_comment   '\c\^".*$'
" ------------- }



" -------------------------------- Highlight text ------------------------------ {
hi link   log_comment     Comment
highlight SpecialKey      term=standout ctermfg=darkgray guifg=darkgray
" ------------- }


" -------------------------------- Custom Functions ------------------------------ {
function! MyFoldMapping()
    " Получаем текущий символ под курсором артуз
    let l:current_char = getline('.')[col('.') - 1]

    let l:context = ''
    let l:stack = []

    " Проверяем, находится ли курсор на одном из символов <([\{ 
    if l:current_char =~# '[<\(\[\{]'
        let l:context = l:current_char
    else
        " Получаем текущую строку и номер строки
        let l:current_line_number = line('.')

        " Проходим по строкам выше текущей строки
        for l:line_number in range(l:current_line_number - 1, 1, -1)
            let l:line = getline(l:line_number)

            " Ищем открывающие теги, скобки и фигурные скобки в правильном порядке
            if l:line =~ '<\w\+\s*$'
                call add(l:stack, '<')
            elseif l:line =~ '\[\s*$'
                call add(l:stack, '[')
                "echom 'Added [ to stack: '.string(l:stack)         "#C- debug message
            elseif l:line =~ '(\s*$'
                call add(l:stack, '(')
            elseif l:line =~ '{\s*$'
                call add(l:stack, '{')
            endif

            " Ищем закрывающие теги, скобки и фигурные скобки
            if l:line =~ '>\s*$'
                if !empty(l:stack)
                    call remove(l:stack, -1)
                endif
            elseif l:line =~ '\]\s*$'
                if !empty(l:stack)
                    call remove(l:stack, -1)
                    "echom 'Removed ] from stack: '.string(l:stack) "#C- debug message
                endif
            elseif l:line =~ ')\s*$'
                if !empty(l:stack)
                    call remove(l:stack, -1)
                endif
            elseif l:line =~ '}\s*$'
                if !empty(l:stack)
                    call remove(l:stack, -1)
                endif
            endif

            " Если стек не пустой, используем последний элемент как контекст
            if !empty(l:stack)
                let l:context = l:stack[-1]
                "echom 'Context set to: '.l:context                 "#C- debug message
                break
            endif
        endfor
    endif

    " Перемещаем курсор на символ в стеке перед выполнением команды zfa
    if !empty(l:stack)
        let l:context_line_number = l:line_number
        call cursor(l:context_line_number, 1)
        execute "normal! f".l:context
    endif

    " Выполняем маппинг в зависимости от найденного контекста и foldmethod
    if &foldmethod ==# 'indent'
        execute "normal! za"
    else
        " Для foldmethod=manual используем zfa
        if l:context == '<'
            execute "normal! zfa<"
        elseif l:context == '['
            execute "normal! zfa["
        elseif l:context == '('
            execute "normal! zfa("
        elseif l:context == '{'
            execute "normal! zfa{"
        else
            execute "normal! zfa!"
        endif
    endif
endfunction

function! MyToggleNumbers()
    if &number
        set nonumber
    else
        set number
    endif
endfunction


function! MyEnsureDirExists(dir)
    if !isdirectory(a:dir)
        call mkdir(a:dir, "p")
    endif
endfunction

function! MyTogglePasteMode()
    if &paste
        set nopaste
        echom "NO paste mode"
    else
        set paste
        echom "paste mode ON"
    endif
endfunction
" ------------- }



" --------------------------------- MAPPINGS ------------------------------ {
"let mapleader = "\\"   "map leader backslash (for me rebinding CAPS LOCK to \)
let mapleader = " "     "map leader space


" ------- Normal mode map ------- 
"nnoremap <F1> :set autoread<CR>
"set pastetoggle=<F1> "no notice about mode (used func)
nnoremap <F1> :call MyTogglePasteMode()<CR>
nnoremap <F2> :au CursorMoved * checktime<CR>
nnoremap <F3> :q!<CR>
nmap <F4> :set syntax=log<CR>
nnoremap <F5> :call MyFoldMapping()<CR>
nmap <F6> :colorscheme desert<CR>
nmap <F7> :colorscheme xoria256<CR>
nmap <F8> :colorscheme noctu<CR>
nnoremap <silent> <F12> :set spell!<cr>

    "-- movement split windows ; ctrl+(up,down,left,right)
nnoremap <c-up> <c-w>k
nnoremap <c-down> <c-w>j
nnoremap <c-right> <c-w>l
nnoremap <c-left> <c-w>h
    "-- resizing split windows ; ctrl+(jk,l,l,h)
noremap <c-j> <c-w>+
noremap <c-k> <c-w>-
noremap <c-h> <c-w>>
"noremap <c-l> <c-w><    

nnoremap <C-x> :call MyToggleNumbers()<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-n> :exec &nu==&rnu? "set nornu!" : "set rnu!"<cr>
nnoremap <C-q> :exec &wrap ? "set nowrap" : "set wrap"<CR>
nnoremap <C-l> :exec &list ? "set nolist" : "set list"<CR>

nnoremap <M-x> "_dd
nnoremap <M-d> "_dd
nnoremap <M-X> "_D
nnoremap <M-D> "_D

nnoremap <ESC>q "qp
nnoremap <ESC>w "wp

nnoremap YY y$
    " restore previous buffer \"" AND save cutted to buffer "w
nnoremap ciw :<C-U>let save_nmapc = @"<CR>"wciw<Esc>:let @" = save_nmapc<CR>i
nnoremap ciW :<C-U>let save_nmapc = @"<CR>"wciW<Esc>:let @" = save_nmapc<CR>i
    "-- central searching
nnoremap n nzz
nnoremap N Nzz
    "-- escape in insert mode
nnoremap o o<esc>
nnoremap O O<esc>
    "-- don't save in register
nnoremap <silent> x "_x
nnoremap <silent> r "_r
    "-- highlight space
nmap <Leader><C-y> :highligh Spaces ctermbg=DarkGrey guibg=DarkGrey<CR>
nmap <Leader><C-u> :call matchadd('Spaces', '\s\+')<CR>
    "-- manage tabs
nnoremap <Leader>tc :tabnew<CR>         " open new tab
nnoremap <Leader>tk :tabclose<CR>       " close current tab
nnoremap <Leader>tn :tabn<CR>           " go to next tab
nnoremap <Leader>tp :tabp<CR>           " go to previous tab
nnoremap <Leader>tl :tabs<CR>           " tab lists
    "-- manage buffers
nnoremap <Leader>bc :new<CR>            " open new window
nnoremap <Leader>bk :bdelete<CR>        " close current buffer
nnoremap <Leader>bn :bn<CR>             " go to next buffer
nnoremap <Leader>bp :bp<CR>             " go to previous buffer    
nnoremap <Leader>bl :bp<CR>             " list buffer


" ------- Insert mode map -------
inoremap <silent> <F12> <C-O>:set spell!<cr>
    "-- atocomplete shortcut
inoremap <S-Tab> <C-n>
    "-- move row on Y axes
inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
    "-- move row on X axes
inoremap <ESC>. <C-o>>><ESC>i
inoremap <ESC>, <C-o><<<ESC>i


" ------- Visual mode map ------- 
    "перемещает выделенные строку/и вверх вниз (как в vsode)
    "применяется autoindent при перемещении (не понял как отклчить)
vnoremap <S-Down> :m '>+1<CR>gv=gv
vnoremap <S-Up> :m '<-2<CR>gv=gv
    "-- translate
vmap <C-t> <Leader>t
    "-- remove selected to black hole (don't save in register)
vnoremap <M-x> "_d

    "-- tabs and carriage return to the start
vnoremap <silent> > >gv
vnoremap <silent> < <gv
    " restore previous buffer \"" AND save cutted to buffer "q
vnoremap <silent> x :<C-U>let save_vmapx = @"<CR>gv"qx:let @" = save_vmapx<CR>
vnoremap <silent> X :<C-U>let save_vmapx = @"<CR>gv"qX:let @" = save_vmapx<CR>
    " restore previous buffer \"" AND save cutted to buffer "w
vnoremap <silent> c :<C-U>let save_vmapc = @"<CR>gv"wc<Esc>:let @" = save_vmapc<CR>a
vnoremap <silent> C :<C-U>let save_vmapc = @"<CR>gv"wC<Esc>:let @" = save_vmapc<CR>a

"vnoremap d "qd<Esc>
" clear buffer \""
"vnoremap y "qy:let @"=""<CR>


" ------- Command mode map ------- 
    " in cli mode use :ctrl+ww
cmap <C-w><C-w> %!sudo tee %
"cmap ww :w !sudo sh -c "cat > %"
    " in cli mode use :ctrl+nn
cmap <C-n><C-n> echo expand('%:p')
" ------------- }



" -------------------------------- Sets ------------------------------ {
set nocompatible                            " use all powerfull vim

"-- SEARCH 
set ignorecase                              " in search mode - ignore case word
set smartcase                               " in search mode - not ignore upperCase
set hlsearch                                " in search mode - highlight search word
set incsearch                               " use incremental search for show display result as you type each character  

"-- TAB/INDENT
set backspace=indent,eol,start              " use for remove indents, line breaks, symbols
set tabstop=4                               " use 4 spaces for indents(tabs)
set shiftwidth=4
set softtabstop=4
set expandtab                               " use spaces instead tab
set autoindent
set smartindent

set copyindent                              " copy the previous indentation on autoindenting (wan nocopyindent)
set wrap

"-- APPEARANCE
set number                                  " show numbers line
set relativenumber                          " show relative number
set showmatch                               " show paried brackets, quotos etc
set scrolloff=999                           " set so=999 - for use center cursor (режим печатной машинки)
                                            " for scrolling so=15 move 15 line numbers in end current window; 
"-- RU sets
set spelllang=en,ru
set keymap=russian-jcukenwin                " if enable russian layout use mapping key bindings
set iminsert=0                              " start insert mode in english layout
set imsearch=0                              " start search mode in english layout

"-- STATUS
set showcmd                                 " show command line
set showmode                                " show status mode
set ruler                                   " use show status line in down right panel

"-- Enable auto completion menu
set completeopt=menuone,noinsert,noselect
set infercase                               " ignore case in autocomplite
set wildmenu
set wildmode=list:longest                   " Make wildmenu behave like similar to Bash completion.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

"-- Backup edit files options
set undofile
set undodir=~/.vim/swap/undo/                   " keep undo files out of file dir
set directory=~/.vim/swap/swp/                  " keep unsaved changes away from file dir
set backupdir=~/.vim/swap/backup/               " backups also should not go to git
set writebackup
"set backupcopy=yes                             " disable create new inode file after saving edit (use same inode before editing)

"-- create notexist dirs (creating in exist directory not home)
"call MyEnsureDirExists("~/.vim/swap/undo/")
"call MyEnsureDirExists("~/.vim/swap/swp/")
"call MyEnsureDirExists("~/.vim/swap/backup/")

"-- MISC OTHER
scriptencoding utf-8
set encoding=utf-8
set nolist                                      " hide no readable character and spaces or tabulations
set listchars=eol:$,tab:»\ ,trail:·,extends:>,precedes:<,nbsp:␣
set history=10000                               " lines history saved
set timeoutlen=800
set noautochdir
set nomodeline secure


"-- cursor
"#set cursorline    "show highlight line cursor  
"#set cursorcolumn  "show highlight column cursor
hi CursorLine cterm=bold ctermbg=236
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

"-- color
set t_Co=256
set termguicolors

if has('mouse')
  set mouse=nv
endif
" ------------- }


if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"--------------------------------------- screen title
if &term =~ "screen"
    let &titlestring = "vim(" . expand("%:t") . ")"
    set notermguicolors
"  set t_ts=^[k
"  set t_fs=^[\
"  set title
endif
autocmd TabEnter,WinEnter,BufReadPost,FileReadPost,BufNewFile * let &titlestring = 'vim(' . expand("%:t") . ')'



" ============================== vim 8 ===============================
" set display=truncate

" if has("autocmd")
"   filetype plugin indent on
"  augroup vimStartup
"    au!
"    autocmd BufReadPost *
"      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
"      \ |   exe "normal! g`\""
"     \ | endif
"  augroup END
" endif " has("autocmd")

