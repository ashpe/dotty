" Links for easy hopping (!!sh -v):
" ~/.vim/plugin/basics.vim
" ~/.vim/plugin/cygwin-rxvt-broken-function-keys.vim
" ~/.vim/plugin/diff.vim
" ~/.vim/plugin/functionkeys.vim
" ~/.vim/plugin/gpg.vim
" ~/.vim/plugin/keymaps.vim
" ~/.vim/plugin/mail.vim
" ~/.vim/plugin/perl.vim
" ~/.vim/plugin/svn.vim
"
au FileType perl command! -nargs=1 PerlModuleSource :e `perldoc -lm <args>`
au FileType perl setlocal iskeyword+=:
au FileType perl noremap <leader>pm :PerlModuleSource <cword><cr>

autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
au InsertLeave * match TrailingWhitespace /\s\+$/
au BufWinEnter * match TrailingWhitespace /\s\+$/
autocmd BufRead *.wiki set ft=wiki tw=0

au FileType vim set iskeyword+=. iskeyword+=/ iskeyword+=~
set splitright
set ttymouse=xterm2
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set pastetoggle=<F13>
set vb t_vb=
set mouse=a
set exrc
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

" ============================================
" lookupfile.vim
" ============================================
nmap <unique> <silent> <C-S> :LUBufs ^.*<CR>
let g:LookupFile_AlwaysAcceptFirst=1
let g:LookupFile_PreserveLastPattern=0
let g:LookupFile_AllowNewFiles=0
let no_lookupfile_maps=1
" ============================================
" open perl module with gf
" ============================================
autocmd FileType perl set isfname-=-

" ============================================
" surround.vim
" ============================================
" gettextnize texts

" recognize .psgi files as perl
au BufNewFile,BufRead *.psgi set filetype=perl


let g:solarized_termtrans=1
colorscheme solarized
