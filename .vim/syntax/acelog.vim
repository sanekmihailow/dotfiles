" Vim syntax file
" Language:         ACE log file
" Maintainer:       Like Ma <likemartinma@gmail.com>
" Latest Revision:  2019-03-17

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" ALL: "grey",
" TRACE: "blue",
" DEBUG: "cyan",
" INFO: "green",
" WARN: "yellow",
" ERROR: "red",
" FATAL: "magenta",
" OFF: "grey"

syn match   messagesBegin       display '^' nextgroup=timestamp

syn match   timestamp           contained display '\d\{4}-\d\d-\d\d\s\+\d\d:\d\d:\d\d[\.,]\d\+'
                                \ nextgroup=hostPID

syn match   hostPID             contained display '@[^@]\+@\d\+@'
                                \ nextgroup=traceHdr,debugHdr,infoHdr,warnHdr,errorHdr,fatalHdr

syn match   traceHdr            contained display 'LM_\(TRACE\|SHUTDOWN\|STARTUP\)'
                                \ nextgroup=messagesText

syn match   debugHdr            contained display 'LM_DEBUG'
                                \ nextgroup=messagesText

syn match   infoHdr             contained display 'LM_INFO'
                                \ nextgroup=messagesText

syn match   warnHdr             contained display 'LM_\(NOTICE\|WARNING\)'
                                \ nextgroup=messagesText

syn match   errorHdr            contained display 'LM_ERROR'
                                \ nextgroup=messagesText

syn match   fatalHdr            contained display 'LM_\(CRITICAL\|ALERT\|EMERGENCY\)'
                                \ nextgroup=messagesText

syn match   messagesPID         contained display '\[\zs\d\+\ze\]'

syn match   messagesIP          '\d\+\.\d\+\.\d\+\.\d\+'

syn match   messagesURL         '\w\+://\S\+'

syn match   messagesText        contained display '.*'
                                \ contains=messagesNumber,messagesIP,messagesURL

syn match   messagesNumber      contained '0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'


hi def link timestamp            Type
hi def link messagesPID         Constant
hi def link messagesIP          Constant
hi def link messagesURL         Underlined
hi def link messagesNumber      Number
hi def link messagesText        Normal

if &background == "dark"
  hi def traceHdr term=bold cterm=NONE ctermfg=Blue ctermbg=NONE gui=NONE guifg=Blue guibg=NONE
  hi def debugHdr term=bold cterm=NONE ctermfg=Cyan ctermbg=NONE gui=NONE guifg=Cyan guibg=NONE
  hi def infoHdr term=bold cterm=NONE ctermfg=Green ctermbg=NONE gui=NONE guifg=Green guibg=NONE
  hi def warnHdr term=bold cterm=NONE ctermfg=Yellow ctermbg=NONE gui=NONE guifg=Yellow guibg=NONE
  hi def errorHdr term=bold cterm=NONE ctermfg=Red ctermbg=NONE gui=NONE guifg=Red guibg=NONE
  hi def fatalHdr term=bold cterm=NONE ctermfg=magenta ctermbg=NONE gui=NONE guifg=Magenta guibg=NONE
else
  hi def traceHdr term=bold cterm=NONE ctermfg=DarkBlue ctermbg=NONE gui=NONE guifg=DarkBlue guibg=NONE
  hi def debugHdr term=bold cterm=NONE ctermfg=DarkCyan ctermbg=NONE gui=NONE guifg=DarkCyan guibg=NONE
  hi def infoHdr term=bold cterm=none ctermfg=darkgreen ctermbg=none gui=none guifg=darkgreen guibg=none
  hi def warnHdr term=bold cterm=NONE ctermfg=DarkYellow ctermbg=NONE gui=NONE guifg=DarkYellow guibg=NONE
  hi def errorHdr term=bold cterm=NONE ctermfg=DarkRed ctermbg=NONE gui=NONE guifg=DarkRed guibg=NONE
  hi def fatalHdr term=bold cterm=NONE ctermfg=Darkmagenta ctermbg=NONE gui=NONE guifg=DarkMagenta guibg=NONE
endif

let b:current_syntax = "acelog"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: set ts=2 sw=2 sts=2 et:
