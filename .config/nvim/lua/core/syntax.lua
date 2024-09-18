-- Syntax typing
vim.api.nvim_create_autocmd("BufRead", {
    pattern = {"*nginx/*.log*", "*nginx/*_log*"},
    command = "setfiletype nginx",
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = {"*apache2/*.log*", "*apache2/*_log*", "*apache2/*access*", "*httpd/*.log*", "*httpd/*_log*", "*httpd/*access*"},
    command = "setfiletype httplog",
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*asterisk/*voicemail.conf*",
    command = "setfiletype asteriskvm",
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*asterisk/*.conf*", "*asterisk/*.ael*"}, 
    command = "setfiletype asterisk",
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.log*",
    command = "setfiletype log",
})
