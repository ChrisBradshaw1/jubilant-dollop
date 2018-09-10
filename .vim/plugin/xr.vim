if !exists("g:XRWscopePath")
    " Path to wscope.py.
    let g:XRWscopePath = "/nobackup/maearl/helper-scripts/wscope-non-interactive/src/wscope.py"
endif

if !exists("g:XRWscopeCSProg")
    " Cscope program to use for Wscope pre-built databases.
    let g:XRWscopeCSProg = "/usr/bin/cscope"
endif

function! BaseName(fullpath)
  let basename = system("basename " . a:fullpath)
  let basename = substitute(basename, "\n", "", "")
  return basename
endfunction

function! DirName(fullpath)
  return fnamemodify(a:fullpath, ':h')
endfunction

function! GotoJamfile()
  let fullpath = getreg("%")
  let dir = DirName(fullpath)
  let basename = BaseName(fullpath)
  let jamfile = dir . "/Jamfile"
  if !filereadable(jamfile)
    echoerr jamfile . " cannot be read"
  else
    exe "edit " . jamfile
    call setreg("/", "\\<" . basename . "\\>")
    normal n
  endif
endfunction

function! AbsPath(path)
  if strpart(a:path, 0, 1) == "/"
    return simplify(a:path)
  else
    return simplify(getcwd() . "/" . a:path)
  endif
endfunction

" Return a parent directory of the current bufer that contains the given file.
" Return 0 if the given file is not found.
function! GetParentFileDir(parentFile)
  let path = AbsPath(DirName(getreg("%")))

  while path != "/" && !filereadable(path . "/" . a:parentFile)
    let path = DirName(path)
  endwhile

  if filereadable(path . "/" . a:parentFile)
    return path
  else
    return 0
    echoerr "Could not find " . a:parentFile . " in parent directories."
  endif
endfunction

function! GotoParentFile(parentFile)
  let path = GetParentFileDir(parentFile)

  if path != 0
    exe "edit " . path . "/" . a:parentFile
  else
    echoerr "Could not find " . a:parentFile . " in parent directories."
  endif
endfunction

" Return the workspace root based on the current working directory
function! GetWorkspaceRoot()
    let path = AbsPath(getcwd())
    let out = -1

    while path != "/" && !isdirectory(path . "/" . '.ACMEROOT')
        let path = DirName(path)
    endwhile

    if isdirectory(path . "/" . '.ACMEROOT')
        let out = path
    endif

    return out
endfunction

function! DiffIndexLine()
    return search("^Index: ", 'bncW')
endfunction

" Return the component root based on the current buffer, or 0 if the current
" buffer is not in a component.
function! GetComponentRoot()
    return GetParentFileDir('comp-mdata.pl')
endfunction

" Return the name of the file current being looked at in a diff
function! DiffIndex()
    let idxlineno = DiffIndexLine()
    if idxlineno == 0
        echoerr "Not in a diff file"
        return -1
    endif

    if idxlineno > line(".")
        echoerr "Invalid cursor position"
        return -1
    endif

    return substitute(getline(idxlineno), "^Index: ", "", "")
endfunction

" Return the line number currently being looked at in a diff
function! DiffLine()
    let lineno = search('^\(---\|\*\*\*\) [0-9]\+', 'bnc', DiffIndexLine())
    if lineno == 0
        echoerr "Not in a diff file"
        return -1
    endif

    if lineno > line(".")
        echoerr "Invalid cursor position"
        return -1
    endif

    let dstline = substitute(getline(lineno), '^\(---\|\*\*\*\) \([0-9]\+\),.*$', '\2', '')
    if match(dstline, '^[0-9]\+$') == -1
        echoerr "Not in a diff file"
        return -1
    endif

    return dstline
endfunction

" When looking at a diff jump to the line corresponding with the cursor
" position in the current workspace.
function! DiffToFile()
    let filename = DiffIndex()
    let dstline = DiffLine()

    if filename == -1 || dstline == -1
        return
    endif

    let wsroot = GetWorkspaceRoot()
    if wsroot == -1
        echoerr "Not in a workspace"
        return
    endif

    exe "edit" . wsroot . "/" . filename
    call cursor(dstline, 0)
endfunction

" Switch to vimdiff mode when viewing a diff.
function! DiffPatch()
    let filtereddiff = tempname() 

    " Write the current file's part of the diff to a temporary file
    let start_line = DiffIndexLine()
    if start_line == 0
        echoerr "Not in a diff file"
        return -1
    endif

    let end_line = search("^$", 'ncW')
    if end_line == 0
        let end_line = line("$")
    endif

    silent execute "" . start_line . "," . end_line . "w " . filtereddiff

    " Open the (unpatched) file in the workspace, at the right position.
    call DiffToFile()

    " Use vim's diffpatch feature on the filtered diff.
    execute "vertical diffpatch " . filtereddiff
endfunction

" Run acme diff on the current file and split the view accordingly.
function! AcmeDiff()
    let diff = tempname()

    " Grab the diff
    call system("acme diff " . getreg("%") . " > " . diff)

    " Set patchexpr to reverse the patch out
    let old_patchexpr = &patchexpr
    set patchexpr=ReversePatch()
    function! ReversePatch()
       :call system("patch --reverse -o " . v:fname_out . " " . v:fname_in .
       \  " < " . v:fname_diff)
    endfunction

    " Use diffpatch on the diff
    execute "vertical diffpatch " . diff

    " Restore the old patchexpr
    let &patchexpr = old_patchexpr
endfunction

function! MergeComponentLine()
    return search("^[^ ].*component: ", 'bnc')
endfunction

function! MergeComponent()
    let compline = MergeComponentLine()

    if compline == 0
        echoerr "Not in a merge log"
        return -1
    endif

    if compline > line(".")
        echoerr "Invalid cursor position"
        return -1
    endif

    return substitute(getline(compline), "^[^ ].*component: \\([^@]*\\)@.*$", "\\1", "")
endfunction


function! MergeFile()
    if match(getline(line(".")), "^  [A-Z] \\([^ ]*\\)\\( .*\\)\\?$") == -1
        echoerr "Invalid cursor position"
        return -1
    endif

    return substitute(getline(line(".")), "^  [A-Z] \\([^ ]*\\)\\( .*\\)\\?$", "\\1", "")
endfunction

" When looking at an update log or a merge log, jump to the file currently
" under the cursor.
function! MergeToFile()
    let comp = MergeComponent()
    let file = MergeFile()

    if comp == -1 || file == -1
        return
    endif

    let wsroot = GetWorkspaceRoot()
    if wsroot == -1
        echoerr "Not in a workspace"
        return
    endif

    exe "edit" . wsroot . "/" . comp . "/" . file

    call setreg("/", "^=======$")
    normal n
endfunction

" When looking at a jam log, jump to the first failure.
function! FindFirstFailure()
    call cursor(1,0)
    call search("\\.\\.\\.failed")
endfunction

" Load the cscope.out file in the root of the workspace, if it exists.
function! LoadCscopeDatabase()
    let wsroot = GetWorkspaceRoot()
    let cscopedb = wsroot . "/cscope.out"
    if filereadable(cscopedb)
        exe "silent cs add " . cscopedb . " " . wsroot
    endif
endfunction

" Set makeprg to the current line
function! SetMakePrgToLine(line_num)
    let &makeprg=getline(a:line_num)
endfunction

" Look for a gcc command in a Jam log and attempt to run it (as a makeprg).
function! FixBugs()
    call SetMakePrgToLine(search("^ *g\?cc", 'n'))
    exe "make"
endfunction

" Set the cscope DB to the database corresponding with the selected line
" and close the Wscope window.
"
" Triggered by hitting enter in a Wscope window.
function! WscopeDoLine()
    let re = "[0-9]\\+: [^ ]\\+ \\([^ ]\\+\\)"
    let wsroot = GetWorkspaceRoot()

    if match(getline(line(".")), re) == -1
        echoerr "Invalid cursor position"
        return -1
    endif

    let lineup = substitute(getline(line(".")), re, "\\1", "")
    let cscopedb = system(g:XRWscopePath . " --print-db --lineup " . lineup)
    let cscopedb = substitute(cscopedb, ".$", "", "")
    execute "set csprg=" . g:XRWscopeCSProg 
    let cmd = "cs add " . cscopedb . " " . wsroot
    "let cmd = "cs add " . cscopedb . " " . system("dirname " . cscopedb)
    echo cmd
    execute cmd
    execute "quit"
endfunction

" Pop up a window to select a pre-built cscope database.
function! Wscope()
    silent! exec "topleft vertical 50 new"
   
    " Shamelessly copied from NERDTree
    setlocal winfixwidth
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal nobuflisted
    setlocal nospell
    setlocal nonu
    setlocal cursorline
    iabc <buffer>

    exec "nnoremap <buffer> <cr> :call WscopeDoLine()<cr>"

    silent 1,$delete _
    execute 'r !' . g:XRWscopePath . ' --print-options-only'
    normal 1GOSelect a cscope database to use.
    normal 3G
endfunction

function! TagComponent(...)
    let l:path = a:0 > 0 ? a:1 : GetComponentRoot()
    if l:path == 0
        call system("cd " . shellescape(l:path) . "; " .
                    \ "cscope -bRq -P " . shellescape(l:path))
        execute "cscope add " . l:path . " " . l:path
        cscope reset
    else
        echoerr "Not in a component"
    endif
endfunction

" Define a series of commands
command! -nargs=0 GotoJamfile call GotoJamfile()
command! -nargs=0 GotoCompMdata call GotoParentFile("comp-mdata.pl")
command! -nargs=0 GotoExports call GotoParentFile("IosApiExports.jam")
command! -nargs=0 Df call DiffToFile()
command! -nargs=0 Di echo DiffIndex()
command! -nargs=0 Dl echo DiffLine()
command! -nargs=0 Mf call MergeToFile()
command! -nargs=0 Fff call FindFirstFailure()
command! -nargs=0 Lcs call LoadCscopeDatabase()
command! -nargs=0 Smp call SetMakePrgToLine(line("."))
command! -nargs=0 Fb call FixBugs()
command! -nargs=0 Wscope call Wscope()

call LoadCscopeDatabase()

