function! PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('tpope/vim-sensible')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-rhubarb')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('tpope/vim-surround')
  call minpac#add('dense-analysis/ale')
  call minpac#add('vim-test/vim-test')
  call minpac#add('preservim/nerdtree')
  call minpac#add('Xuyuanp/nerdtree-git-plugin')
  call minpac#add('ryanoasis/vim-devicons')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('mg979/vim-visual-multi', { 'branch': 'master' })
  call minpac#add('mattn/emmet-vim')
  call minpac#add('junegunn/fzf', { 'do': { -> fzf#install() }})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('catppuccin/vim', { 'as': 'catppuccin' })
endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

set termguicolors
set background=dark
colorscheme catppuccin_mocha

set noshowmode
set showtabline=2
let g:lightline = {
\   'colorscheme': 'catppuccin_mocha',
\   'active': {
\     'left': [
\       ['mode', 'paste'],
\       ['gitbranch', 'readonly', 'filename', 'modified']
\     ],
\     'right': [
\       ['lineinfo'],
\       ['percent'],
\       ['fileformat', 'fileencoding', 'filetype']
\     ]
\   },
\   'component_function': {
\     'gitbranch': 'FugitiveHead'
\   }
\ }
let g:NERDTreeGitStatusUseNerdFonts = 1

set encoding=utf-8

let mapleader = " "

set nobackup
set nowritebackup
set noswapfile
set showcmd     " display incomplete commands
set autowrite   " automatically :write before running commands
set modelines=0 " disable modelines as a security precaution

let g:has_async = v:version >= 800 || has('nvim')

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile
    \ aliases.local,
    \ zshenv.local,zlogin.local,zlogout.local,zshrc.local,zprofile.local,
    \ */zsh/configs/*
    \ set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    autocmd VimEnter *
      \ set updatetime=1000 |
      \ let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0)
    autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "NeoVim or Vim 8 required"
  endif
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Automatic toggling between 'hybrid' and absolute line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Always use vertical diffs
set diffopt+=vertical

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" fzf.vim
nnoremap <C-p> :Files<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
