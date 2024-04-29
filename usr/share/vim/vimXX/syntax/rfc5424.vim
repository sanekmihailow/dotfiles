" $Id: rfc5424.vim,v 0.1.1 2015/03/31 Kyan Exp $
" Vim syntax file
" Language:     RFC5424 syslog log file
" Maintainer:   Kyan He <kyan.ql.he@gmail.com>
" Last Change:  $Date: 2015/03/31 00:01:07 $
" Remark:

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match   syslogMsg ".*$"
syn region  syslogSdParam start="\"" end="\"" fold skipwhite
syn match   equalSign "=" nextgroup=syslogSdParam contained
syn match   syslogSdName "[a-zA-Z0-9]\+" nextgroup=equalSign
syn match   syslogSdId "[a-zA-Z0-9]\+"
syn region  syslogSdElement start="\[" end="\]" fold transparent contains=syslogSdName,equalSign,syslogSdParam,syslogSdId nextgroup=syslogSdElement
syn match   syslogMsgid "[^ ]\+" nextgroup=syslogSdElement skipwhite
syn match   syslogProcid "[^ ]\+" nextgroup=syslogMsgid skipwhite
syn match   syslogAppName "[^ ]\+" nextgroup=syslogProcid skipwhite
syn match   syslogHostname "[^ ]\+" nextgroup=syslogAppName skipwhite
syn match   syslogTimestamp "\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\(\.\d\{1,6\}\)\?\(Z\|\(-\|+\)\d\d:\d\d\)" skipwhite nextgroup=syslogHostname
syn match   syslogVersion "\d " nextgroup=syslogTimestamp
syn match   syslogPriority "^<\d\{1,3}>" nextgroup=syslogVersion

if !exists("did_syslog_syntax_inits")
  let did_syslog_syntax_inits = 1
  hi link syslogPriority    Statement
  hi link syslogVersion     String
  hi link syslogTimestamp   Comment
  hi link syslogHostname    Identifier
  hi link syslogAppName     Comment
  hi link syslogProcid      Statement
  hi link syslogMsgid       Type
  hi link syslogSdId        Structure
  hi link syslogSdName      Identifier
  hi link syslogSdParam     String
  hi link equalSign         Comment
  hi link syslogMsg         Comment
endif

let b:current_syntax="syslog"
