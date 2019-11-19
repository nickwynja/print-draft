# :printer: `pd` &mdash; Print Draft

`pd` instantly prints your draft in a well-set layout. A great companion to a
red Fineliner pen. `pd` is a small wrapper script around `pandoc` and `lp` and
combines filters and templates to set a print layout that's perfect for editing
the old fashioned way.

## Install

Run:

``` 
make install
```

You will also need to have [Pandoc](https://pandoc.org/) and a version of a
Latex engine that supports `lualatex`.

## Usage

```
Instantly print your draft in a well-set layout.

pd [OPTIONS] [FILE]
  -h     show this message
  -r     print a hash of the file contents
  -d     Don't print, just export to PDF
  -p     A print range for lp. See lp manual for format

Examples:
  pd first-draft.md
  pf -p 1-2 first-draft.md
  pf -d first-draft.md && open first-draft.pdf
```

You can optionally include Pandoc [filters](https://pandoc.org/filters.html) by
exporting an environment variable called `PD_PANDOC_FILTERS` with a
space-separated list of your filter names. The most common way to set
environment variables is by including something like this in your `.bashrc` or
`.zshrc`:

```sh
export PD_PANDOC_FILTERS="filter1 filter2"
```

## Use with vim

To execute `pd` from vim for the current file you're editing, include this
snippet in your `.vimrc` or `init.vim`:

```vim
" Print markdown draft using pandoc
function! PrintDraft(...)
  let l:filename = expand('%:p')
  " If bang! save to file
  if a:0 > 0 && a:1 == 1
    "do not print
    exec "!pd -d " . l:filename
  elseif exists('a:2')
    exec "!pd -p " . a:2  l:filename
  else
    exec "!pd " . l:filename
  endif
endfunction
command! -nargs=* -bang PrintDraft call PrintDraft(<bang>0, <f-args>)
```

With this, you can call `pd` with commands like `:PrintDraft`, `:PrintDraft!` and `:PrintDraft 1-2`.
