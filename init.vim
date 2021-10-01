syntax on

let mapleader = "\<space>"
if has('unix')
	nnoremap <leader>se	:e ~/.config/nvim/init.vim<CR>
	nnoremap <leader>ss	:source ~/.config/nvim/init.vim<CR>
else
	nnoremap <leader>se	:e ~\AppData\Local\nvim\init.vim<CR>
	nnoremap <leader>ss	:source ~\AppData\Local\nvim\init.vim<CR>
endif
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>, :resize +15<CR>
nnoremap <leader>. :resize -15<CR>
nnoremap <leader><leader>, :vertical resize +15<CR>
nnoremap <leader><leader>. :vertical resize -15<CR>
set hidden
set nocompatible
set encoding=utf-8
set showtabline=0
set noshowmode
set nowrap
set linebreak
au BufRead,BufNewFile *.md setlocal wrap
set autoread
set shiftwidth=4 tabstop=4 softtabstop=4
set colorcolumn=80
highlight ColorColumn ctermbg=55 guibg=lightgrey
highlight clear SignColumn
set mouse=a
set number relativenumber
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
set completeopt=menuone,noinsert,noselect
let g:lightline = {
			\ 'solarized': 'wombat',
			\ }
let g:completion_matching_strategy_list = ['exact','substring','fuzzy']

call plug#begin(stdpath('data') . '/plugged')
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'vim-ctrlspace/vim-ctrlspace'
	Plug 'nvim-lua/completion-nvim'
	Plug 'fenetikm/falcon' " colorscheme
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'itchyny/lightline.vim'
call plug#end()

colorscheme falcon
set termguicolors
highlight statusline guibg=pink guifg=purple

nnoremap <silent><C-p> :CtrlSpace<CR>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fe <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>ch <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>

lua << EOF
	local extcmd = ".cmd"
	if vim.fn.has('unix') == 1 then extcmd = "" end
	require 'lspconfig'.tsserver.setup{
		on_attach = require 'completion'.on_attach,
		cmd = { "typescript-language-server" .. extcmd, "--stdio" },
	}
	
	local cmd = { "ngserver" .. extcmd, "--stdio", "", "--tsProbeLocations",  "--ngProbeLocations", "" }
	require 'lspconfig'.angularls.setup{
		cmd = cmd,
		on_new_config = function(new_config,new_root_dir)
			new_config.cmd = cmd
		end	
	}
EOF

