" init.vim
" by Alexandre Rames <alexandre.rames@uop.re>
"
" The configuration is targeted at and has only been tested on terminal
" vim/nvim. The primary target is now `nvim`, but backward compatibility with
" `vim` is maintained.

if empty($XDG_STATE_HOME)
  let $XDG_STATE_HOME = expand("$HOME/.local/state")
endif

if empty($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = expand("$HOME/.config")
endif

if empty($XDG_DATA_HOME)
  let $XDG_DATA_HOME = expand("$HOME/.local/share")
endif


if !has("nvim")
  " The following have been removed in neovim.
  " Use Vim settings, rather then Vi settings.
  " This must be first, because it changes other options as a side effect.
  set nocompatible
  set shell=/bin/bash
endif

set encoding=utf-8
set mouse=nvi             " Enable the mouse (e.g. for resizing).
set ignorecase            " Ignore case in search by default,
set smartcase             " but be case sensitive when using uppercase.
set wildmenu              " Command-line completion in an enhanced mode.
set wildmode=list:longest " Complete longest common string, then list.
set noerrorbells          " No bells.
set showcmd               " Display incomplete commands.
set noerrorbells          " No bells.

nnoremap <Space> <Nop>
let mapleader = " "

" Presentation ============================================================={{{1

set termguicolors                  " Use gui colors in the terminal.
"" TODO: colorscheme quiet
set winminheight=0              " Minimum size of splits is 0.
set nowrap                      " Do not wrap lines.
set scrolloff=5                    " Show at least 5 lines around the cursor.
let &showbreak = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines.

set foldlevelstart=99              " Start editing with all folds open.

set number                         " Display line numbers.

set cursorline                     " Highlight the line number...
set cursorlineopt=number           " ...for the current line.

colorscheme quiet

" Load/Save and Automatic Backup ==========================================={{{1

" Backup files.
set backup
let &backupdir=expand("$XDG_STATE_HOME/nvim/backup//")
" Keep a history of the edits so changes from a previous session can be
" undone.
set undofile
" Automatically save and load views.
autocmd BufWinLeave,BufWrite * silent! mkview
autocmd BufWinEnter * silent! loadview

" Editing =================================================================={{{1

" Turn off last search highlighting
nmap <Leader><Space> :nohlsearch<CR>

" Move between splits.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" We want editing to be fast even with large/huge files. On those,
" filetype-specific plugins can take a long time, so turn off the filetype.
let g:large_file_size = 4 * 1024 * 1024
autocmd BufReadPre *
    \ let file_size= getfsize(expand("<afile>")) |
    \ if file_size > g:large_file_size || file_size == -2 |
    \   call LargeFile() |
    \ endif
function LargeFile()
  " Disable features triggered by the filetype event, including syntax
  " highlighting.
  set eventignore+=FileType
  " Save memory when another file is viewed.
  setlocal bufhidden=unload
  autocmd VimEnter *
      \ echohl WarningMsg |
      \ echomsg "Warning: this file is larger than "
          \ . (g:large_file_size / 1024 / 1024)
          \ . " MB, so some options are modified (see init.vim for details)." |
      \ echohl None
endfunction

" Handle custom file types.
autocmd BufRead,BufNewFile *.mlir set filetype=mlir
" `.inc` files are generated via LLVM tblgen.
autocmd BufRead,BufNewFile *.cpp.inc set filetype=cpp
autocmd BufRead,BufNewFile *.h.inc set filetype=cpp

" Completion ==========================================={{{2

" Display a menu, insert the longest common prefix but don't select the first
" entry, and display some additional information if available.
set completeopt=menu,menuone,noselect,longest

" Indentation =========================================={{{2

" Recognize numbered lists and indent them nicely.
set formatoptions+=n

command! IndentTab         set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4
command! IndentGoogle      set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4
command! IndentLinuxKernel set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,:0,+4
command! IndentLLVM        set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g0,h2,N-s,t0,:0,+4
IndentLLVM " Default to LLVM-style indentation.

" Command line ============================================================={{{1

" Pressing shift-; takes too much time!
noremap ; :

" Command-line shortcuts that expand to the path of the current file.
cabbr <expr> %% fnameescape(expand("%:h"))
cabbr <expr> $$ fnameescape(expand("%"))
cabbr <expr> %%f fnameescape(expand("%:hp"))
cabbr <expr> $$f fnameescape(expand("%:p"))

" Make <C-N> and <C-P> take the beginning of the line into account.
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" Plugins =================================================================={{{1

" Since we are backward compatible with vim, some plugins are configured here
" using vim-plug. Other plugins are required using lazy.nvim via the lua
" config.

let g:pluginInstallPath = expand("$XDG_DATA_HOME/nvim/plugins")
source $XDG_CONFIG_HOME/nvim/lua/config/lazy_plug_compatibility.vim

if !has("nvim")
  call plug#begin()
endif

" Used frequently ======================================{{{2

" Easily navigate between tmux panes and vim instances.
Plugin 'christoomey/vim-tmux-navigator'

Plug 'arames/vim-diffgofile', {
  \ 'do': 'cd ftplugin && ln -s diff_gofile.vim git_diffgofile.vim',
  \ 'for': ['diff', 'git']
  \ }
let g:diffgofile_goto_existing_buffer = 1
autocmd FileType diff nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType diff nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>
autocmd FileType git nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType git nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>

" Word highlighting.
Plugin 'inkarkat/vim-ingo-library'
let g:mw_no_mappings = 1 " Disable default mappings.
Plugin 'inkarkat/vim-mark'
nmap <unique> <Leader>m <Plug>MarkSet
xmap <unique> <Leader>m <Plug>MarkSet
nmap <unique> <Leader>/ <Plug>MarkSearchAnyNext
nmap <unique> <Leader>? <Plug>MarkSearchAnyPrev

" Git integration.
Plugin 'tpope/vim-fugitive'

" Python pep8 partial formatting.
Plug 'smbl64/vim-black-macchiato'
autocmd FileType python vnoremap <buffer> gq <plug>(BlackMacchiatoSelection)
autocmd FileType python nnoremap <buffer> gq <plug>(BlackMacchiatoCurrentLine)

if !has('nvim')
  " A few alternatives to lua plugins.

  " Better status line.
  Plugin 'vim-airline/vim-airline'

  " Quickly find and open files.
  Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plugin 'junegunn/fzf.vim'
  nnoremap <leader>ff <cmd>Files<cr>
endif

" Used sometimes ======================================={{{2

Plugin 'mbbill/undotree'

" Under Testing ========================================{{{2

Plugin "machakann/vim-sandwich"

" Plugin "rafi/awesome-vim-colorschemes"

" }}}2

if !has("nvim")
  call plug#end()
endif

" Provide a way to early exit when installing plugins.
" Otherwise would would crash in the lua config below before modules are installed.
if $VIM_INSTALL_PLUGINS == "1"
  finish
endif

" Lua Initialization ======================================================={{{1

" This includes lua plugins initialization and configuration.

if has("nvim")
  lua require("init")
endif

" vim specific options ====================================================={{{1
" vim: set foldmethod=marker:
" nvim: set foldmethod=marker:
