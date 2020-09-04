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
	" Copied from reddit (ConinuedBug)
	" https://www.reddit.com/r/neovim/comments/igc5kr/how_to_restore_last_cursor_position_on_file_reopen/g2t52yq
	augroup vimrc-remember-cursor-position
		au!

		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	augroup END
else
	source $VIMRUNTIME/defaults.vim
endif

