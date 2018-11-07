let g:syntastic_ocaml_checkers = ['merlin']

" Enable vim-plug
call plug#begin('~/.vim/plugged')

" Syntastic quick syntax checker
Plug 'scrooloose/syntastic'

" Airline status bar
Plug 'vim-airline/vim-airline'

" Ctrl+p quick search
Plug 'kien/ctrlp.vim'

" YouCompleteMe autocompletion
Plug 'valloric/youcompleteme'

" NERDcommenter quick comment/uncomment
Plug 'scrooloose/nerdcommenter'

" TMUX integration
Plug 'christoomey/vim-tmux-navigator'

" Auto formatter
Plug 'sbdchd/neoformat'

" Start plugins
call plug#end()

" Enable Pathogen bundle management
" call pathogen#infect() 

" Turn on syntax highlighting
syn on

" Turn on filetype recognition
filetype plugin indent on

" convert tabs to spaces
set et

" tabstop is 2
set ts=2

" shiftwidth is 2
set sw=2

" Enable status bar
set laststatus=2

" Ensure 5 lines above an below cursor are on screen
set scrolloff=5

" Allow backspace
set backspace=indent,eol,start

" Enable airline powerline fonts
let g:airline_powerline_fonts = 1

" Set the color scheme
colorscheme koehler

" Enable the appropriate font for vim gui
set guifont=Source\ Code\ Pro\ for\ Powerline:h14

" Start with all folds open
set foldlevel=99

" Turn off confirmation for loading project-specific YCM configuration
let g:ycm_confirm_extra_conf=0

" Enable ocp-indent of OCaml code
" set runtimepath^="/Users/cox/.opam/4.02.3/share/ocp-indent/vim"

" Add support for atd files

au BufNewFile,BufRead *.atd setlocal ft=ocaml
au BufNewFile,BufRead *.atd let b:syntastic_skip_checks = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""" Restore cursor location after exit """""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
"     execute "set rtp+=" . g:opamshare . "/merlin/vim"
"     execute "set rtp+=" . g:opamshare . "/ocp-indent/vim"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""" Add support for displaying OCaml type information """""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 
" Lookup type annotation at cursor position in *.annot file.
" The name for the annot file is derived from the buffer name.

" function! OCamlType()
"     let col  = col('.')
"     let line = line('.')
"     let file = expand("%:p:r")
"     echo system("annot -n -type " . line . " " . col . " " . file . ".annot")
" endfunction    
" map ,t :call OCamlType()<return>

let mapleader="\\"
let maplocalleader=","
map <C-c> <Plug>NERDCommenterToggle

" configure file ignoring
set wildignore+=*/_build/*,*.o,*.swp,*.a,*.cmi,*.cmo,*.cmx,*.cmt,*.annot,*.dylib,*.cmxa

" Auto format on save
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * undojoin | Neoformat
"augroup END

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## d9ef460601f404e0dd6cb1a2a274458e ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/Users/arlencox/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
