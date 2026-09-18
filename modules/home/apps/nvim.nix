{
  flake.modules.homeManager.nvim = {
    config,
    pkgs,
    ...
  }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        alejandra # Nix formatter
        clang-tools # C/C++ (clang-format)
        ruff # Python formatter/linter
        julia # Julia runtime (for JuliaFormatter)
      ];

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

        {
          plugin = conform-nvim;
          type = "lua";
          config = ''
                   require("conform").setup({
                     formatters_by_ft = {
                       nix = { "alejandra" },
                       fish = { "fish_indent" },
                       c = { "clang_format" },
                       python = { "ruff_format" },
                       julia = { "juliaformatter" },
                     },
                     format_on_save = {
                       timeout_ms = 1000,
                       lsp_format = "fallback",
                     },
            formatters = {
                       juliaformatter = {
                         command = "julia",
                         args = {
                           "-e",
                           "using JuliaFormatter; format_file(ARGS[1])",
                           "$FILENAME",
                         },
                         stdin = false,
                       },
                     },
                     format_on_save = {
                       timeout_ms = 3000, -- Bumped timeout to account for Julia JIT start-up
                       lsp_format = "fallback",
                     },
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
  };
}
