return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason.nvim'
  use 'neovim/nvim-lspconfig'
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
 }
end)
