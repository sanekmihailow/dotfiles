" Syntax file
" Language:         Generic log files
" Maintainer:       Alex Dzyoba <avd@reduct.ru>
" Latest Revision:  2013-03-08
" Changes:          2013-03-08 Initial version

" Based on messages.vim - syntax file for highlighting kernel messages

if exists("b:current_syntax")
  finish
endif

syn match log_error 	'\c\<\(FATAL\|ERROR\|ERRORS\|FAIL\|FAILED\|FAILURE\|EMERG\|ALERT\).*'
syn match log_warning 	'\c\<\(WARNING\|DELETE\|DELETING\|DELETED\|RETRY\|RETRYING\|WARN\).*'
syn match log_notice 	'\c\<\(NOTICE\|INFO\|DEBUG\).'
syn match log_comment	'\c\#.*$'

syn region log_string 	start=/'/ end=/'/ end=/$/ skip=/\\./
syn region log_string 	start=/"/ end=/"/ skip=/\\./
syn match log_number 	'0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'


syn match   log_date '\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [ 0-9]\d *'
syn match   log_date '\d\{4}-\d\d-\d\d'

syn match   log_time '\d\d:\d\d:\d\d\s*'
syn match   log_time '\c\d\d:\d\d:\d\d\(\.\d\+\)\=\([+-]\d\d:\d\d\|Z\)'

hi link log_string 		String
hi link log_number 		Number
hi link log_date 		Constant
hi link log_time 		Type
hi link log_error 		ErrorMsg
hi link	log_warning 		WarningMsg
hi link log_notice		Type 
hi link log_comment		Comment

let b:current_syntax = "log"
