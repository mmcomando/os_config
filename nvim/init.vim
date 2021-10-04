
set ignorecase
set smartcase
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set number
set relativenumber
" set wildmode=longest,list
set cc=120
set mouse=a
set clipboard^=unnamed,unnamedplus
" set clipboard=unnamedplus
" filetype plugin on
set cursorline
set hidden
set autoread

set listchars=tab:→\ ,eol:↲,space:•
set list
set scrolloff=20




call plug#begin('~/.vim/plugged')
Plug 'dracula/vim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'vim-airline/vim-airline'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'airblade/vim-rooter'
Plug 'cljoly/telescope-repo.nvim'
Plug 'preservim/nerdcommenter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'alexaandru/nvim-lspupdate'
Plug 'neovim/nvim-lspconfig'
"Plug 'williamboman/nvim-lsp-installer'
call plug#end()



lua << EOF
--require'lspconfig'.serve_d.setup{}
EOF


au! BufWritePost ~/.config/nvim/*.{vim,lua} so $MYVIMRC


nmap <C-_> <plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
"map <C-/> <plug>NERDCommenterCommen
" Reload nvim config
nnoremap <leader>sss :e $MYVIMRC<CR>
nnoremap <leader>ss :source $MYVIMRC<CR>

nnoremap <SPACE> <Nop>
map <Space> <Leader>

let g:airline#extensions#tabline#enabled = 1

colorscheme dracula

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
noremap <S-n> <C-O>
noremap <S-o> <C-I>
noremap <S-e> <C-d>
noremap <S-i> <C-u>
noremap , i
noremap o l
noremap i k
noremap e j
noremap n h
vnoremap , I
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fe <cmd>Telescope file_browser<cr>

nnoremap <leader>fp <cmd>Telescope repo list<cr>
" let g:rooter_cd_cmd = 'tcd'
let g:rooter_patterns = ['.git/']
let g:airline_section_b = "%{getcwd()}"
lua << EOF
 require('telescope').setup{
  defaults = {
      mappings = {
          i = {
            ["<S-e>"] = require('telescope.actions').move_selection_next,
            ["<S-i>"] = require('telescope.actions').move_selection_previous,
          },
          n = {
            ["e"] = require('telescope.actions').move_selection_next,
            ["i"] = require('telescope.actions').move_selection_previous,
          },
        }
    }
}


EOF

