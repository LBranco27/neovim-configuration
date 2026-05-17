" Leader must be set before lazy.nvim loads
let mapleader = ' '
let maplocalleader = ' '

" Plugins (lazy.nvim)
lua require('plugins')

" Config
lua require('branco/')

" C-z scrolling
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Prettier
let g:prettier#config#tab_width = 4
let g:prettier#config#use_tabs = 'false'

" Colors: {{{
augroup ColorschemePreferences
  autocmd!
  autocmd ColorScheme * highlight Normal     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Todo       ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight link ALEErrorSign   WarningMsg
  autocmd ColorScheme * highlight link ALEWarningSign ModeMsg
  autocmd ColorScheme * highlight link ALEInfoSign    Identifier
augroup END

set background=dark
silent! colorscheme gruvbox
" }}}