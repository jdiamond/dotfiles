" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plug')

Plug '/usr/local/opt/fzf' " https://github.com/junegunn/fzf
Plug 'junegunn/fzf.vim' " https://github.com/junegunn/fzf.vim
Plug 'itchyny/lightline.vim' " https://github.com/itchyny/lightline.vim
Plug 'sheerun/vim-polyglot' " https://github.com/sheerun/vim-polyglot
Plug 'tpope/vim-commentary' " https://github.com/tpope/vim-commentary
Plug 'tpope/vim-surround' " https://github.com/tpope/vim-surround
Plug 'tpope/vim-repeat' " https://github.com/tpope/vim-repeat
Plug 'docunext/closetag.vim' " https://github.com/docunext/closetag.vim
Plug 'tpope/vim-sleuth' " https://github.com/tpope/vim-sleuth
Plug 'airblade/vim-gitgutter' " https://github.com/airblade/vim-gitgutter
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-rhubarb' " https://github.com/tpope/vim-rhubarb
Plug 'tpope/vim-unimpaired' " https://github.com/tpope/vim-unimpaired
Plug 'francoiscabrol/ranger.vim' " https://github.com/francoiscabrol/ranger.vim
Plug 'editorconfig/editorconfig-vim' " https://github.com/editorconfig/editorconfig-vim
Plug 'w0rp/ale' " https://github.com/w0rp/ale

call plug#end()

set laststatus=2 " always show status line 
set noshowmode " mode is in lightline so no need to repeat it
set hidden " hide buffers instead of discarding them
set autowrite " write files when switching buffers
set ignorecase " ignore case when searching
set smartcase " override ignorecase if pattern contains uppercase characters
set hlsearch " highlight search matches
set incsearch " search while typing

let mapleader=","

" Disable highlighting search terms:
nmap <Leader>n :nohlsearch<CR>

" ALE options:
let g:ale_sign_column_always=1 " keep sign column open when no errors, avoids jumpy text

" Ranger options:
let g:ranger_map_keys=0 " don't set

" Open Ranger using current file's directory or working directory if no file:
function! OpenRanger()
  if bufname("%") == ""
    RangerWorkingDirectory
  else
    Ranger
  endif
endfunction

" Commands to invoke Ranger:
nmap <Leader>b :Buffers<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>r :call OpenRanger()<CR>

" Duplicate line in normal mode:
noremap <Leader>d yyp
" Duplicate selection in visual mode:
vnoremap <Leader>d y'>p

