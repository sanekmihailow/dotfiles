-- file typing

local autocmd = vim.api.nvim_create_autocmd

autocmd({"FileType"}, {
    pattern = {"yaml", "yml"},
    callback = function()
        -- Устанавливаем параметры для этих типов файлов
        vim.opt_local.expandtab = true
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.autoindent = true
        vim.opt_local.foldmethod = 'indent'
        vim.opt_local.foldenable = false
        -- Выполняем команду zR для раскрытия всех фолдов
        vim.cmd('normal! zR')
    end
})

-- Syntax typing
autocmd("BufRead", {
    pattern = {"*nginx/*.log*", "*nginx/*_log*"},
    command = "setfiletype nginx",
})

autocmd("BufRead", {
    pattern = {"*apache2/*.log*", "*apache2/*_log*", "*apache2/*access*", "*httpd/*.log*", "*httpd/*_log*", "*httpd/*access*"},
    command = "setfiletype httplog",
})

autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*asterisk/*voicemail.conf*",
    command = "setfiletype asteriskvm",
})

autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*asterisk/*.conf*", "*asterisk/*.ael*"}, 
    command = "setfiletype asterisk",
})

autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.log*",
    command = "setfiletype log",
})
