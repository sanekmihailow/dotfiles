-- file typing
vim.api.nvim_create_autocmd({"FileType"}, {
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
