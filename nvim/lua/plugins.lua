return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason.nvim'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-fugitive'
  use 'junegunn/gv.vim'
  use 'neovim/nvim-lspconfig'
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
  }
  use {
  'nvim-tree/nvim-tree.lua',
  requires = { 'nvim-tree/nvim-web-devicons' },
 }
  use {
	'nvim-treesitter/nvim-treesitter',
	run = function()
		local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		ts_update()
	end,
  }
  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'tpope/vim-endwise'
end)
