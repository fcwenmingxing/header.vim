" Vim File
" AUTHOR:   Agapo (fpmarias@google.com)
" FILE:     /usr/share/vim/vim70/plugin/header.vim
" CREATED:  21:06:35 05/10/2004
" MODIFIED: 00:30:12 25/12/2008
" TITLE:    header.vim
" VERSION:  0.1.3
" SUMMARY:  When a new file is created a header is added on the top too.
"           If the file already exists, the pluging update the field 'date of
"           the last modification'.
" INSTALL:  Easy! Copy the file to vim's plugin directory (global or personal)
"           and run vim.


" FUNCTION:
" Detect filetype looking at its extension.
" VARIABLES:
" comment = Comment symbol associated with the filetype.
" type = Path to interpreter associated with file or a generic title
" when the file is not a script executable.

function s:filetype ()

  let s:file = expand("<afile>:t")
  if match (s:file, "\.sh$") != -1
    let s:comment = "#"
    let s:type = s:comment . "!" . system ("whereis -b bash | awk '{print $2}' | tr -d '\n'")
  elseif match (s:file, "\.py$") != -1
    let s:comment = "#"
    "modified by mingxingwen"
    "let s:type = s:comment . "!" . system ("whereis -b python | awk '{print $2}' | tr -d '\n'")
    let s:type = s:comment . "!" . "/usr/bin/env python"
  elseif match (s:file, "\.pl$") != -1
    let s:comment = "#"
    let s:type = s:comment . "!" . system ("whereis -b perl | awk '{print $2}' | tr -d '\n'")
  elseif match (s:file, "\.vim$") != -1
    let s:comment = "\""
    let s:type = s:comment . " Vim File"
  elseif match (s:file, "\.java$") != -1
    let s:comment = " *"
    let s:type = s:comment . " Java source file"
  elseif match (s:file, "\.c$") != -1
    let s:comment = " *"
    let s:type = s:comment . " C source file"
  elseif match (s:file, "\.h$") != -1
    let s:comment = " *"
    let s:type = s:comment . " C/C++ header file"
  elseif match (s:file, "\.cpp$") != -1
    let s:comment = " *"
    let s:type = s:comment . " C++ source file"
  elseif match (s:file, "\.cc$") != -1
    let s:comment = " *"
    let s:type = s:comment . " C/C++ source file"
  else
    let s:comment = "#"
    let s:type = s:comment . " Text File"
  endif
  unlet s:file

endfunction


" FUNCTION:
" Insert the header when we create a new file.
" VARIABLES:
" author = User who create the file.
" file = Path to the file.
" created = Date of the file creation.
" modified = Date of the last modification.

function s:insert ()

  call s:filetype ()

  if !exists('g:user_company')
      let g:user_company = 'your_company'
  endif
  if !exists('g:user_name')
      let g:user_name = 'your_name'
  endif
  if !exists('g:user_email')
      let g:user_email = 'your_email@host.com'
  endif
  let s:id = s:comment . " $id: " . expand("<afile>") . ",v 1.0.0 " . strftime("%Y/%m/%d %H:%M:%S") . " " . system ("id -un | tr -d '\n'") . " Exp $"
  let s:copyright = s:comment . " Copyright (C) " . strftime("%Y") . " " . g:user_company . ", " . g:user_name . " (" . g:user_email . ")."
  let s:modified = s:comment . " Last Modified: " . strftime ("%Y/%m/%d %H:%M:%S")

  call append (0, s:type)
  call append (1, s:comment)
  call append (2, s:id)
  call append (3, s:copyright)
  call append (4, s:comment)
  call append (5, s:modified)
  call append (6, "")

  if s:comment == " *"
    call append (0, "/*")
    call append (7, " */")
  endif
  "" vim:tw=78:sw=4:ts=8:ft=

  "" add header macro
  let s:filename = expand("<afile>")
  if match(s:filename, "\.h$") != -1
    "" hugarian notation
    let s:macro = s:filename

    let i = char2nr("A")
    while i < char2nr("Z")
        let s:macro = substitute(s:macro, nr2char(i), "_" . nr2char(i), "g")
        let i = i + 1
    endwhile

    let s:macro = substitute(s:macro, "\.h$", "_HEAD__", "")
    let s:macro = toupper(s:macro)
    if match (s:macro, "^_") != -1
        let s:macro = "_" . s:macro
    else
        let s:macro = "__" . s:macro
    endif
    call append (8, "#ifndef " . s:macro)
    call append (9, "#define " . s:macro)
    call append (10, "")
    call append (11, "")
    call append (12, "")
    call append (13, "")
    call append (14, "")
    call append (15, "")
    call append (16, "")
    call append (17, "")
    call append (18, "#endif /** " . s:macro . " */")
    call append (8, "")
    call cursor(13, 1)
  endif

  unlet s:comment
  unlet s:type
  unlet s:id
  unlet s:copyright
  unlet s:modified

endfunction


" FUNCTION:
" Update the date of last modification.
" Check the line number 5 looking for the pattern.

function s:update ()

  call s:filetype ()

  let s:pattern = s:comment . " Last Modified: [0-9/:]"

  if s:comment == " *"
    let s:ln = 7
  else
    let s:ln = 6
  endif
  
  let s:line = getline (s:ln)
  if match (s:line, s:pattern) != -1
    let s:modified = s:comment . " Last Modified: " . strftime ("%Y/%m/%d %H:%M:%S")
    call setline (s:ln, s:modified)
    unlet s:modified
  endif
  
  unlet s:comment
  unlet s:pattern
  unlet s:ln
  unlet s:line

endfunction


autocmd BufNewFile * call s:insert ()
autocmd BufWritePre * call s:update ()
