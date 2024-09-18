-- yaml typping
vim.cmd([[
    augroup MyFileTypingYaml
        autocmd!
        autocmd FileType yaml,yml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent foldmethod=indent nofoldenable | normal! zR
    augroup END
]])

-- syntax typing
vim.cmd([[
    augroup MyFileTypingSyntax
        autocmd!
        autocmd BufRead *nginx/*.log*, *nginx/*_log*, *nginx/*access* setf nginx
        autocmd BufRead *apache2/*.log*, *apache2/*access*, *apache2/*_log*, *httpd/*.log*, *httpd/*_log* setf httplog

        autocmd BufNewFile,BufRead *asterisk*/*voicemail.conf* setf asteriskvm
        autocmd BufNewFile,BufRead *asterisk/*.conf* setf asterisk
        autocmd BufNewFile,BufRead *asterisk/*.ael* setf asterisk

        autocmd BufNewFile,BufRead *.log* setf log
    augroup END
]])
