{ config, pkgs, ... }:

{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
   
    plugins = with pkgs.vimPlugins; [
      # Appearance & UI
      {
        plugin = gruvbox-nvim;
        type = "lua";
        config = ''
          require('gruvbox').setup({})
          vim.cmd("colorscheme gruvbox")
        '';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup({
            options = { theme = 'gruvbox' }
          })
        '';
      }
    
      # Treesitter
      nvim-treesitter.withAllGrammars
    
      # Language support & UI helpers
      julia-vim
    
      # Code Folding (ufo + promise-async dependency)
      promise-async
      {
        plugin = nvim-ufo;
        type = "lua";
        config = ''
          vim.o.foldcolumn = '1'
          vim.o.foldlevel = 99
          vim.o.foldlevelstart = 99
          vim.o.foldenable = true
    
          require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
            end
          })
        '';
      }
    ];
    
      # Global options & theme
    initLua = ''
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.number = true
      vim.opt.relativenumber = true
    '';
  };
}
