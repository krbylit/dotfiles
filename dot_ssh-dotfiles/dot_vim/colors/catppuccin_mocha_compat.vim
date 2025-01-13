" catppuccin theme using 256-colors for compatability with older Vim that doesn't have `termguicolors`
set background=dark
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='catppuccin_mocha_compat'
set t_Co=256

" Define 256-color equivalents
let s:rosewater = "223"  " #F5E0DC → 223
let s:flamingo = "224"   " #F2CDCD → 224
let s:pink = "225"       " #F5C2E7 → 225
let s:mauve = "183"      " #CBA6F7 → 183
let s:red = "167"        " #F38BA8 → 167
let s:maroon = "131"     " #EBA0AC → 131
let s:peach = "215"      " #FAB387 → 215
let s:yellow = "229"     " #F9E2AF → 229
let s:green = "149"      " #A6E3A1 → 149
let s:teal = "109"       " #94E2D5 → 109
let s:sky = "117"        " #89DCEB → 117
let s:sapphire = "81"    " #74C7EC → 81
let s:blue = "75"        " #89B4FA → 75
let s:lavender = "147"   " #B4BEFE → 147

let s:text = "188"       " #CDD6F4 → 188
let s:subtext1 = "145"   " #BAC2DE → 145
let s:subtext0 = "103"   " #A6ADC8 → 103
let s:overlay2 = "102"   " #9399B2 → 102
let s:overlay1 = "60"    " #7F849C → 60
let s:overlay0 = "59"    " #6C7086 → 59
let s:surface2 = "240"   " #585B70 → 240
let s:surface1 = "237"   " #45475A → 237
let s:surface0 = "235"   " #313244 → 235

let s:base = "234"       " #1E1E2E → 234
let s:mantle = "233"     " #181825 → 233
let s:crust = "232"      " #11111B → 232

function! s:hi(group, guisp, ctermfg, ctermbg, gui, cterm)
  let cmd = ""
  if a:ctermfg != ""
    let cmd = cmd . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    let cmd = cmd . " ctermbg=" . a:ctermbg
  endif
  if a:cterm != ""
    let cmd = cmd . " cterm=" . a:cterm
  endif
  if cmd != ""
    exec "hi " . a:group . cmd
  endif
endfunction



call s:hi("Normal", "NONE", s:text, s:base, "NONE", "NONE")
call s:hi("Visual", "NONE", "NONE", s:surface1,"bold", "bold")
call s:hi("Conceal", "NONE", s:overlay1, "NONE", "NONE", "NONE")
call s:hi("ColorColumn", "NONE", "NONE", s:surface0, "NONE", "NONE")
call s:hi("Cursor", "NONE", s:base, s:text, "NONE", "NONE")
call s:hi("lCursor", "NONE", s:base, s:text, "NONE", "NONE")
call s:hi("CursorIM", "NONE", s:base, s:text, "NONE", "NONE")
call s:hi("CursorColumn", "NONE", "NONE", s:mantle, "NONE", "NONE")
call s:hi("CursorLine", "NONE", "NONE", s:surface0, "NONE", "NONE")
call s:hi("Directory", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("DiffAdd", "NONE", s:base, s:green, "NONE", "NONE")
call s:hi("DiffChange", "NONE", s:base, s:yellow, "NONE", "NONE")
call s:hi("DiffDelete", "NONE", s:base, s:red, "NONE", "NONE")
call s:hi("DiffText", "NONE", s:base, s:blue, "NONE", "NONE")
call s:hi("EndOfBuffer", "NONE", "NONE", "NONE", "NONE", "NONE")
call s:hi("ErrorMsg", "NONE", s:red, "NONE", "bolditalic"    , "bold,italic")
call s:hi("VertSplit", "NONE", s:crust, "NONE", "NONE", "NONE")
call s:hi("Folded", "NONE", s:blue, s:surface1, "NONE", "NONE")
call s:hi("FoldColumn", "NONE", s:overlay0, s:base, "NONE", "NONE")
call s:hi("SignColumn", "NONE", s:surface1, s:base, "NONE", "NONE")
call s:hi("IncSearch", "NONE", s:surface1, s:pink, "NONE", "NONE")
call s:hi("CursorLineNR", "NONE", s:lavender, "NONE", "NONE", "NONE")
call s:hi("LineNr", "NONE", s:surface1, "NONE", "NONE", "NONE")
call s:hi("MatchParen", "NONE", s:peach, "NONE", "bold", "bold")
call s:hi("ModeMsg", "NONE", s:text, "NONE", "bold", "bold")
call s:hi("MoreMsg", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("NonText", "NONE", s:overlay0, "NONE", "NONE", "NONE")
call s:hi("Pmenu", "NONE", s:overlay2, s:surface0, "NONE", "NONE")
call s:hi("PmenuSel", "NONE", s:text, s:surface1, "bold", "bold")
call s:hi("PmenuSbar", "NONE", "NONE", s:surface1, "NONE", "NONE")
call s:hi("PmenuThumb", "NONE", "NONE", s:overlay0, "NONE", "NONE")
call s:hi("Question", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("QuickFixLine", "NONE", "NONE", s:surface1, "bold", "bold")
call s:hi("Search", "NONE", s:pink, s:surface1, "bold", "bold")
call s:hi("SpecialKey", "NONE", s:subtext0, "NONE", "NONE", "NONE")
call s:hi("SpellBad", "NONE", s:base, s:red, "NONE", "NONE")
call s:hi("SpellCap", "NONE", s:base, s:yellow, "NONE", "NONE")
call s:hi("SpellLocal", "NONE", s:base, s:blue, "NONE", "NONE")
call s:hi("SpellRare", "NONE", s:base, s:green, "NONE", "NONE")
call s:hi("StatusLine", "NONE", s:text, s:mantle, "NONE", "NONE")
call s:hi("StatusLineNC", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("StatusLineTerm", "NONE", s:text, s:mantle, "NONE", "NONE")
call s:hi("StatusLineTermNC", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("TabLine", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("TabLineFill", "NONE", "NONE", s:mantle, "NONE", "NONE")
call s:hi("TabLineSel", "NONE", s:green, s:surface1, "NONE", "NONE")
call s:hi("Title", "NONE", s:blue, "NONE", "bold", "bold")
call s:hi("VisualNOS", "NONE", "NONE", s:surface1, "bold", "bold")
call s:hi("WarningMsg", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("WildMenu", "NONE", "NONE", s:overlay0, "NONE", "NONE")
call s:hi("Comment", "NONE", s:overlay0, "NONE", "NONE", "NONE")
call s:hi("Constant", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Identifier", "NONE", s:flamingo, "NONE", "NONE", "NONE")
call s:hi("Statement", "NONE", s:mauve, "NONE", "NONE", "NONE")
call s:hi("PreProc", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Type", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Special", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Underlined", "NONE", s:text, s:base, "underline", "underline")
call s:hi("Error", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Todo", "NONE", s:base, s:flamingo, "bold", "bold")

call s:hi("String", "NONE", s:green, "NONE", "NONE", "NONE")
call s:hi("Character", "NONE", s:teal, "NONE", "NONE", "NONE")
call s:hi("Number", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Boolean", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Float", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Function", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Conditional", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Repeat", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Label", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Operator", "NONE", s:sky, "NONE", "NONE", "NONE")
call s:hi("Keyword", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Include", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("StorageClass", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Structure", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Typedef", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("debugPC", "NONE", "NONE", s:crust, "NONE", "NONE")
call s:hi("debugBreakpoint", "NONE", s:overlay0, s:base, "NONE", "NONE")

hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link SpecialChar Special
hi link Tag Special
hi link Delimiter Special
hi link SpecialComment Special
hi link Debug Special
hi link Exception Error
hi link StatusLineTerm StatusLine
hi link StatusLineTermNC StatusLineNC
hi link Terminal Normal
hi link Ignore Comment

" Set terminal colors for playing well with plugins like fzf
let g:terminal_ansi_colors = [
  \ s:surface1, s:red, s:green, s:yellow, s:blue, s:pink, s:teal, s:subtext1,
  \ s:surface2, s:red, s:green, s:yellow, s:blue, s:pink, s:teal, s:subtext0
\ ]
