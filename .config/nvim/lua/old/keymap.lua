-- ~/.config/nvim/lua/old/keymap.lua
-- for neovim <= 0.7 --

vim.g.mapleader = "\\"
local keymap = vim.api.nvim_set_keymap



-------------------- NORMAL MODE map ---------------------
vim.o.pastetoggle='<F1>'
--keymap("n", "<F1>", ":set autoread<CR>", { noremap = true })
keymap("n", "<F2>", ":au CursorMoved * checktime<CR>", { noremap = true })
keymap("n", "<F3>", ":q!<CR>", { noremap = true })
keymap('n', '<F5>', ':lua req_func.my_fold_mapping()<CR>', { noremap = true })
keymap("n", "<F12>", ":set spell!<CR>", { noremap = true })
    -- navigate windows
keymap("n", "<C-up>", "<C-w>k", { noremap = true, silent = true })
keymap("n", "<C-down>", "<C-w>j", { noremap = true, silent = true })
keymap("n", "<C-right>", "<C-w>l", { noremap = true, silent = true })
keymap("n", "<C-left>", "<C-w>h", { noremap = true, silent = true })
    --resizing split windows
keymap("n", "<C-j>", "<C-w>+", { noremap = true, silent = true })
keymap("n", "<C-k>", "<C-w>-", { noremap = true, silent = true })
keymap("n", "<C-h>", "<C-w><", { noremap = true, silent = true })
keymap("n", "<C-l>", "<C-w>>", { noremap = true, silent = true })

keymap('n', '<C-x>', ':lua req_func.my_toggle_line_numbers()<CR>', { noremap = true, silent = true })
    --keymap('n', '<C-x>', ':lua require("core.functions").toggle_line_numbers()<CR>', { noremap = true}) 
    -- use it withoiut global variable req_func
keymap('n', '<C-s>', '"sy', { noremap = true, silent = true })
keymap('n', '<C-p>', '"sp', { noremap = true, silent = true })
keymap('n', '<C-n>', [[:exec &nu==&rnu? "set nornu!" : "set rnu!"<CR>]], { noremap = true, silent = true })

keymap('n', '<M-x>', '"_dd', { noremap = true, silent = true })
keymap('n', '<M-z>', '"_D', { noremap = true, silent = true })

keymap("n", "YY", "y$", { noremap = true })
keymap("n", "x", '"_x', { noremap = true, silent = true })
keymap("n", "r", '"_r', { noremap = true, silent = true })
    -- central searching
keymap("n", "n", "nzz", { noremap = true, silent = true })
keymap("n", "N", "Nzz", { noremap = true, silent = true })
    -- escape in insert mode
keymap("n", "o", "o<Esc>", { noremap = true, silent = true })
keymap("n", "O", "O<Esc>", { noremap = true, silent = true })
    -- manage tabs
keymap("n", "<Leader>to", ":tabnew<CR>", { noremap = true, silent = true })    -- open new tab
keymap("n", "<Leader>tx", ":tabclose<CR>", { noremap = true, silent = true })  -- close current tab
keymap("n", "<Leader>tn", ":tabn<CR>", { noremap = true, silent = true })      --  go to next tab
keymap("n", "<Leader>tp", ":tabp<CR>", { noremap = true, silent = true })      --  go to previous tab
keymap("n", "<Leader>tl", ":tabs<CR>", { noremap = true, silent = true })      --  tab lists
    --age buffers
keymap("n", "<Leader>bo", ":new<CR>", { noremap = true, silent = true })       -- open new tab (analog <C-w>s)
keymap("n", "<Leader>bd", ":bdelete<CR>", { noremap = true, silent = true })   -- close current tab
keymap("n", "<Leader>bn", ":bn<CR>", { noremap = true, silent = true })        --  go to next tab
keymap("n", "<Leader>bp", ":bp<CR>", { noremap = true, silent = true })        --  go to previous tab
keymap("n", "<Leader>bl", ":buffers<CR>", { noremap = true, silent = true })   --  list buffer


--------------------- INSERT MODE map --------------------- 
keymap('i', '<F12>', ':set spell!<CR>', { noremap = true, silent = true })
    --atocomplete shortcut
keymap('i', '<S-Tab>', '<C-n>', { noremap = true, silent = true })
keymap("n", "<C-l>", "<C-w><", { noremap = true, silent = true })
    -- move line
keymap("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi", { noremap = true, silent = true })
keymap("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi", { noremap = true, silent = true })



--------------------- VISUAL MODE map ----------------------------   
    --перемещает выделенные строку/и вверх вниз (как в vsode)
    --применяется autoindent при перемещении (не понял как отклчить)
keymap("v", "<S-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap("v", "<S-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
    --translate
keymap("v", "<C-t>", "<Leader>t", { noremap = true, silent = true })  


--------------------- COMMAND MODE map ----------------------------    
    --in cli mode use :ctrl+ww
keymap('c', '<C-w><C-w>', [[<C-\>e "sudo tee " .. vim.fn.expand('%') .. " >/dev/null"<CR>]], { noremap = true, silent = true })
    --in cli mode use :ctrl+nn
keymap('c', '<C-n><C-n>', [[<C-\>e "echo expand('%:p')"<CR>]], { noremap = true, silent = true })
