syntax on
let $nix_nvimpath = "~/.config/nvim/"
let $win_nvimpath = "~\\AppData\\Local\\nvim\\"
set noswapfile
let mapleader = "\<space>"
if has('unix')
	set backupdir=$nix_nvimpathbackup
	set directory=$nix_nvimpathswap
	set undodir=$nix_nvimpathundo
	nnoremap <leader>ev	:e $nix_nvimpathinit.vim<CR>
	nnoremap <leader>S	:source $nix_nvimpathinit.vim<CR>
else
	set backupdir=$win_nvimpathbackup
	set directory=$win_nvimpathswap
	set undodir=$win_nvimpathundo
	nnoremap <leader>ev	:e $win_nvimpathinit.vim<CR>
	nnoremap <leader>S	:source $win_nvimpathinit.vim<CR>
endif
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
let g:completion_matching_strategy_list = ['exact','substring','fuzzy']

call plug#begin(stdpath('data') . '/plugged')
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/completion-nvim'
	Plug 'fenetikm/falcon' " colorscheme
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

colorscheme falcon
set termguicolors

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

