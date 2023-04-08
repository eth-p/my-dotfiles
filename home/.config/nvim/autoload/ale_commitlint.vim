"
" Adds support for linting commit messages within vim/neovim.
" https://gist.github.com/kizzx2/4f3b797f443dbfa2453a3585fbed47c7
"

function! ale_commitlint#Handle(buffer, lines) abort
    " Matches patterns line the following:
    let l:pattern = '^\(✖\|⚠\)\s\+\(.*\) \(\[.*\]\)$'
    let l:output = []
    let l:line = getline(1)

    if l:line[0] != '#'
        for l:match in ale#util#GetMatches(a:lines, l:pattern)
            let l:item = {
            \   'lnum': 1,
            \   'text': l:match[2],
            \   'code': l:match[3],
            \   'type': l:match[1] is# '✖' ? 'E' : 'W',
            \}

            call add(l:output, l:item)
        endfor
    endif

    return l:output
endfunction

function! ale_commitlint#register()
    call ale#linter#Define("gitcommit", {
        \ 'name': 'commitlint',
        \ 'executable': 'commitlint',
        \ 'command': 'commitlint -c false',
        \ 'output_stream': 'stdout',
        \ 'callback': 'ale_commitlint#Handle',
        \ })
endfunction
