call plug#begin(stdpath('data') . '/plugged')
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/completion-nvim'
	Plug 'fenetikm/falcon' " colorscheme
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'itchyny/lightline.vim'
call plug#end()

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

colorscheme falcon

set autoread
set colorcolumn=80
set completeopt=menuone,noinsert,noselect
set hidden
set linebreak
au BufRead,BufNewFile *.md setlocal wrap
highlight clear SignColumn
set mouse=a
set number relativenumber
set noshowmode
set nowrap
set shiftwidth=4 tabstop=4 softtabstop=4
set shortmess+=c
set showtabline=0
set termguicolors

let mapleader = "\<space>"

if has('unix')
	nnoremap <leader>se	:e ~/.config/nvim/init.vim<CR>
	nnoremap <leader>ss	:source ~/.config/nvim/init.vim<CR>
else
	nnoremap <leader>se	:e ~/init.vim<CR>
	nnoremap <leader>ss	:source ~/init.vim<CR>
endif

" My custom key bindings
nnoremap <silent>il :<c-u>norm!^vg_<CR>
nnoremap <silent><C-h> :nohl<CR>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>, :resize +15<CR>
nnoremap <leader>. :resize -15<CR>
nnoremap <leader><leader>, :vertical resize +15<CR>
nnoremap <leader><leader>. :vertical resize -15<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:lightline = {
			\ 'solarized': 'wombat',
			\ }
let g:completion_matching_strategy_list = ['exact','substring','fuzzy']


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

