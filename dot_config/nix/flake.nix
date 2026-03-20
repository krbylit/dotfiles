{
  description = "Declarative user environment for Linux systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.buildEnv {
            name = "user-env";
            paths = with pkgs; [

              # ── Shell & Terminal ───────────────────────────────────────
              fish
              starship
              tmux
              atuin
              zoxide

              # ── File Navigation ───────────────────────────────────────
              eza # modern ls
              fd # modern find
              fzf
              joshuto # file manager TUI
              tree
              television # TUI fuzzy finder

              # ── Text Processing & Search ──────────────────────────────
              bat
              bat-extras # batgrep, batman, batpipe, etc.
              ripgrep
              jq
              jql # JSON query language
              miller # mlr — CSV/JSON/tabular data swiss army knife
              sad # modern sed
              ast-grep # structural code search

              # ── Version Control ───────────────────────────────────────
              git
              delta # git diff viewer (git-delta)
              lazygit
              gh
              hub
              gitleaks
              gitflow
              lefthook

              # ── Languages & Build Tools ───────────────────────────────
              go
              lua
              luajit
              luarocks
              cmake
              llvm
              maven

              # ── Formatters & Linters ──────────────────────────────────
              stylua
              shfmt
              prettierd
              prettier
              markdownlint-cli
              tree-sitter

              # ── JavaScript / Node ─────────────────────────────────────
              fnm # fast node manager
              bun
              pnpm
              yarn

              # ── Python ────────────────────────────────────────────────
              uv
              pipx

              # ── Code Analysis ─────────────────────────────────────────
              tokei # code statistics
              eva # calculator REPL
              eget # GitHub binary installer

              # ── Cloud & Infrastructure ────────────────────────────────
              awscli2
              terraform
              terragrunt
              terrascan
              tflint

              # ── Containers & CI ───────────────────────────────────────
              act # run GitHub Actions locally
              lazydocker
              kdash # Kubernetes TUI

              # ── Database ──────────────────────────────────────────────
              dolt # git for data
              mongosh
              postgresql # psql, pg_dump, etc.

              # ── Network & Security ────────────────────────────────────
              doggo # DNS client
              gping
              mosh
              mtr
              trippy # network diagnostics TUI
              tailscale
              termshark # Wireshark TUI
              wireshark-cli # tshark and CLI tools
              gnupg

              # ── System Monitoring ─────────────────────────────────────
              bottom # btm
              btop
              procs # modern ps
              dust # modern du

              # ── File Transfer ─────────────────────────────────────────
              termscp # SCP/SFTP TUI

              # ── Documents & Media ─────────────────────────────────────
              pandoc
              graphviz
              imagemagick
              chafa # terminal image viewer
              ffmpegthumbnailer
              poppler-utils # pdftotext, pdfinfo, etc.
              qpdf
              vhs # terminal GIF recorder
              glow # terminal markdown viewer

              # ── Misc CLI ──────────────────────────────────────────────
              chezmoi
              aichat # LLM CLI
              wget
              p7zip
              lolcat
              toilet # ASCII art text
              highlight # syntax highlighting
              tlrc # tldr client
              fselect # SQL-like file queries
              fontforge
              nb # notebook CLI

              # ── Additional tools confirmed in nixpkgs ───────────────
              bob-nvim # neovim version manager
              serpl # search/replace TUI
              sq # data wrangling tool
              ssh-vault # SSH encrypt/decrypt
              mole # SSH tunnel tool
              hoard # CLI command organizer
              atac # API testing TUI

              # ── Not in nixpkgs — install via cargo/go/binary ──────────
              # beads           → brew tap steveyegge/beads
              # gitwatch        → installed separately
              # gobackup        → go install github.com/gobackup/gobackup
              # duck            → download from duck.sh
              # gastown         → go install
              # whosthere       → go install
            ];

            extraOutputsToInstall = [
              "man"
              "doc"
            ];

            pathsToLink = [
              "/bin"
              "/share"
              "/etc"
            ];
          };
        }
      );
    };
}
