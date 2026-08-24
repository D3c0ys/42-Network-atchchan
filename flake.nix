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
  };

  outputs = { self, nixpkgs, flake-utils, header42-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        header42-plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "42header";
          version = "unstable";
          src = header42-src;
        };

        neovim42 = pkgs.neovim.override {
          configure = {
            customRC = ''
              syntax on
              filetype plugin indent on

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
            '';
            packages.myPlugins = {
              start = [ header42-plugin ];
            };
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            neovim42
            pkgs.norminette
          ];

          shellHook = ''
            echo "42 dev shell ready:"
            echo "  - nvim: 42header loaded (:Stdheader or <F1> in normal mode)"
            echo "  - norminette: $(norminette --version 2>/dev/null || echo installed)"
            if [ -z "$(git config user.name 2>/dev/null)" ] && [ -z "$USER42" ]; then
              echo "  note: set 'git config user.name/user.email' or \$USER42/\$MAIL42 for header info"
            fi
          '';
        };
      });
}
