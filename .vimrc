set nu rnu tabstop=4 shiftwidth=4 smarttab softtabstop=4 autoindent

augroup filetype_python
	au!

	autocmd FileType python setlocal expandtab
augroup END

augroup filetype_bash
	au!

	autocmd FileType sh setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END

augroup filetype_haskell
	au!

	autocmd FileType haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END

augroup filetype_config
	au!

	autocmd FileType conf setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END

if has('nvim')
	" Neovim specific commands
else
	source $VIMRUNTIME/defaults.vim
endif

