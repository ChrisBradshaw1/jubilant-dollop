" Vim color file (automation.vim)
" Maintainer:    Ken McConnell <nacer@yahoo.com>
" Last Change:   2004 Jan 15
"                                                                            
" This color scheme uses a light grey background.  It was created to simulate
" the look of an IDE.  It is named after the MFP Automation Team at HP Boise.
"                                                                            

" First remove all existing highlighting.
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "automation"

hi Normal                                               ctermfg=Black                                               guifg=Black         guibg=White
hi ErrorMsg         term=standout                       ctermfg=White       ctermbg=Red                             guifg=White         guibg=Red 
hi IncSearch        term=reverse      cterm=bold                                                    gui=bold
hi ModeMsg          term=bold         cterm=bold                                                    gui=bold
hi StatusLine       term=bold         cterm=bold                                                    gui=bold
hi StatusLineNC     term=bold         cterm=bold                                                    gui=bold
hi VertSplit        term=bold         cterm=bold                                                    gui=bold
hi Visual           term=bold         cterm=bold        ctermfg=Grey        ctermbg=fg              gui=bold        guifg=Grey          guibg=fg
hi VisualNOS        term=underline    cterm=underline                                               gui=underline
hi DiffText                           cterm=bold                            ctermbg=Red             gui=bold                            guibg=Red
hi Cursor                                               ctermfg=Black       ctermbg=Black                           guifg=Black         guibg=Black
hi lCursor                                              ctermfg=Black       ctermbg=Cyan                            guifg=Black         guibg=Cyan
hi Directory        term=bold                           ctermfg=DarkBlue                                            guifg=DarkBlue
hi LineNr                                               ctermfg=DarkGrey                                            guifg=DarkGrey
hi MoreMsg                            cterm=bold        ctermfg=Cyan                                gui=bold        guifg=SeaGreen
hi NonText                            cterm=bold        ctermfg=DarkGreen                           gui=bold        guifg=DarkGreen
hi Question                           cterm=bold        ctermfg=Green                               gui=bold        guifg=Green
hi Search                                               ctermfg=Black       ctermbg=Yellow                          guifg=Black         guibg=Yellow  
hi SpecialKey       term=bold                           ctermfg=DarkBlue                                            guifg=DarkBlue
hi Title                              cterm=bold        ctermfg=DarkBlue                            gui=bold        guifg=DarkBlue
hi WarningMsg       term=standout                       ctermfg=Red                                                 guifg=Red
hi WildMenu                                             ctermfg=Black       ctermbg=Yellow                          guifg=Black         guibg=Yellow
hi Folded                                               ctermfg=DarkBlue    ctermbg=LightGrey                       guifg=DarkBlue      guibg=LightGrey
hi FoldColumn       term=standout                       ctermfg=DarkBlue    ctermbg=Grey                            guifg=DarkBlue      guibg=Grey
hi DiffAdd          term=bold                                               ctermbg=LightBlue                                           guibg=LightBlue
hi DiffChange       term=bold                                               ctermbg=LightMagenta                                        guibg=LightMagenta
hi DiffDelete       term=bold         cterm=bold        ctermfg=Blue        ctermbg=LightCyan       gui=bold        guifg=Blue          guibg=LightCyan
hi Comment                                              ctermfg=Blue                                                guifg=Blue
hi String                                               ctermfg=DarkGreen                                           guifg=DarkGreen
hi Statement                                            ctermfg=DarkBlue                                            guifg=DarkBlue
hi Label                              cterm=bold        ctermfg=DarkBlue                            gui=bold        guifg=DarkBlue
hi Constant         term=underline                      ctermfg=DarkBlue    ctermbg=LightGrey                       guifg=DarkBlue      guibg=Grey96
hi Special          term=bold                           ctermfg=DarkBlue    ctermbg=LightGrey                       guifg=DarkBlue      guibg=Grey96
hi Statement        term=bold                           ctermfg=DarkBlue                                            guifg=DarkBlue 
hi Ignore                                               ctermfg=LightGrey                                           guifg=grey90

" vim: sw=2
