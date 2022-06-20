" .vimrc
" by A. Rames <alexandre.rames@uop.re>
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
let mapleader = ","

" Presentation ============================================================={{{1

set termguicolors               " Use gui colors in the terminal.
colorscheme quiet
" Use different cursor styles in different modes.
set guicursor=a:block,i-ci:ver10,r-cr:hor10
set winminheight=0              " Minimum size of splits is 0.
set nowrap                      " Do not wrap lines.
let &sbr = nr2char(8618).' '    " Show ↪ at the beginning of wrapped lines.
set scrolloff=5                 " Show at least 5 lines around the cursor.

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

set number                      " Display line numbers.

" The relative line numbering is deprecated, in favor of using `HopLine` and
" tree-sitter motions.
"set relativenumber              " Display relative line numbers.
"" Display relative line numbers in normal mode and absolute line numbers
"" in insert mode.
"augroup relativenumbertoggle
"  autocmd!
"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END
"" Always display absolute line numbers in the quick-fix windows for easy
"" ':cc <n>' commands.
"autocmd BufEnter,FocusGained,InsertLeave * if &ft == "qf" | setlocal norelativenumber | endif

" Unused options, kept for reference ==================={{{2

" nvim-treesitter takes care of highlighting
"syntax enable                   " Enable syntax highlighting.
"set cursorline                  " Highlight the line where the cursor is.
" This is taken care of by vim-airline.
"set ruler                       " Show the cursor position all the time.

" Load/save and automatic backup ==========================================={{{1

let &directory=s:dir_vim_config.'/swap'
let &viewdir=s:dir_vim_config.'/view'
let &backupdir=s:dir_vim_config.'/backup'
let &undodir=s:dir_vim_config.'/undo'

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

" Use Vim-plug to manage the plugins. See https://github.com/junegunn/vim-plug
" for details.

call plug#begin(s:dir_vim_config.'/plugged')

" Used frequently ======================================{{{2

" Easily navigate between tmux panes and vim instances.
Plug 'christoomey/vim-tmux-navigator'

" Better status line.
Plug 'vim-airline/vim-airline'

" Used mostly as a replacement for fzf.
Plug 'nvim-telescope/telescope.nvim'
" Its dependencies.
Plug 'nvim-lua/plenary.nvim'
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" Extensions
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'neovim/nvim-lspconfig'

" Quickly move around.
Plug 'phaazon/hop.nvim'
noremap ]w <cmd>HopWord<CR>
noremap [w <cmd>HopWord<CR>
noremap ]l <cmd>HopLineStart<CR>
noremap [l <cmd>HopLineStart<CR>

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate cpp'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" For debugging.
Plug 'nvim-treesitter/playground'

" Git integration.
Plug 'tpope/vim-fugitive'

" Display color codes.
Plug 'norcalli/nvim-colorizer.lua'

" Case-sensitive search and replace (and more!).
Plug 'tpope/vim-abolish'

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

" Easy parenthesis and co.
Plug 'tpope/vim-surround'

" Personal wiki
Plug 'vim-scripts/vimwiki'
" Use the markdown syntax
let g:vimwiki_list = [{'path': '~/work/wiki',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

" Word highlighting.
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'

" Testing =============================================={{{2

" LSP completion

"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"let g:coq_settings = { 'auto_start': v:true, 'display.icons.mode': 'none' }

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'windwp/nvim-autopairs'

Plug 'jceb/vim-editqf'


" Unclassified ========================================={{{2

" Unused ==============================================={{{2

" Keeping for reference or future use.

"" Display lines git diff status when editing a file in a git repository.
"Plug 'airblade/vim-gitgutter'

"" Code completion using LSP.
"" Deprecated by builtin LSP support, completion-nvim.
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gh <Plug>(coc-declaration)
"nmap <silent> gr <Plug>(coc-references)
"nmap <silent> gs <Plug>(coc-rename)
"
"xmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>f <Plug>(coc-format-selected)
"
"" TODO: Add a shortcut to :CocAction
"nmap <silent> gj :CocAction<CR>
"
"set updatetime=500
"
"autocmd CursorMoved * silent call CocActionAsync('highlight')

"nnoremap <silent> K :call <SID>show_documentation()<CR>
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"if executable('clangd')
"    autocmd User lsp_setup call lsp#register_server({
"        \ 'name': 'clangd',
"        \ 'cmd': {server_info->['clangd', '-background-index']},
"        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"        \ })
"endif
""let g:lsp_log_verbose = 1
""let g:lsp_log_file = expand('~/vim-lsp.log')
"
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"" TODO: Not seeing preview
" set completeopt+=preview
""autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

"nnoremap ,g :LspDefinition<CR>
"nnoremap ,r :LspReferences<CR>
"nnoremap ,p :LspPreviousReference<CR>
"nnoremap ,n :LspNextReference<CR>
"nnoremap ,s :LspRename<CR>
"nnoremap <C-<Space>> :LspPeekDefinition

" Deprecated by nvim-treesitter-textobjects.
"" Provide argument objects.
"Plug 'inkarkat/argtextobj.vim'

" Deprecated by hop.nvim.
"" Quickly move around.
"Plug 'Lokaltog/vim-easymotion'
"let g:EasyMotion_leader_key = ','
"let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" Deprecated by nvim-treesitter/playground.
"" Highlight backtrace. Useful to edit color schemes.
"Plug 'gerw/vim-HiLinkTrace'

""" Switch between header and implementation files.
""Plug 'vim-scripts/a.vim'
""nnoremap <leader>hh :A<CR>
"
""Plug 'scrooloose/nerdtree'
"
"" `clang-format` integration.
" Now provided directly by `coc.vim`.
"Plug 'kana/vim-operator-user' " Required by `vim-clang-format`.
"Plug 'rhysd/vim-clang-format'
"autocmd FileType c,cpp,objc map <buffer><Leader>f <Plug>(operator-clang-format)
"
" I just use the default airline theme.
"Plug 'vim-airline/vim-airline-themes'
"
"" Now using `coc.vim` instead.
""if has('python3')
""  Plug 'Valloric/YouCompleteMe', {
""  \ 'do': './install.py --clang-completer'
""  \ }
""  " A few YCM configuration files are whitelisted in `~/.vim.ycm_whitelist`. For
""  " others, ask for confirmation before loading.
""  let g:ycm_confirm_extra_conf = 1
""  if filereadable(resolve(expand("~/.config/nvim/ycm_whitelist")))
""    " This file should look something like:
""    "   let g:ycm_extra_conf_globlist = ['path/to/project_1/*', 'path/to/project_2/*' ]
""    source ~/.config/nvim/ycm_whitelist
""  endif
""  " Don't use <Tab>. <C-n> and <C-p> are better, and we use tabs in vim-sem-tabs.
""  let g:ycm_key_list_select_completion = ['<Down>']
""  let g:ycm_key_list_previous_completion = ['<Up>']
""
""  " By default we use `clangd` with YCM. Uncomment the following to disable `clangd`.
""  " let g:ycm_use_clangd = 0
""  " Allow background indexing.
""  " In particular, this allows `GoToDefinition` across compilation units.
""  let g:ycm_clangd_args = [ '-background-index' ]
""  " Let clangd fully control code completion.
""  let g:ycm_clangd_uses_ycmd_caching = 0
""  " Use installed clangd, not the YCM-bundled clangd which doesn't get updates.
""  let g:ycm_clangd_binary_path = exepath("clangd")
""
""  " Fast access to YcmCompleter
""  cabbrev ycmc YcmCompleter
""  nnoremap ,g  :YcmCompleter GoTo<CR>
""  nnoremap ,gg  :YcmCompleter GoTo<CR>
""  nnoremap ,gh :YcmCompleter GoToDeclaration<CR>
""  nnoremap ,gc :YcmCompleter GoToDefinition<CR>
""
""  " TODO: This bugs when editting in the command-editing window (<C-F> in
""  " command mode).
""  "" Automatically close the pop-up windown on move.
""  "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
""  "autocmd InsertLeave * if pumvisible() == 0|pclose|endif
""endif

" Deprecated by telescope.
"" Fuzzy finder.
"Plug 'junegunn/fzf'
"nmap <C-p> :FZF<CR>

" Deprecated by fzf.
"" Quick file find and open.
"Plug 'kien/ctrlp.vim'

"" Easy commenting and uncommenting.
"Plug 'tpope/vim-commentary'

"" Asynchronous grep.
"Plug 'arames/vim-async-grep'

""" Allow opening a file to a specific line with 'file:line'
""Plug 'bogado/file-line'

""" Easy access to an undo tree.
""Plug 'mbbill/undotree'

""" Diff between selected blocks of code.
""Plug 'AndrewRadev/linediff.vim'

"" Languages syntax.
"Plug 'dart-lang/dart-vim-plugin'
"Plug 'plasticboy/vim-markdown'
"Plug 'hynek/vim-python-pep8-indent'

"" Easy alignment.
"Plug 'junegunn/vim-easy-align'
"vmap <Enter> <Plug>(EasyAlign)

""Plug 'Rip-Rip/clang_complete'
"let g:clang_library_path='/usr/lib/llvm-3.2/lib/'

"" Asynchronous commands
"Plug 'tpope/vim-dispatch'
"Plug 'vim-scripts/Align'
"" Need to work out how to get it working for more complex projects.
"Plug 'scrooloose/syntastic'

"Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

" }}}2

call plug#end()

" Provide a way to early exit when installing plugins.
" Otherwise would would crash in the lua config below before modules are installed.
if $VIM_INSTALL_PLUGINS == "1"
  finish
endif

" Late Plugin Configuration ============================{{{2

" Some lua configuration must happen after the call to `plug#end`.

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-f>"] = actions.preview_scrolling_down,
      },
    },
  },
}
require('telescope').load_extension('fzy_native')
EOF

lua << EOF
require('colorizer').setup({ '*'; }, { mode = 'foreground' })
EOF

lua << EOF
require('hop').setup()
EOF

" TODO: Set up incremental selection: https://github.com/nvim-treesitter/nvim-treesitter#available-modules
lua << EOF
require('nvim-treesitter.configs').setup {
  highlight = { enable = true, },
  indent = { enable = true, },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]c"] = "@class.outer",
        ["]f"] = "@function.outer",
        ["]a"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[c"] = "@class.outer",
        ["[f"] = "@function.outer",
        ["[a"] = "@parameter.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner", },
      swap_previous = { ["<leader>A"] = "@parameter.inner", },
    },
  },
}
EOF

lua << EOF
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>s', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  -- The default suggested formatting binding formats the full buffer. Instead,
  -- format ranges.
  -- See https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips.
  --buf_set_keymap('v', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR><Esc>', opts)
  function format_range_operator()
    local old_func = vim.go.operatorfunc
    _G.op_func_formatting = function()
      local start = vim.api.nvim_buf_get_mark(0, '[')
      local finish = vim.api.nvim_buf_get_mark(0, ']')
      vim.lsp.buf.range_formatting({}, start, finish)
      vim.go.operatorfunc = old_func
      _G.op_func_formatting = nil
    end
    vim.go.operatorfunc = 'v:lua.op_func_formatting'
    vim.api.nvim_feedkeys('g@', 'n', false)
  end
  vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua format_range_operator()<CR>", {noremap = true})
  vim.api.nvim_set_keymap("v", "<leader>f", "<cmd>lua format_range_operator()<CR>", {noremap = true})

  if client.resolved_capabilities.document_highlight then
      vim.cmd('augroup LSPCurrentSymbolHighlight')
      vim.cmd('autocmd!')
      vim.cmd('autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
      vim.cmd('autocmd CursorMoved <buffer> lua vim.lsp.buf.document_highlight()')
      vim.cmd('augroup END')
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {'clangd', 'pyright'}
for _, lsp in pairs(servers) do
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig')[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
EOF

lua << EOF
  local cmp = require'cmp'
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')

  cmp.setup({
    mapping = {
      ['<C-n>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ['<C-p>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      ['<CR>'] = cmp.mapping.confirm(),
      ['('] = cmp.mapping.confirm(),
      ['<Space>'] = cmp.mapping.confirm(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' }
    }, {
      { name = 'buffer' },
    })
  })
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
EOF

lua << EOF
require('nvim-autopairs').setup()
EOF

set completeopt=menu,menuone,noselect,preview

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
"nmap <Space> :nohlsearch<CR>

" Move between splits.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" Completion ==========================================={{{2
"" Display a menu, insert the longest common prefix but don't select the first
"" entry, and display some additional information if available.
"set completeopt=menu,longest,preview

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

set textwidth=80
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

" Terminal ================================================================={{{1

if has('nvim')
  tnoremap <C-]> <C-\><C-n>
endif

" Command line ============================================================={{{1

" Pressing shift-; takes too much time!
noremap ; :
" But the ';' key to re-execute the latest find command is useful
noremap - ;
noremap _ ,

" %% expands to the path of the current file.
cabbr <expr> %% fnameescape(expand('%:p:h'))
cabbr <expr> $$ fnameescape(expand('%:p'))

" Make <C-N> and <C-P> take the beginning of the line into account.
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

"command! NukeTrailingWhitespace :%s/\s\+$//e
"" We could automatcially delete trailing whitespace upon save with
""   autocmd BufWritePre * :%s/\s\+$//e
"" However this becomes annoying when dealing with dirty external projects, when
"" the deletions make it into patches.

" Projects ================================================================={{{1

augroup metalfe
  au!
  "autocmd BufNewFile,BufRead *.metal set filetype=cpp
  "autocmd BufNewFile,BufRead metal_* set filetype=cpp
  autocmd BufEnter */metalfe/* IndentLLVM
augroup END

"augroup ART
"  autocmd BufRead,BufEnter */art/* IndentGoogle
"  autocmd BufRead,BufEnter */art/* exec "set tags+=" . substitute(system('git rev-parse --show-toplevel'), '\n', '', 'g') . "/.tags"
"augroup END

"augroup VIXL
"  autocmd BufRead,BufEnter */vixl/* IndentGoogle
"augroup END

"" Linux Kernel style.
"augroup LinuxKernel
"  autocmd BufRead,BufEnter /work/linux/* IndentLinuxKernel
"augroup END
"augroup KernelGit
"  autocmd BufRead,BufEnter /work/linux/git/* set tags+=/work/linux/git/.tags
"augroup END

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

" Deprecated ==============================================================={{{1

" Deprecated configuration items, that may be useful for future reference.

" While useful, I prefer using <C-f> in command-line mode.
"" Remap keys to move like in edit mode.
"cnoremap <C-j> <C-N>
"cnoremap <C-k> <C-P>
"cnoremap <C-h> <Left>
"cnoremap <C-l> <Right>
"cnoremap <C-b> <C-Left>
"cnoremap <C-w> <C-Right>
"cnoremap <C-x> <Del>

" .vimrc specific options =================================================={{{1
" vim: set foldmethod=marker:
" nvim: set foldmethod=marker:
