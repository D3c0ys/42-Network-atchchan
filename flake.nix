{
  description = "42 school dev shell: neovim with the 42header plugin + norminette";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # 42Paris/42header is a plain vim plugin repo (no flake.nix of its own),
    # so we pull it as a raw source input and package it ourselves below.
    header42-src = {
      url = "github:42Paris/42header";
      flake = false;
    };

    # c_formatter_42 is a plain Python project (no flake.nix of its own)
    # either, so pull its source and build it as a Python application below.
    c-formatter-42-src = {
      url = "github:dawnbeen/c_formatter_42";
      flake = false;
    };

    # cacharle/c_formatter_42.vim is the Neovim plugin that wraps the CLI
    # above and provides the :CFormatter42 command / <F2> mapping.
    c-formatter-42-vim-src = {
      url = "github:cacharle/c_formatter_42.vim";
      flake = false;
    };

    # preservim/nerdtree is also a plain vimscript plugin with no flake.nix.
    nerdtree-src = {
      url = "github:preservim/nerdtree";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, header42-src, c-formatter-42-src, c-formatter-42-vim-src, nerdtree-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        header42-plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "42header";
          version = "unstable";
          src = header42-src;
        };

        c-formatter-42 = pkgs.python3Packages.buildPythonApplication {
          pname = "c_formatter_42";
          version = "0.2.8";
          pyproject = true;
          src = c-formatter-42-src;
          build-system = [ pkgs.python3Packages.setuptools ];
          # The package bundles a prebuilt clang-format-linux binary that
          # dynamic-links against libz/libtinfo/libstdc++; patch it to find
          # them in the Nix store instead of assuming an FHS system.
          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ pkgs.zlib pkgs.ncurses pkgs.stdenv.cc.cc.lib ];
          doCheck = false;
        };

        c-formatter-42-vim-plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "c_formatter_42.vim";
          version = "unstable";
          src = c-formatter-42-vim-src;
        };

        nerdtree-plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "nerdtree";
          version = "unstable";
          src = nerdtree-src;
        };

        neovim42 = pkgs.neovim.override {
          configure = {
            customRC = ''
              syntax on
              filetype plugin indent on
	      set number
              " Default colorscheme only defines truecolor (guifg) values for
              " many groups with no cterm fallback, so without this the code
              " renders in plain default-fg with no visible highlighting.
              set termguicolors

              " Classic vim look, transparent background (matches init.lua).
              colorscheme vim
              lua << trim EOF
              local transparent_groups = {
                "Normal", "NormalNC", "NormalFloat",
                "SignColumn", "EndOfBuffer", "LineNr", "FoldColumn",
                "VertSplit", "WinSeparator",
                "StatusLine", "StatusLineNC", "TabLine", "TabLineFill",
                "Pmenu",
              }
              for _, group in ipairs(transparent_groups) do
                vim.api.nvim_set_hl(0, group, { bg = "none" })
              end
              EOF

              " 42header needs your login/email to fill in the header.
              " Prefer git config, fall back to $USER42 / $MAIL42 env vars.
              " let g:user42 = trim(system('git config user.name 2>/dev/null'))
              " let g:mail42 = trim(system('git config user.email 2>/dev/null'))
	      let g:user42 = "atchchan"
	      let g:mail42 = "atchchan@student.42bangkok.com"
              if empty(g:user42)
                let g:user42 = $USER42
              endif
              if empty(g:mail42)
                let g:mail42 = $MAIL42
              endif

              " Legacy :syntax highlighting only covers a handful of groups
              " (String/Comment/Function/...); the default colorscheme is
              " designed around treesitter for everything else (Type,
              " Constant, PreProc, ...), so start it per-buffer here.
              lua << trim EOF
              vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                  pcall(vim.treesitter.start)
                end,
              })
              EOF

              " NERDTree (ported from init.lua)
              nnoremap <C-n> :NERDTreeFocus<CR>
              nnoremap <C-t> :NERDTreeToggle<CR>
              nnoremap <C-f> :NERDTreeFind<CR>
              autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
            '';
            packages.myPlugins = {
              start = [
                header42-plugin
                c-formatter-42-vim-plugin
                nerdtree-plugin
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              ];
            };
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            neovim42
            pkgs.norminette
            c-formatter-42
          ];

          shellHook = ''
            echo "42 dev shell ready:"
            echo "  - nvim: 42header loaded (:Stdheader or <F1> in normal mode)"
            echo "  - norminette: $(norminette --version 2>/dev/null || echo installed)"
            echo "  - c_formatter_42: $(c_formatter_42 --help >/dev/null 2>&1 && echo installed || echo missing)"
            echo "  - nvim: c_formatter_42 loaded (:CFormatter42 or <F2> on c/cpp buffers)"
            echo "  - nvim: NERDTree loaded (<C-n> focus, <C-t> toggle, <C-f> find)"
            if [ -z "$(git config user.name 2>/dev/null)" ] && [ -z "$USER42" ]; then
              echo "  note: set 'git config user.name/user.email' or \$USER42/\$MAIL42 for header info"
            fi
          '';
        };
      });
}
