" unlet! skip_defaults_vim
" source $VIMRUNTIME/defaults.vim

set title

set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab

let g:vimtex_view_method = 'zathura'

set number
set relativenumber

set nocompatible
set smartindent
set nohlsearch
set incsearch
set updatetime=50
set laststatus=2
set noshowmode
set colorcolumn=80
set signcolumn=yes
filetype indent plugin on


" remaps
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz


" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" indent
Plugin 'Vimjas/vim-python-pep8-indent'

call vundle#end()            " required
filetype plugin indent on    " required


" Packer (nvim)
lua require('plugins')

" minha config .lua
lua require('branco/')

"Plug
call plug#begin()

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" if s:using_snippets
"   Plug 'sirver/ultisnips'
" endif

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" The React syntax highlighting and indenting plugin for vim. Also supports
" the typescript tsx file.
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" Vim omnicompletion (intellisense) and more for C# 
Plug 'OmniSharp/omnisharp-vim'
let g:OmniSharp_server_use_mono = 1

" Autocompletion
" Plug 'prabirshrestha/asyncomplete.vim'

" Colorscheme
Plug 'gruvbox-community/gruvbox'

" vimtex
Plug 'lervag/vimtex'

" sleuth for identation
Plug 'tpope/vim-sleuth'

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'
" Mappings, code-actions available flag and statusline integration
Plug 'nickspoons/vim-sharpenup'

" C# Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support 
" Plug 'dense-analysis/ale'
" let g:ale_linters = { 'cs': ['OmniSharp'] }

" rightside file explorer
Plug 'preservim/nerdtree'

" statusline
Plug 'feline-nvim/feline.nvim'

" A vim plugin wrapper for prettier, pre-configured with custom default prettier settings.
Plug 'prettier/vim-prettier', {
\ 'do': 'yarn install --frozen-lockfile --production',
\ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
let g:prettier#config#tab_width = 8
let g:prettier#config#use_tabs = "true"

autocmd FileType tex :CocDisable
autocmd VimEnter * NERDTree | wincmd p

" Initialize plugin system
call plug#end()


" Colors: {{{
augroup ColorschemePreferences
  autocmd!
  " These preferences clear some gruvbox background colours, allowing transparency
  autocmd ColorScheme * highlight Normal     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Todo       ctermbg=NONE guibg=NONE
  " Link ALE sign highlights to similar equivalents without background colours
  autocmd ColorScheme * highlight link ALEErrorSign   WarningMsg
  autocmd ColorScheme * highlight link ALEWarningSign ModeMsg
  autocmd ColorScheme * highlight link ALEInfoSign    Identifier
augroup END

" Use truecolor in the terminal, when it is supported
if has('termguicolors')
  set termguicolors
endif

set background=dark
colorscheme gruvbox
" }}}

" Lightline: {{{
let g:lightline = {
\ 'colorscheme': 'gruvbox',
\ 'active': {
\   'right': [
\     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\     ['lineinfo'], ['percent'],
\     ['fileformat', 'fileencoding', 'filetype', 'sharpenup']
\   ]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent'], ['sharpenup']]
\ },
\ 'component': {
\   'sharpenup': sharpenup#statusline#Build()
\ },
\ 'component_expand': {
\   'linter_checking': 'lightline#ale#checking',
\   'linter_infos': 'lightline#ale#infos',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok'
  \  },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right'
\  }
\}
" Use unicode chars for ale indicators in the statusline
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "
" }}}

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winblend': 30,
  \ 'winhl': 'Normal:Normal,FloatBorder:ModeMsg',
  \ 'border': 'rounded'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0],
  \ 'border': [1],
  \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
  \ 'borderhighlight': ['ModeMsg']
  \}
endif
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

" if s:using_snippets
"   let g:OmniSharp_want_snippet = 1
" endif

let g:OmniSharp_highlight_groups = {
\ 'ExcludedCode': 'NonText'
\}
" }}}

