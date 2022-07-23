let mapleader = " "
nmap <bs> <space>
vmap <bs> <space>

inoremap jk <esc>
nnoremap <leader>mch :set cursorline! cursorcolumn!<cr>
nnoremap <leader>mdln ivim: ft= fdm= fmr=
nnoremap <leader>mhl :set hlsearch!<cr>
nnoremap <leader>mln :set number!<cr>
nnoremap <leader>mwr :set wrap!<cr>
nnoremap <leader>n :tabn<cr>
nnoremap <leader>p :tabp<cr>
nnoremap <leader>q :qa!<cr>
nnoremap <leader>sa ggVG
nnoremap <leader>so :source ~/.config/nvim/init.lua<cr>
nnoremap <leader>w :wa<cr>
nnoremap <leader>xb :bdelete<cr>
nnoremap <leader>xt :tabc<cr>
nnoremap <leader>z :wqa!<cr>
nnoremap Y yy
vnoremap <leader>@ :norm @q<cr>
vnoremap <leader>r :!rev<cr>
vnoremap <leader>s :sort<cr>
