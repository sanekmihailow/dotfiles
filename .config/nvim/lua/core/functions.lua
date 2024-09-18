-- ~/.config/nvim/lua/core/functions.lua
local fn = vim.fn

local M = {}

M.my_toggle_line_numbers = function()
  if vim.o.number == true then
    vim.o.number = false
    vim.o.relativenumber = false
  else
    vim.o.number = true
    vim.o.relativenumber = true
  end
end

M.my_fold_mapping = function()
    local openers = { ['('] = ')', ['['] = ']', ['{'] = '}', ['<'] = '>' }
    local closers = { [')'] = '(', [']'] = '[', ['}'] = '{', ['>'] = '<' }
    local current_line_number = fn.line('.')
    local current_line = fn.getline(current_line_number)
    local foldmethod = vim.wo.foldmethod
    -- Check that exist specific symbols on current line
    local current_char = string.match(current_line, '[%(%)%[%]%{%}<>]')
    
    if foldmethod == 'indent' then
        vim.cmd("normal! za")
    else
        if current_char then
            if openers[current_char] then
                local find_opener = true
                --vim.cmd('echo "Current char (' .. current_char .. ') is not a closer"') -- #C- debug message
                vim.cmd("normal! zfa" .. current_char)
            elseif closers[current_char] then
                local find_opener = false
                --vim.cmd('echo "Current char: ' .. current_char .. '"')
                vim.cmd("normal! zfa" .. closers[current_char])
            end
            return -- nothing to do
        end

        -- find for the nearest closing/opening brackets
        local bracket = nil
        local bracket_line_number = nil
        for line_number = current_line_number - 1, 1, -1 do
            local line = fn.getline(line_number)
            bracket = string.match(line, '[>%)%]%}<%(%[%{]')
            if bracket then
                bracket_line_number = line_number
                break
            end
        end

        if not bracket then
            --vim.cmd('echo "not found bracket"')
            return
        end
        
        -- Search opener or closer bracket
        if openers[bracket] then
            local closer = openers[bracket]
            local stack = 0
            local start_line = bracket_line_number
            local end_line = fn.line('$')
            local step = 1
            for line_number = start_line, end_line, step do
                local line = fn.getline(line_number)
                    for char in string.gmatch(line, '.') do
                    if char == bracket then
                        stack = stack + 1
                    elseif char == closer then
                        stack = stack - 1
                        if stack == 0 then
                            fn.cursor(line_number, 1)
                            vim.cmd("normal! zf" .. bracket_line_number .. "gg")
                            return
                        end
                    end
                end
            end
        elseif closers[bracket] then
            local opener = closers[bracket]
            local stack = 1
            local start_line = bracket_line_number - 1
            local end_line = 1
            local step = -1
            for line_number = start_line, end_line, step do
                local line = fn.getline(line_number)
                for char in string.gmatch(line, '.') do
                    if char == bracket then
                        stack = stack + 1
                    elseif char == opener then
                        stack = stack - 1
                        if stack == 0 then
                            fn.cursor(line_number, 1)
                            vim.cmd("normal! zf" .. bracket_line_number .. "G")
                            return
                        end
                    end
                end
            end
        end
    end        
end



return M
