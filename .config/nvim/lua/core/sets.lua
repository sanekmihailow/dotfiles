-- ~/.config/nvim/lua/core/sets.lua
local opt = vim.opt
local cmd = vim.cmd
local fs = vim.fs

opt.compatible = false

-- SEARCH 
opt.ignorecase = true                              -- in search mode - ignore case word
opt.smartcase = true                               -- in search mode - not ignore upperCase
opt.hlsearch = true                                -- in search mode - higlight search word
opt.incsearch = true                               -- use incremental search for show display result as you type each character  


-- TAB/INDENT
opt.backspace = "indent,eol,start"                 -- use for remove indents, line breaks, symbols
opt.tabstop = 4                                    -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4                                 -- 4 spaces for indent width
opt.softtabstop = 4                                -- 4 spaces for 
opt.expandtab = true                               -- expand tab to spaces
opt.autoindent = true                              -- copy indent from current line when starting new one
opt.smartindent = true                             -- copy indent from current line when starting new one
opt.copyindent = true                              -- copy the previous indentation on autoindenting (wan nocpyindent)
opt.wrap = true


-- APPEARANCE
opt.number = true                                  -- show numbers line
opt.relativenumber = true                          -- show relative number
opt.showmatch = true                               -- show paried brackets, quotos etc
opt.scrolloff = 999                                -- set so=999 - for use center cursor (режим печатной машинки)


-- RU sets
opt.spelllang = { "en_us", "ru" }
cmd("set keymap=russian-jcukenwin")
cmd("set iminsert=0")                              -- start insert mode in english layout
cmd("set imsearch=0")                              -- start search mode in english layout


-- STATUS
opt.showcmd = true                                 -- show commandline
opt.showmode = true                                -- show status mode
opt.ruler = true                                   -- use show status line in down right panel


-- Enable auto completion menu
opt.completeopt = 'menuone,noinsert,noselect'
opt.infercase = true                               -- ignore case in autocomplite
opt.wildmenu = true
opt.wildmode = 'list:longest'                      -- Make wildmenu behave like similar to Bash completion.
opt.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'


-- cursor
--#opt.cursorline = true                           -- highlight the current cursor line
--#opt.cursorcolumn = true
cmd('hi CursorLine cterm=bold ctermbg=236')


-- color
opt.termguicolors = true


-- backup
opt.undofile = true                                  -- create .un~ file tghat save all undo history (even if you exit the editor)
    -- # https://github.com/neovim/neovim/issues/15720
opt.undodir =   fs.normalize('~/.nvim/swap/undo/')   --  keep undo files out of file dir
opt.directory = fs.normalize('~/.nvim/swap/swp/')    --  keep unsaved changes away from file dir
opt.backupdir = fs.normalize('~/.nvim/swap/backup/') --  backups also should not go to git
opt.writebackup = true                               --  keep unsaved changes away from file dir
--opt.backupcopy = "yes"                             --  disable create new inode file after saving edit (use same inode before editing)


-- MISC OTHER
opt.encoding = 'utf-8'
opt.list = false                                   -- hide noreadable character and spaces or tabulations
opt.listchars = { eol = '$', tab = '» ', trail = '·', extends = '→', precedes = '←', nbsp = '␣' }
opt.history = 10000                                -- lines history saved
opt.timeoutlen = 800
opt.autochdir = false
opt.modeline = false
opt.secure = true
opt.splitright = true                              -- vertical split вправо
opt.splitbelow = true                              -- horizontal split вниз
--opt.clipboard:append("unnamedplus") 
opt.mouse = 'nv'
opt.helplang=en

-- Screen title
if string.match(vim.env.TERM or "", "screen") then
    opt.titlestring = "vim(" .. vim.fn.expand("%:t") .. ")"
    opt.termguicolors = false
    cmd("set t_Co=256")
end
