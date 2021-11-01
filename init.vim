call plug#begin(stdpath('data') . '/plugged')
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/completion-nvim'
	Plug 'fenetikm/falcon' " colorscheme
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'itchyny/lightline.vim'
	Plug 'ThePrimeagen/vim-be-good'
	Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
	Plug 'nvim-lua/popup.nvim'
	Plug 'ThePrimeagen/harpoon'
	Plug 'tpope/vim-fugitive'
call plug#end()

" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25

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
nnoremap <leader>, :resize +15<CR>
nnoremap <leader>. :resize -15<CR>
nnoremap <leader><leader>, :vertical resize +15<CR>
nnoremap <leader><leader>. :vertical resize -15<CR>

nnoremap <leader>j :lua require("harpoon.ui").nav_file(1)<CR>:
nnoremap <leader>k :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>l :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>m :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>h :lua require("harpoon.mark").add_file()<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:lightline = {
			\ 'solarized': 'wombat',
			\ }
let g:completion_matching_strategy_list = ['exact','substring','fuzzy']


" Using Lua functions
nnoremap <leader>t :lua require("telescope.builtin").builtin()<CR>:
nnoremap <leader>ff :lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg :lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb :lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh :lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fe :lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>ch :lua require('telescope.builtin').lsp_code_actions()<cr>

lua << EOF
	local extcmd = ".cmd"
	local key_map = vim.api.nvim_set_keymap
	if vim.fn.has('unix') == 1 then extcmd = "" end
	require 'lspconfig'.tsserver.setup{
		on_attach = require 'completion'.on_attach,
		cmd = { "typescript-language-server.cmd", "--stdio" },
	}
	require 'lspconfig'.angularls.setup{
		cmd = cmd,
		on_new_config = function(new_config,new_root_dir)
			new_config.cmd = { "ngserver.cmd", "--stdio", "", "--tsProbeLocations",  "--ngProbeLocations", "" }
		end	
	}
EOF

