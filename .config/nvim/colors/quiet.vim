set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "quiet"

" Reference groups

hi       Normal                guifg=#cccccc guibg=#111111 gui=none
hi       NormalUnderline       guifg=#cccccc guibg=#111111 gui=underline

hi       LowInterest           guifg=#777777               gui=none
hi       LowInterestBold       guifg=#777777               gui=bold
hi       Interest              guifg=#bb8855               gui=none
hi       InterestBold          guifg=#bb8855               gui=bold
hi       HighInterest          guifg=#cc2244 guibg=none    gui=none
hi       HighInterestUnderline guifg=#cc2244 guibg=none    gui=underline
hi       HighInterestBg        guifg=none    guibg=#cc2244 gui=none

hi       Focus                 guifg=#228822               gui=none
hi       FocusBg                             guibg=#115511 gui=none

hi       Error                 guifg=#111111 guibg=#bb0000 gui=bold
hi       ErrorBg               guifg=#bb0000 guibg=#111111 gui=bold
hi       Warning               guifg=#111111 guibg=#c08000 gui=bold
hi       WarningBg             guifg=#c08000 guibg=#111111 gui=bold


" Usual groups

hi! link Comment               LowInterest
hi!      Keyword               guifg=#5599cc guibg= gui=
hi! link Todo                  LowInterestBold
hi! link Search                HighInterestUnderline
hi! link MatchParen            FocusBg
hi!      Visual                              guibg=#183058 gui=none

hi! link NonText               LowInterest
hi! link LineNr                LowInterest
hi! link Cursor                HighInterestBg
hi! link CursorLineNr          Normal
hi! link VertSplit             LowInterest
" hi  CursorLine               guibg=#222222

hi! link TabLine               LowInterest
hi! link TabLineFill           LowInterest
hi! link TabLineSel            NormalUnderline
hi! link Title                 TabLine
hi! link SignColumn            Normal
hi! link Folded                Warning

hi! Pmenu                                    guibg=#113311
hi! PmenuSel                                 guibg=#115511

hi! link Identifier            Normal
hi! Constant                   guifg=#99bb99               gui=none
hi! PreProc                    guifg=#994499               gui=none
"hi! Keyword                    guifg=#90b0e0               gui=none
hi! link Type                  Normal
hi! link Statement             Interest

" Diff
hi! link diffIndexLine         Normal
hi! link diffFile              Interest
hi! link diffNewFile           Interest
hi! link diffLine              Normal
hi! link diffSubname           Type

hi  DiffAdd              guifg=#00aa00 guibg=#111111 gui=none
hi  DiffDelete           guifg=#cc0000 guibg=#111111 gui=none
hi! link DiffText Normal
hi! link diffAdded   DiffAdd
hi! link diffChange  Interest
hi! link diffRemoved DiffDelete

" Plugin-specific groups

" nvim-treesitter
hi!      TSMethod guifg=#5599cc
hi! link Delimiter             Normal
hi! link Function              Normal
hi! link Operator              Normal
hi! link TSConstructor         Normal
hi! link TSKeywordReturn       Statement
hi! link TSNamespace           Normal
hi! link TSString              Constant
hi! link TSStringEscape        Constant
hi! link TSVariableBuiltin     Normal

" nvim-lspconfig
hi! link LspReference          Focus
hi! link LspReferenceText      LspReference
hi! link LspReferenceWrite     LspReferenceText
hi! link LspReferenceRead      LspReferenceText


" coc.nvim

"hi! link CocErrorFloat         Error
"hi! link CocErrorHighlight     ErrorBg
"hi! link CocErrorSign          Error
"hi! link CocHighlightText      Focus
"hi! link CocWarningFloat       Warning
"hi! link CocWarningHighlight   WarningBg
"hi! link CocWarningSign        Warning

" LLVM
hi tgKeyword ctermfg=179
hi tgType ctermfg=110

" C++
hi! link cppStatement Normal
" TODO
hi! cppAccess ctermfg=3 ctermbg=233

" Markdown
hi markdownH1    ctermfg=161
hi markdownH2    ctermfg=162
hi markdownH3    ctermfg=163
hi markdownCode  ctermfg=110
hi! link markdownCodeBlock markdownCode

" Vimwiki
hi! link VimwikiPre Constant

" Custom for vimrc
hi Green ctermfg=47
