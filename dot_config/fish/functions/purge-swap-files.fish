function purge_swap_files -d "Purges all swap files in neovim's swap file folder"
  rm ~/.local/state/nvim/swap/*
end
