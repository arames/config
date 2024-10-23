" .vimrc
" by Alexandre. Rames <alexandre.rames@uop.re>
"
" The configuration is targeted at and has only been tested on terminal vim.

if has('nvim')
  let s:dir_vim_config = expand("~/.config/nvim")
else
  let s:dir_vim_config = expand("~/.vim")
endif

if !has('nvim')
  " The following have been removed in neovim.
  " Use Vim settings, rather then Vi settings.
  " This must be first, because it changes other options as a side effect.
  set nocompatible
  set shell=/bin/bash
endif

set encoding=utf-8
set history=10000               " Keep 10000 lines of command line history.
set mouse=a                     " Enable the mouse (eg. for resizing).
set ignorecase                  " Ignore case in search by default,
set smartcase                   " but be case sensitive when using uppercase.
set wildmenu                    " Command-line completion in an enhanced mode.
set wildmode=list:longest       " Complete longest common string, then list.
set showcmd                     " Display incomplete commands.
set noerrorbells                " No bells.

nnoremap <Space> <Nop>
let mapleader = " "

" Presentation ============================================================={{{1

set termguicolors               " Use gui colors in the terminal.
colorscheme quiet
" Use different cursor styles in different modes.
set guicursor=a:block,i-ci:ver10,r-cr:hor10
set winminheight=0              " Minimum size of splits is 0.
set nowrap                      " Do not wrap lines.
let &sbr = nr2char(8618).' '    " Show ↪ at the beginning of wrapped lines.
set scrolloff=5                 " Show at least 5 lines around the cursor.

set foldlevelstart=99

set number                      " Display line numbers.

set cursorline
set cursorlineopt=number

" Load/save and automatic backup ==========================================={{{1

let &directory=s:dir_vim_config.'/backup/swap'
let &viewdir=s:dir_vim_config.'/backup/view'
let &backupdir=s:dir_vim_config.'/backup/backup'
let &undodir=s:dir_vim_config.'/backup/undo'

" Create directories if they don't already exist.
if !isdirectory(&directory)
  exec "silent !mkdir -p " . &directory
  exec "silent !chmod 750 " . &directory
endif
if !isdirectory(&viewdir)
  exec "silent !mkdir -p " . &viewdir
  exec "silent !chmod 750 " . &viewdir
endif
if !isdirectory(&backupdir)
  exec "silent !mkdir -p " . &backupdir
  exec "silent !chmod 750 " . &backupdir
endif
if !isdirectory(&undodir)
  exec "silent !mkdir -p " . &undodir
  exec "silent !chmod 750 " . &undodir
endif

" Backup files.
set backup
" Keep a history of the edits so changes from a previous session can be
" undone.
set undofile

" Automatically save and load views.
autocmd BufWinLeave,BufWrite *.* mkview
autocmd BufWinEnter *.* silent! loadview

" Jump to last known cursor position when editing a file.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

set autoread  " Automatically reload files changed on the disk.
set autowrite " Write a modified buffer on each :next , ...

" Autodetect filetype on first save.
autocmd BufWritePost * if &ft == "" | filetype detect | endif

" Plugins =================================================================={{{1

" Plugins Requiring Lua Configuration =================={{{2

if has('nvim')
  lua require('plugins')
endif

" }}}2

" Use Vim-plug to manage the plugins. See https://github.com/junegunn/vim-plug
" for details.

call plug#begin(s:dir_vim_config.'/plugged')

" Used frequently ======================================{{{2

if !has('nvim')
  " A few alternatives to lua plugins.

  " Better status line.
  Plug 'vim-airline/vim-airline'

  " Quickly find and open files.
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  nnoremap <leader>ff <cmd>Files<cr>
endif

" Easily navigate between tmux panes and vim instances.
Plug 'christoomey/vim-tmux-navigator'

" Easy parenthesis and co.
Plug 'tpope/vim-surround'

" Case-sensitive search and replace (and more!).
Plug 'tpope/vim-abolish'

" Git integration.
Plug 'tpope/vim-fugitive'

Plug 'arames/vim-diffgofile', {
  \ 'do': 'cd ftplugin && ln -s diff_gofile.vim git_diffgofile.vim',
  \ 'for': ['diff', 'git']
  \ }
let g:diffgofile_goto_existing_buffer = 1
autocmd FileType diff nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType diff nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>
autocmd FileType git nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType git nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>

" Used sometimes ======================================={{{2

" Word highlighting.
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'

" Allows editing the quickfix window.
Plug 'jceb/vim-editqf'

" Testing =============================================={{{2

" Python pep8 partial formatting.
Plug 'smbl64/vim-black-macchiato'
autocmd FileType python vmap <buffer> <Leader>f <plug>(BlackMacchiatoSelection)
autocmd FileType python nmap <buffer> <Leader>f <plug>(BlackMacchiatoCurrentLine)

Plug 'mbbill/undotree'

" Show content of registers.
" Plug 'tversteeg/registers.nvim'

"Plug 'windwp/nvim-autopairs'

"" Display LSP context in status bar
"Plug 'SmiteshP/nvim-navic'
"
"
"Plug 'hynek/vim-python-pep8-indent'

" }}}2

call plug#end()

" Provide a way to early exit when installing plugins.
" Otherwise would would crash in the lua config below before modules are installed.
if $VIM_INSTALL_PLUGINS == "1"
  finish
endif


" Editing =================================================================={{{1

set backspace=indent,eol,start   " Backspacing over everything in insert mode.
set hlsearch                     " Highlight the last used search pattern.
set showmatch                    " Briefly display matching bracket.
set matchtime=5                  " Time (*0.1s) to show matching bracket.
set incsearch                    " Perform incremental searching.
set tags=.tags
if has('nvim')
  set inccommand=split           " Show incremental results of substitute.
endif

" Turn off last search highlighting
nmap <Leader><Space> :nohlsearch<CR>

" Move between splits.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" Completion ==========================================={{{2
"" Display a menu, insert the longest common prefix but don't select the first
"" entry, and display some additional information if available.
set completeopt=menu,menuone,noselect,longest

"" Grep/tags ============================================{{{2
"
"" Grep in current directory.
set grepprg=grep\ -RHIn\ --exclude=\".tags\"\ --exclude-dir=\".svn\"\ --exclude-dir=\".git\"\ --exclude-dir=\"bazel-*\"
"set grepprg=ack
"" Grep for the word under the cursor.
"nnoremap K :Grep "\\<<C-r><C-w>\\>" .<CR>
"nmap <leader>grep K
"" Versions suffixed with `l` for the location list cause vim to wait for keys
"" after `grep`. Provide versions with extra characters to allow skipping the
"" wait.
"nmap <leader>grepc K
"nmap <leader>grep<Space> K
"nmap <leader>grep<CR> K
"" Grep in the current file's path.
"nmap <leader>grepd :Grep "\\<<C-r><C-w>\\>" %:p:h<CR>
"" Grep for the text selected. Do not look for word boundaries.
"vnoremap K "zy:<C-u>Grep "<C-r>z" .<CR>
"vmap <leader>grep K
"vmap <leader>grepd :Grep "\\<<C-r><C-w>\\>" %:p:h<CR>
"
"" Same as above, but for the location list.
"nnoremap <F9> :GrepL "\\<<C-r><C-w>\\>" .<CR>
"nmap <leader>grepl <F9>
"nmap <leader>grepl<Space> <F9>
"nmap <leader>grepl<CR> <F9>
"nmap <leader>grepld :GrepL "\\<<C-r><C-w>\\>" %:p:h<CR>
"vnoremap <F9> "zy:<C-u>GrepL "<C-r>z" .<CR>
"vmap <leader>grepl <F9>
"vmap <leader>grepld :GrepL "\\<<C-r><C-w>\\>" %:p:h<CR>

" Update tags file.

if has('nvim')
  let s:TagsUpdateCommand = 'ctags -o .tags --recurse --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q'
  function! s:TagsUpdateOnExit(job_id, data, event)
    if a:data == 0
      echohl Green | echo "Done building tags." | echohl None
    else
      echohl Error | echo "Building tags failed." | echohl None
    endif
  endfunction
  function! s:TagsUpdateHandler(job_id, data, event)
  endfunction
  let s:TagsUpdateCallbacks = {
  \ 'on_stdout': function('s:TagsUpdateHandler'),
  \ 'on_stderr': function('s:TagsUpdateHandler'),
  \ 'on_exit': function('s:TagsUpdateOnExit')
  \ }
  command! TagsUpdate call jobstart(split(s:TagsUpdateCommand), s:TagsUpdateCallbacks)
else
  command! TagsUpdate silent !ctags -o .tags --recurse --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q
endif

" Opens the definition in a vertical split.
" <C-w><C-]> is the default for the same in a horizontal split.
nmap <C-]>       :exec("tjump "  . expand("<cword>"))<CR>
nmap <C-w><C-]>  :exec("stjump " . expand("<cword>"))<CR>
nmap <C-v><C-]>  :vsp <CR>:exec("tjump ".expand("<cword>"))<CR>

" Indentation =========================================={{{2

autocmd BufRead,BufNewFile *.mlir set filetype=mlir
autocmd BufRead,BufNewFile *.cpp.inc set filetype=cpp
autocmd BufRead,BufNewFile *.h.inc set filetype=cpp

"set textwidth=80
set nojoinspaces

" Automatically strip the comment marker when joining automated lines.
set formatoptions+=j
" Recognize numbered lists and indent them nicely.
set formatoptions+=n

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

" Misc commands ========================================{{{2

"" Insert current date.
"imap <leader>date <C-R>=strftime('%Y-%m-%d')<CR>
"nmap <leader>date i<C-R>=strftime('%Y-%m-%d')<CR><Esc>
"
"" Spread parenthesis enclosed arguments, one on each line.
"map <F8> vi(:s/,\s*\([^$]\)/,\r\1/g<CR>vi(=f(%l
"
"" Easy paste of the search pattern without word boundaries.
"imap <C-e>/ <C-r>/<Esc>:let @z=@/<CR>`[v`]:<C-u>s/\%V\\<\\|\\>//g<CR>:let @/=@z<CR>a

" Command line ============================================================={{{1

" Pressing shift-; takes too much time!
noremap ; :
" But the ';' key to re-execute the latest find command is useful
noremap - ;
noremap _ ,

" Command-line shortcuts that expand to the path of the current file.
cabbr <expr> %% fnameescape(expand('%:h'))
cabbr <expr> $$ fnameescape(expand('%'))
cabbr <expr> %%f fnameescape(expand('%:hp'))
cabbr <expr> $$f fnameescape(expand('%:p'))

" Make <C-N> and <C-P> take the beginning of the line into account.
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" Projects ================================================================={{{1

command! IndentAP          set   expandtab shiftwidth=4 tabstop=4
augroup autopilot
  au!
  autocmd BufEnter */autopilot/* IndentAP
augroup END

""augroup ART
""  autocmd BufRead,BufEnter */art/* IndentGoogle
""  autocmd BufRead,BufEnter */art/* exec "set tags+=" . substitute(system('git rev-parse --show-toplevel'), '\n', '', 'g') . "/.tags"
""augroup END
"
""augroup VIXL
""  autocmd BufRead,BufEnter */vixl/* IndentGoogle
""augroup END
"
""" Linux Kernel style.
""augroup LinuxKernel
""  autocmd BufRead,BufEnter /work/linux/* IndentLinuxKernel
""augroup END
""augroup KernelGit
""  autocmd BufRead,BufEnter /work/linux/git/* set tags+=/work/linux/git/.tags
""augroup END

" Terminal ================================================================={{{1

"if has('nvim')
"  tnoremap <C-]> <C-\><C-n>
"endif

" Misc ====================================================================={{{1

"" The following allows using mappings with the 'alt' key in terminals using the
"" ESC prefix (including gnome terminal). Unluckily this does not always play
"" well with macros.
"" The info was found at:
""   http://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
""let c='a'
""while c <= 'z'
""  exec "set <A-".c.">=\e".c
""  exec "imap \e".c." <A-".c.">"
""  let c = nr2char(1+char2nr(c))
""endw
""set timeout ttimeoutlen=50

" vim specific options ====================================================={{{1
" vim: set foldmethod=marker:
" nvim: set foldmethod=marker:
