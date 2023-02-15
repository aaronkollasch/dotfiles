" Vim syntax file
"
" Language:     OpenSSH known_hosts (known_hosts)
" Author:       Camille Moncelier <moncelier@devlife.org>
" Author:       Aaron Kollasch <aaron@kollasch.dev>
" Copyright:    Copyright (C) 2010 Camille Moncelier <moncelier@devlife.org>
" Copyright:    Modified work Copyright (C) 2023 Aaron Kollasch <aaron@kollasch.dev>
" Licence:      You may redistribute this under the same terms as Vim itself
" URL:          https://github.com/aaronkollasch/vim-known_hosts
"
" This sets up the syntax highlighting for known_host file

" Setup
if version >= 600
    if exists("b:current_syntax")
        finish
    endif
else
    syntax clear
endif

if version >= 600
    setlocal iskeyword=_,-,a-z,A-Z,48-57,@-@
    setlocal commentstring=#\ %s
else
    set iskeyword=_,-,a-z,A-Z,48-57,@-@
    set commentstring=#\ %s
endif

syn case ignore

let s:ipv4Pat   = "\\%(\\%(25[0-5?]\\|2[0-4?][0-9?]\\|[01?]\\?[0-9?]\\?[0-9?]\\|\\*\\)\\.\\)\\{3\\}\\%(25\\_[0-5?]\\|2[0-4?]\\_[0-9?]\\|[01?]\\?[0-9?]\\?\\_[0-9?]\\|\\*\\)"
let s:ipv6Pat   = "\\%([a-fA-F0-9*?]*:\\)\\{2,7}[a-fA-F0-9*?]\\+"
let s:domainPat = "-\\@![A-Za-z0-9-*?]\\+\\%([\\-\\.]\\{1}[a-z0-9*?]\\+\\)*\\.\\%(\\*\\|[A-Za-z]\\{2,6}\\)"
let s:portPat   = "\\d\\+"
let s:hostPat   = "!\\?\\(" . s:domainPat . "\\|" . s:ipv4Pat . "\\|" . s:ipv6Pat . "\\|\\*\\)"
let s:hostPortPat = "\\[" . s:hostPat . "\\]:" . s:portPat
let s:anyHostPat = "\\%(" . s:hostPat . "\\|" . s:hostPortPat . "\\)"
let s:hostPortPat = "/" . s:hostPortPat . "/"
let s:anyHostPat = "/" . s:anyHostPat . "/"
let s:hostPat = "/" . s:hostPat . "/"
let s:ipv4Pat = "/" . s:ipv4Pat . "/"
let s:ipv6Pat = "/" . s:ipv6Pat . "/"
let s:portPat = "/" . s:portPat . "/"

" Match comments and bad lines
syn match   knownHostsComment ".*$"
syn match   knownHostsBadLine "^.*$"
syn match   knownHostsComment "#.*$"

" Match a line
syn match   knownHostsLine    "^#\@!\(@[^ ]\+\s\+\)\?[^ @][^ ]*\s\+[^ ]\+\s\+[^ ]\+" transparent contains=knownHostsBadType,knownHostsKey nextgroup=knownHostsComment
syn match   knownHostsKey     contained "[^ ]\+" keepend
syn keyword knownHostsKeytype contained nextgroup=knownHostsKey ssh-rsa ssh-dsa ssh-dss ecdsa-sha2-nistp256 ecdsa-sha2-nistp384 ecdsa-sha2-nistp521 ssh-ed25519
syn match   knownHostsWild    contained "[*?!]"
syn match   knownHostsBadType contained "^\(@[^ ]\+\s\+\)\?[^ @][^ ]*\s\+[^ ]\+" contains=knownHostsAllHost,knownHostsKeytype,knownHostsBadMark
syn match   knownHostsBadHost contained "[^ ,]\+" contains=knownHostsHost
syn match   knownHostsBadMark contained "^@[^ ]\+" contains=knownHostsMarker
syn match   knownHostsAllHost contained "^\(@[^ ]\+\s\+\)\?[^ @][^ ]*\s\+" contains=knownHostsBadMark,knownHostsBadHost,knownHostsMarker
autocmd Syntax * exe "syn match   knownHostsHost    contained" s:anyHostPat "contains=knownHostsGroup,knownHostsDomain"
autocmd Syntax * exe "syn match   knownHostsGroup   contained" s:hostPortPat  "contains=knownHostsBracket,knownHostsPort keepend"
autocmd Syntax * exe "syn match   knownHostsPort    contained" s:portPat      "keepend contains=knownHostsWild"
autocmd Syntax * exe "syn match   knownHostsIPv4    contained" s:ipv4Pat      "contains=knownHostsWild"
autocmd Syntax * exe "syn match   knownHostsIPv6    contained" s:ipv6Pat      "contains=knownHostsWild"
autocmd Syntax * exe "syn match   knownHostsDomain  contained" s:hostPat      "keepend contains=knownHostsWild,knownHostsIPv4,knownHostsIPv6"
syn region  knownHostsBracket contained start="\[" end="\]" contains=knownHostsDomain keepend transparent
syn keyword knownHostsMarker  contained @cert-authority @revoked

" Match a line with hashed hostname
syn match   knownHostsLine    "^#\@!\(@[^ ]\+\s\+\)\?|[^ ]*\s\+[^ ]\+\s\+[^ ]\+" transparent contains=knownHostsBadType,knownHostsKey nextgroup=knownHostsComment
syn match   knownHostsBadType contained "^\(@[^ ]\+\s\+\)\?|[^ ]*\s\+[^ ]\+" contains=knownHostsBadMark,knownHostsHash,knownHostsKeytype
syn match   knownHostsHash    contained "\s\?|[^ ]\+\s\+" keepend contains=knownHostsHashMag,knownHostsHashSep
syn match   knownHostsHashSep contained "|" keepend
syn match   knownHostsHashMag contained "|\d\+|" keepend contains=knownHostsHashSep

" Define the default highlighting
if version >= 508 || !exists("did_known_hosts_syntax_inits")
    if version < 508
        let did_sshconfig_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink knownHostsKeytype Keyword
    HiLink knownHostsAllHost Delimiter
    HiLink knownHostsHost    Delimiter
    HiLink knownHostsGroup   Delimiter
    HiLink knownHostsHash    Identifier
    HiLink knownHostsHashSep Delimiter
    HiLink knownHostsHashMag Number
    HiLink knownHostsDomain  Identifier
    HiLink knownHostsBadMark Error
    HiLink knownHostsBadHost Error
    HiLink knownHostsBadLine Error
    HiLink knownHostsBadType Error
    HiLink knownHostsMarker  Keyword
    HiLink knownHostsPort    Number
    HiLink knownHostsIPv4    Constant
    HiLink knownHostsIPv6    Constant
    HiLink knownHostsKey     String
    HiLink knownHostsWild    Operator
    HiLink knownHostsComment Comment

    delcommand HiLink
endif

let b:current_syntax = "known_hosts"
