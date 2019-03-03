let s:parent_path = fnamemodify(resolve(expand('<sfile>:p:h')), ':h')
let s:template_path = s:parent_path . '/template/'

function! GenerateDraftHash(...)
    if has('mac')
        let hash = system("md5 -q " . expand('%') . " | cut -c 26- | tr -cd '[:print:]'")
    else
        let hash = system("md5sum " . expand('%') . " | awk '{ print $1 }' | cut -c 26- | tr -cd '[:print:]'")
    endif
    return hash
endfunction

function! DraftHash(...)
    echom GenerateDraftHash()
endfunction
command! -nargs=* -bang DraftHash call DraftHash(<bang>0, <f-args>)

" Print markdown draft using pandoc
function! PrintDraft(...)
    let g:printdraft_pdf_path = get(g:, 'printdraft_pdf_path', "/tmp/")
    let g:printdraft_pandoc_pdf_engine = get(g:, 'printdraft_pandoc_pdf_engine', "lualatex")
    let g:printdraft_pandoc_templates = get(g:, 'printdraft_pandoc_templates', [ s:template_path . 'template-draft.tex'])
    let g:printdraft_pandoc_filters = get(g:, 'printdraft_pandoc_filters', [])
    let g:printdraft_pandoc_variables = get(g:, 'printdraft_pandoc_variables', [])

    let l:pandoc_version = system("pandoc --version | head -1 | tr -d 'pandoc '")
    let l:filename = expand('%:p')
    let l:output_fname = expand('%:t:r') . '.pdf'
    let l:output_fpath = g:printdraft_pdf_path . l:output_fname

    let l:hash = GenerateDraftHash()

    echom "Converting to pdf..."
    if l:pandoc_version > '2.0.0'
		let cmd = "pandoc"
        if len(g:printdraft_pandoc_templates) > 0
            for template in g:printdraft_pandoc_templates
                let cmd .= " --template " . template
            endfor
        endif
        if len(g:printdraft_pandoc_filters) > 0
            for filter in g:printdraft_pandoc_filters
                let cmd .= " --filter " . filter
            endfor
        endif

		let cmd .= " --pdf-engine " . g:printdraft_pandoc_pdf_engine

        if len(g:printdraft_pandoc_variables) > 0
            for variable in g:printdraft_pandoc_variables
                let cmd .= " --variable " . variable
            endfor
        endif

		let cmd .= " --variable draftfilename:" . shellescape(l:filename)
		let cmd .= " --variable filecontentshash:" . shellescape(l:hash)
		let cmd .= " -f markdown"
		let cmd .= " --output " . l:output_fpath
		let cmd .= " %" "input file from expanded filename
        echom cmd
        silent execute "!" . cmd
    else
		echoerr "Upgade your version of pandoc"
    endif

    if v:shell_error > 0
        echoerr "Error! Pandoc returned error code " . v:shell_error
		return
	endif

	" If bang! save to file
	if a:0 > 0 && a:1 == 1
		echom "PDF saved to " . l:output_fpath
    else
		echom 'Printing ' . l:output_fname
        if exists('a:2')
            let l:pageranges = '-o page-ranges=' . a:2
        else
            let l:pageranges = ''
        endif
		silent execute '!lp -o fit-to-page -o sides=one-sided ' . l:pageranges l:output_fpath
		if v:shell_error > 0
			echoerr 'Error! lp returned error code ' . v:shell_error
			return
		endif
		echom 'Done!'
		silent execute '!rm ' . l:output_fpath
    endif
endfunction
command! -nargs=* -bang PrintDraft call PrintDraft(<bang>0, <f-args>)
