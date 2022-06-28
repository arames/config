" Left over of vim config not yet ported to `init.lua`.
" by Alexandre Rames <alexandre.rames@uop.re>
"
" The configuration is targeted at and has only been tested on terminal vim.

" Presentation ============================================================={{{1

let &sbr = nr2char(8618).' '    " Show ↪ at the beginning of wrapped lines.

" Load/save and automatic backup ==========================================={{{1

" Autodetect filetype on first save.
autocmd BufWritePost * if &ft == "" | filetype detect | endif

" Disable a bunch of settings for large files.
let g:large_file_size = 1 * 1024 * 1024

autocmd BufReadPre *
      \ let f=expand("<afile>") |
      \ if getfsize(f) > g:large_file_size |
      \   setlocal bufhidden=unload |
      \   setlocal noswapfile | 
      \   setlocal noundofile | 
      \   setlocal undolevels=100 |
      \ endif


" Plugins =================================================================={{{1

" Used frequently ======================================{{{2

"Plug 'arames/vim-diffgofile', {
"  \ 'do': 'cd ftplugin && ln -s diff_gofile.vim git_diffgofile.vim',
"  \ 'for': ['diff', 'git']
"  \ }
let g:diffgofile_goto_existing_buffer = 1
autocmd FileType diff nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType diff nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>
autocmd FileType git nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType git nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>

" Used sometimes ======================================={{{2

"" Personal wiki
"Plug 'vim-scripts/vimwiki'
"" Use the markdown syntax
"let g:vimwiki_list = [{'path': '~/work/wiki',
"                     \ 'syntax': 'markdown', 'ext': '.md'}]
"
"" Word highlighting.
"Plug 'inkarkat/vim-ingo-library'
"Plug 'inkarkat/vim-mark'

" Indentation =========================================={{{2

command! IndentTab         set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4
command! IndentGoogle      set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4
command! IndentLinuxKernel set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,:0,+4
command! IndentLLVM        set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g0,h2,N-s,t0,:0,+4

" Default indentation styles
IndentGoogle
autocmd FileType cpp IndentLLVM
autocmd FileType sh IndentLLVM


""  Show indentation guides.
"set list listchars=tab:\.\

" .vimrc specific options =================================================={{{1
" vim: set foldmethod=marker:
" nvim: set foldmethod=marker:
