# CLI/TUI Program Inventory and Reproducibility Audit

_Generated on 2026-03-16 from configured PATH locations, Homebrew metadata, Cargo installs, uv tools, npm globals, and chezmoi installation sources._

## Scope

- PATH scan is limited to the explicit directories declared in [dot_config/fish/exact_conf.d/\_fish_1_path_config.fish](/Users/kirbylittle/.local/share/chezmoi/dot_config/fish/exact_conf.d/_fish_1_path_config.fish). I did not try to inventory every built-in macOS command inherited from the system PATH.
- Inventory focuses on third-party CLI/TUI tools, terminal-centric apps, and package-manager helpers that matter for reproducibility on another machine.
- `managed` means the tool is declared in chezmoi install sources. `unmanaged` means it is installed now but not declared anywhere I found. `conditional` means the install script only declares it for a different environment profile, such as SSH/Linux.

## High-Level Summary

- Installed inventory captured: 231 distinct tools.
- Install sources reviewed: Brewfile, the main post-Homebrew install script, uv tool config, and the fish PATH config.
- Unmanaged items found: 0 Homebrew leaves, 24 Cargo crates, 4 uv tools, 1 npm global, and 9 PATH-local binaries.
- Command name collisions in configured PATH: 19 (`bd`, `cargo`, `cargo-clippy`, `cargo-fmt`, `clippy-driver`, `codex`, `gt`, `pip3`, `pip3.13`, `pipx`, `python3`, `python3.13`, `rust-gdb`, `rust-gdbgui`, `rust-lldb`, `rustc`, `rustdoc`, `rustfmt`, `rustup`).

## Feature Highlights

- `aichat`, `codex`, `claude-code`, `claude-code-acp`, `mcp-probe`, and `specify-cli` make the machine especially strong for terminal-native AI and agent workflows.
- `yazi`, `joshuto`, `trex`, `eza`, `fzf`, and `zoxide` cover quick navigation, fuzzy selection, and full-screen TUI file management.
- `lazygit`, `git-delta`, `gitwatch`, `gitleaks`, `lefthook`, `gh`, `gh-dash`, and `gh-enhance` form a deep Git and GitHub workflow stack.
- Infra and networking coverage is broad: `act`, `lazydocker`, `terraform`, `terragrunt`, `terrascan`, `tflint`, `tailscale`, `termshark`, `trippy`, `ngrok`, and `session-manager-plugin`.
- The main reproducibility gaps are experimental Cargo crates, a few npm globals, and several manually dropped binaries in `~/.local/bin`.

## Inventory by Purpose

### AI and Agent Tooling

| Tool              | Summary                                                                   | Source           | Status    |
| ----------------- | ------------------------------------------------------------------------- | ---------------- | --------- |
| `aichat`          | All-in-one AI-Powered CLI Chat & Copilot                                  | Homebrew formula | managed   |
| `claude-code-acp` | Anthropic Claude Code integration for Zed/ACP workflows.                  | npm -g           | managed   |
| `codex`           | OpenAI Codex CLI.                                                         | npm -g           | unmanaged |
| `gh-copilot`      | GitHub Copilot extension for gh.                                          | gh extension     | unmanaged |
| `mcp-probe`       | Interactive CLI debugger and TUI for MCP (Model Context Protocol) servers | Homebrew formula | managed   |
| `specify-cli`     | Spec Kit CLI for structured specification workflows. Commands: `specify`. | uv tool          | managed   |

### Shells, Terminals, and Runtimes

| Tool            | Summary                                                             | Source           | Status    |
| --------------- | ------------------------------------------------------------------- | ---------------- | --------- |
| `atuin`         | Improved shell history for zsh, bash, fish and nushell              | Homebrew formula | managed   |
| `bob`           | Version manager for neovim                                          | Homebrew formula | managed   |
| `fish`          | User-friendly command-line shell for UNIX-like operating systems    | Homebrew formula | managed   |
| `fnm`           | Fast and simple Node.js version manager                             | Homebrew formula | managed   |
| `ghostty`       | Terminal emulator that uses platform-native UI and GPU acceleration | Homebrew cask    | managed   |
| `kitty@nightly` | GPU-based terminal emulator                                         | Homebrew cask    | managed   |
| `nvm`           | Manage multiple Node.js versions                                    | Homebrew formula | managed   |
| `rustup`        | Rust toolchain installer                                            | Homebrew formula | managed   |
| `starship`      | Cross-shell prompt for astronauts                                   | Homebrew formula | managed   |
| `tmux`          | Terminal multiplexer                                                | Homebrew formula | managed   |
| `zellij`        | Terminal workspace and multiplexer.                                 | cargo install    | unmanaged |

### Files and Navigation

| Tool         | Summary                                                        | Source              | Status  |
| ------------ | -------------------------------------------------------------- | ------------------- | ------- |
| `dust`       | More intuitive version of du in rust                           | Homebrew formula    | managed |
| `eza`        | Modern, maintained replacement for ls                          | Homebrew formula    | managed |
| `fd`         | Simple, fast and user-friendly alternative to find             | Homebrew formula    | managed |
| `fselect`    | Find files with SQL-like queries                               | Homebrew formula    | managed |
| `fzf`        | Command-line fuzzy finder written in Go                        | Homebrew formula    | managed |
| `joshuto`    | Ranger-like terminal file manager written in Rust              | Homebrew formula    | managed |
| `television` | General purpose fuzzy finder TUI                               | Homebrew formula    | managed |
| `tree`       | Display directories as trees (with optional color/HTML output) | Homebrew formula    | managed |
| `trex`       | Terminal file explorer.                                        | Brewfile go install | managed |
| `ya`         | Yazi companion binary.                                         | PATH local binary   | managed |
| `yazi`       | Terminal file manager.                                         | PATH local binary   | managed |
| `zoxide`     | Shell extension to navigate your filesystem faster             | Homebrew formula    | managed |
| `mcdu`       | Disk/storage usage monitor and cleaner                         | Homebrew formula    | managed |

### Git and Source Control

| Tool         | Summary                                                                      | Source            | Status    |
| ------------ | ---------------------------------------------------------------------------- | ----------------- | --------- |
| `act`        | Run your GitHub Actions locally                                              | Homebrew formula  | managed   |
| `dolt`       | Git for Data                                                                 | Homebrew formula  | managed   |
| `eget`       | Easily install prebuilt binaries from GitHub                                 | Homebrew formula  | managed   |
| `gh`         | GitHub command-line tool                                                     | Homebrew formula  | managed   |
| `gh-dash`    | GitHub dashboard extension for gh.                                           | gh extension      | managed   |
| `gh-enhance` | Extra gh UX commands and enhancements.                                       | gh extension      | managed   |
| `git-delta`  | Syntax-highlighting pager for git and diff output                            | Homebrew formula  | managed   |
| `git-flow`   | Extensions to follow Vincent Driessen's branching model                      | Homebrew formula  | managed   |
| `gitlogue`   | A Git history screensaver - watch your code rewrite itself                   | Homebrew formula  | managed   |
| `gittype`    | Analyze repository composition and Git activity by file type.                | cargo install     | managed   |
| `gitwatch`   | Watch a file or folder and automatically commit changes to a git repo easily | Homebrew formula  | managed   |
| `hub`        | Add GitHub support to git on the command-line                                | Homebrew formula  | managed   |
| `lazygit`    | Simple terminal UI for git commands                                          | Homebrew formula  | managed   |
| `lazytail`   | TUI log viewer with lazygit-style interactions.                              | PATH local binary | unmanaged |
| `lefthook`   | Fast and powerful Git hooks manager for any type of projects                 | Homebrew formula  | managed   |
| `tracker`    | Terminal tracker utility from a Git checkout.                                | cargo install     | unmanaged |

### Development, Build, and Code Quality

| Tool                         | Summary                                                           | Source           | Status    |
| ---------------------------- | ----------------------------------------------------------------- | ---------------- | --------- |
| `ast-grep`                   | Code searching, linting, rewriting                                | Homebrew formula | managed   |
| `eslint`                     | AST-based pattern checker for JavaScript                          | Homebrew formula | managed   |
| `eslint_d`                   | Speed up eslint to accelerate your development workflow           | Homebrew formula | managed   |
| `glow`                       | Render markdown on the CLI                                        | Homebrew formula | managed   |
| `highlight`                  | Convert source code to formatted text with syntax highlighting    | Homebrew formula | managed   |
| `markdownlint-cli`           | CLI for Node.js style checker and lint tool for Markdown files    | Homebrew formula | managed   |
| `mdbook`                     | Create books and long-form docs from Markdown.                    | cargo install    | unmanaged |
| `neovim-remote`              | Remote control client for Neovim. Commands: `nvr`.                | uv tool          | managed   |
| `pre-commit`                 | Framework for managing and running pre-commit hooks.              | uv tool          | managed   |
| `prettier`                   | Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML | Homebrew formula | managed   |
| `prettierd`                  | Prettier daemon                                                   | Homebrew formula | managed   |
| `ruff`                       | Python linter and formatter.                                      | uv tool          | managed   |
| `ruff-lsp`                   | Language server wrapper around Ruff.                              | uv tool          | managed   |
| `stylua`                     | Opinionated Lua code formatter                                    | Homebrew formula | managed   |
| `tokei`                      | Program that allows you to count code, quickly                    | Homebrew formula | managed   |
| `typescript`                 | TypeScript compiler and language tooling.                         | npm -g           | managed   |
| `typescript-language-server` | Language Server Protocol bridge for TypeScript.                   | npm -g           | managed   |
| `yapf`                       | Python formatter. Commands: `yapf`, `yapf-diff`.                  | uv tool          | managed   |

### Infrastructure and Containers

| Tool                 | Summary                                                                 | Source           | Status  |
| -------------------- | ----------------------------------------------------------------------- | ---------------- | ------- |
| `inkdrop-visualizer` | Visualize your Terraform configuration and plan as a graph              | Homebrew formula | managed |
| `kdash`              | A fast and simple dashboard for Kubernetes written in Rust              | Homebrew formula | managed |
| `lazydocker`         | Lazier way to manage everything docker                                  | Homebrew formula | managed |
| `taproom`            | Interactive TUI for Homebrew                                            | Homebrew formula | managed |
| `terraform`          | Terraform                                                               | Homebrew formula | managed |
| `terragrunt`         | Thin wrapper for Terraform e.g. for locking state                       | Homebrew formula | managed |
| `terrascan`          | Detect compliance and security violations across Infrastructure as Code | Homebrew formula | managed |
| `tflint`             | Linter for Terraform files                                              | Homebrew formula | managed |
| `tftui`              | Terminal-based textual UI for Terraform                                 | Homebrew formula | managed |

### Networking, Cloud, and Remote Access

| Tool                     | Summary                                                                        | Source              | Status    |
| ------------------------ | ------------------------------------------------------------------------------ | ------------------- | --------- |
| `aws-shell`              | Integrated shell for working with the AWS CLI                                  | Homebrew formula    | managed   |
| `awscli`                 | Official Amazon AWS command-line interface                                     | Homebrew formula    | managed   |
| `cfn-lint`               | CloudFormation linter.                                                         | uv tool             | managed   |
| `claws`                  | Terminal UI for AWS resource management                                        | Homebrew formula    | managed   |
| `dnslookup`              | Simple command-line utility to make DNS lookups using any protocol             | Homebrew formula    | managed   |
| `doggo`                  | Command-line DNS Client for Humans                                             | Homebrew formula    | managed   |
| `filessh`                | SSH-oriented terminal file browser.                                            | cargo install       | managed   |
| `gobackup`               | CLI tool for backup your databases, files to cloud storages                    | Homebrew formula    | managed   |
| `jocalsend`              | Local network file sharing TUI.                                                | cargo install       | managed   |
| `lazyssh`                | A simple terminal UI for managing SSH connections.                             | Homebrew formula    | managed   |
| `mosh`                   | Remote terminal application                                                    | Homebrew formula    | managed   |
| `mtr`                    | `traceroute` and `ping` in a single tool                                       | Homebrew formula    | managed   |
| `ngrok`                  | Reverse proxy, secure introspectable tunnels to localhost                      | Homebrew cask       | managed   |
| `rustnet-monitor`        | Terminal network monitor. Commands: `rustnet`.                                 | cargo install       | managed   |
| `session-manager-plugin` | Plugin for AWS CLI to start and end sessions that connect to managed instances | Homebrew cask       | managed   |
| `snitch`                 | Prettier way to inspect network connections                                    | Homebrew formula    | managed   |
| `ssh-list`               | List and inspect SSH hosts/config from the terminal.                           | cargo install       | unmanaged |
| `surge`                  | Network toolbox                                                                | Homebrew cask       | managed   |
| `tailscale`              | Easiest, most secure way to use WireGuard and 2FA                              | Homebrew formula    | managed   |
| `taws`                   | Terminal UI for AWS                                                            | Homebrew formula    | managed   |
| `termshark`              | Terminal UI for tshark, inspired by Wireshark                                  | Homebrew formula    | managed   |
| `trippy`                 | Network diagnostic tool, inspired by mtr                                       | Homebrew formula    | managed   |
| `whosthere`              | LAN discovery tool with a modern TUI written in Go                             | Homebrew formula    | managed   |
| `xfr`                    | Modern network bandwidth testing with TUI - iperf3 replacement                 | Homebrew formula    | managed   |
| `ziina`                  | CLI remote-control utility for the Ziina media player.                         | Brewfile go install | managed   |

### Data, Databases, and Querying

| Tool                | Summary                                                                                                                                                                                                 | Source              | Status    |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- | --------- |
| `csvi`              | CSV inspector and converter for terminal workflows.                                                                                                                                                     | Brewfile go install | managed   |
| `csvkit`            | Suite of CSV command-line utilities. Commands: `csvclean`, `csvcut`, `csvformat`, `csvgrep`, `csvjoin`, `csvjson`, `csvlook`, `csvpy`, `csvsort`, `csvsql`, `csvstack`, `csvstat`, `in2csv`, `sql2csv`. | uv tool             | unmanaged |
| `csvlint`           | CSV validation CLI.                                                                                                                                                                                     | cargo install       | unmanaged |
| `jiq`               | Interactive JSON query tool with real-time output                                                                                                                                                       | Homebrew formula    | managed   |
| `jq`                | Lightweight and flexible command-line JSON processor                                                                                                                                                    | Homebrew formula    | managed   |
| `jql`               | JSON query language CLI tool                                                                                                                                                                            | Homebrew formula    | managed   |
| `libpq`             | Postgres C API library                                                                                                                                                                                  | Homebrew formula    | managed   |
| `miller`            | Like sed, awk, cut, join & sort for name-indexed data such as CSV                                                                                                                                       | Homebrew formula    | managed   |
| `mongodb-community` | High-performance, schema-free, document-oriented database                                                                                                                                               | Homebrew formula    | managed   |
| `oq`                | jq-like processor for CSV, JSON, TOML, and YAML.                                                                                                                                                        | Brewfile go install | managed   |
| `qo`                | Query JSON data with SQL                                                                                                                                                                                | Homebrew formula    | managed   |
| `vi-mongo`          | Terminal User Interface for MongoDB                                                                                                                                                                     | Homebrew formula    | managed   |

### System Monitoring and Performance

| Tool                  | Summary                                                                       | Source              | Status      |
| --------------------- | ----------------------------------------------------------------------------- | ------------------- | ----------- |
| `bandwhich`           | Terminal bandwidth utilization monitor.                                       | PATH local binary   | unmanaged   |
| `bottom`              | Yet another cross-platform graphical process/system monitor                   | Homebrew formula    | managed     |
| `btop`                | Resource monitor. C++ version and continuation of bashtop and bpytop          | Homebrew formula    | managed     |
| `cmdperf`             | Command Performance Benchmarking                                              | Homebrew cask       | managed     |
| `dcv`                 | Docker Compose Viewer - A TUI tool for monitoring Docker Compose applications | Homebrew formula    | managed     |
| `jolt`                | Terminal-based battery and energy monitor for macOS and Linux                 | Homebrew formula    | managed     |
| `killport-tui`        | TUI for finding and killing processes bound to ports. Commands: `kp`.         | cargo install       | unmanaged   |
| `mq`                  | A jq-like command-line tool for Markdown processing                           | Homebrew formula    | managed     |
| `oha`                 | HTTP load generator and benchmarking CLI.                                     | cargo install       | unmanaged   |
| `ports-cli`           | View and manage open ports from the terminal. Commands: `ports`.              | cargo install       | unmanaged   |
| `procs`               | Modern replacement for ps written in Rust                                     | Homebrew formula    | managed     |
| `systemd-manager-tui` | Interactive TUI for systemd services.                                         | cargo install       | conditional |
| `toktop`              | Tokio-powered terminal process/system monitor.                                | cargo install       | unmanaged   |
| `tuios`               | macOS system information TUI.                                                 | Brewfile go install | managed     |

### Security and Secrets

| Tool            | Summary                                                           | Source           | Status    |
| --------------- | ----------------------------------------------------------------- | ---------------- | --------- |
| `1password-cli` | Command-line interface for 1Password                              | Homebrew cask    | managed   |
| `cargo-audit`   | Audit Cargo.lock dependencies for known RustSec vulnerabilities.  | cargo install    | unmanaged |
| `cargo-deny`    | Check Cargo dependency graphs for licenses, bans, and advisories. | cargo install    | unmanaged |
| `cargo-vet`     | Supply-chain auditing tool for Rust dependencies.                 | cargo install    | unmanaged |
| `comply`        | Compliance automation framework, focused on SOC2                  | Homebrew formula | managed   |
| `gitleaks`      | Audit git repos for secrets                                       | Homebrew formula | managed   |
| `hoard`         | Cross-platform command organizer written in Rust                  | Homebrew formula | managed   |
| `sq`            | Data wrangler with jq-like query language                         | Homebrew formula | managed   |
| `ssh-vault`     | Encrypt/decrypt using SSH keys                                    | Homebrew formula | managed   |

### Media, Docs, and Presentation

| Tool                  | Summary                                                                         | Source           | Status  |
| --------------------- | ------------------------------------------------------------------------------- | ---------------- | ------- |
| `chafa`               | Versatile and fast Unicode/ASCII/ANSI graphics renderer                         | Homebrew formula | managed |
| `ffmpegthumbnailer`   | Create thumbnails for your video files                                          | Homebrew formula | managed |
| `fontforge`           | Command-line outline and bitmap font editor/converter                           | Homebrew formula | managed |
| `graphviz`            | Graph visualization software from AT&T and Bell Labs                            | Homebrew formula | managed |
| `lolcat`              | Rainbows and unicorns in your console!                                          | Homebrew formula | managed |
| `pngpaste`            | Paste PNG into files                                                            | Homebrew formula | managed |
| `poppler`             | PDF rendering library (based on the xpdf-3.0 code base)                         | Homebrew formula | managed |
| `qpdf`                | Tools for and transforming and inspecting PDF files                             | Homebrew formula | managed |
| `switchaudio-osx`     | Change macOS audio source from the command-line                                 | Homebrew formula | managed |
| `terminaltexteffects` | Animated text effects for the terminal. Commands: `terminaltexteffects`, `tte`. | uv tool          | managed |
| `toilet`              | Color-based alternative to figlet (uses libcaca)                                | Homebrew formula | managed |
| `vhs`                 | Your CLI home video recorder                                                    | Homebrew formula | managed |

### Utilities and Productivity

| Tool                     | Summary                                                                                  | Source                           | Status    |
| ------------------------ | ---------------------------------------------------------------------------------------- | -------------------------------- | --------- |
| `alerter`                | macOS notification CLI; send native notifications and capture user interactions          | Homebrew formula                 | managed   |
| `amp`                    | Terminal text editor and pager-style tool.                                               | PATH local binary                | unmanaged |
| `atac`                   | Simple API client (Postman-like) in your terminal                                        | Homebrew formula                 | managed   |
| `bagels`                 | Python CLI package installed with uv.                                                    | uv tool                          | managed   |
| `basalt-tui`             | Terminal UI for Basalt-related workflows. Commands: `basalt`.                            | cargo install                    | unmanaged |
| `bat-extras`             | Bash scripts that integrate bat with various command-line tools                          | Homebrew formula                 | managed   |
| `bbrew`                  | Modern TUI for managing Homebrew packages and casks on macOS and Linux                   | Homebrew formula                 | managed   |
| `bd`                     | Beads CLI for issue and task management.                                                 | Brewfile go install              | managed   |
| `beads-web-darwin-arm64` | Local Beads-related binary for web workflows.                                            | PATH local binary                | unmanaged |
| `bit`                    | Terminal utility installed manually into `~/.local/bin`.                                 | PATH local binary                | unmanaged |
| `br`                     | beads-rust CLI.                                                                          | PATH local binary                | unmanaged |
| `bsv`                    | Terminal data viewer/parser from a local Rust project checkout.                          | cargo install                    | unmanaged |
| `bun`                    | Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one | Homebrew formula                 | managed   |
| `bv`                     | Graph-aware task management TUI for beads projects                                       | Homebrew formula                 | managed   |
| `cargo-insta`            | Helper CLI for managing insta snapshot tests.                                            | cargo install                    | unmanaged |
| `cariddi`                | Scan for endpoints, secrets, API keys, file extensions, tokens and more                  | Homebrew formula                 | managed   |
| `chezmoi`                | Manage your dotfiles across multiple diverse machines, securely                          | Homebrew formula                 | managed   |
| `chromedriver`           | Automated testing of webapps for Google Chrome                                           | Homebrew cask                    | managed   |
| `claude-alert`           | Local notification helper for Claude/Codex workflows.                                    | PATH local binary                | unmanaged |
| `clock-cli`              | Small terminal clock utility. Commands: `clock`.                                         | cargo install                    | unmanaged |
| `clock-tui`              | Interactive terminal clock/TUI. Commands: `tclock`.                                      | cargo install                    | managed   |
| `cmake`                  | Cross-platform make                                                                      | Homebrew formula                 | managed   |
| `duck`                   | Command-line interface for Cyberduck (a multi-protocol file transfer tool)               | Homebrew formula                 | managed   |
| `e2c`                    | Export environment variables into shell-friendly commands.                               | Brewfile go install              | managed   |
| `edencommon`             | Shared library for Watchman and Eden projects                                            | Homebrew formula                 | managed   |
| `eva`                    | Calculator REPL, similar to bc(1)                                                        | Homebrew formula                 | managed   |
| `glues`                  | Terminal glue utility for composing command workflows.                                   | cargo install                    | managed   |
| `go`                     | Open source programming language to build simple/reliable/efficient software             | Homebrew formula                 | managed   |
| `gping`                  | Ping, but with a graph                                                                   | Homebrew formula                 | managed   |
| `gruyere`                | Terminal utility installed manually into `~/.local/bin`.                                 | PATH local binary                | unmanaged |
| `gt`                     | Gastown CLI for terminal-oriented AI and workflow helpers.                               | Brewfile go install              | managed   |
| `hygg`                   | Habit or routine-oriented terminal helper.                                               | cargo install                    | managed   |
| `imagemagick`            | Tools and libraries to manipulate images in select formats                               | Homebrew formula                 | managed   |
| `inspect-cert-chain`     | Inspect and debug TLS certificate chains without OpenSSL                                 | Homebrew formula                 | managed   |
| `kanha`                  | Additional Cargo-installed terminal utility.                                             | cargo install                    | unmanaged |
| `launchk`                | Rust Cursive TUI that helps manage launchd jobs on macOS                                 | Homebrew formula                 | managed   |
| `lcdf-typetools`         | Manipulate OpenType and multiple-master fonts                                            | Homebrew formula                 | managed   |
| `luajit`                 | Just-In-Time Compiler (JIT) for the Lua programming language                             | Homebrew formula                 | managed   |
| `luarocks`               | Package manager for the Lua programming language                                         | Homebrew formula                 | managed   |
| `mardi-gras`             | Terminal UI for Beads issue tracking; your issues deserve a parade                       | Homebrew formula                 | managed   |
| `maven`                  | Java-based project management                                                            | Homebrew formula                 | managed   |
| `meteor`                 | No local description available.                                                          | Homebrew cask                    | managed   |
| `mole`                   | Deep clean and optimize your Mac, uninstall apps                                         | Homebrew formula                 | managed   |
| `mvfst`                  | QUIC transport protocol implementation                                                   | Homebrew formula                 | managed   |
| `nb`                     | No local description available.                                                          | Homebrew formula                 | managed   |
| `needle-cli`             | Terminal HTTP/API utility. Commands: `needle`.                                           | cargo install                    | unmanaged |
| `nerdlog`                | Terminal log viewer for structured and plain-text logs.                                  | Brewfile go install              | managed   |
| `nowplaying-cli`         | Retrieves currently playing media, and simulates media actions                           | Homebrew formula                 | managed   |
| `oid-range`              | OID range inspection utility.                                                            | PATH local binary                | unmanaged |
| `oterm`                  | Text-based terminal client for Ollama                                                    | Homebrew formula                 | managed   |
| `ov`                     | Feature rich terminal pager                                                              | Homebrew formula                 | managed   |
| `oy`                     | Step-through diff viewer for the terminal                                                | Homebrew formula                 | managed   |
| `perles`                 | Terminal-based kanban board for beads issue tracking                                     | Homebrew formula                 | managed   |
| `pip`                    | Python package installer. Commands: `pip`, `pip3`, `pip3.13`.                            | uv tool                          | managed   |
| `pipes.go`               | Animated terminal pipes screensaver.                                                     | Brewfile go install              | managed   |
| `pipx`                   | Execute binaries from Python packages in isolated environments                           | Homebrew formula                 | managed   |
| `pnpm`                   | Fast, disk space efficient package manager                                               | Homebrew formula                 | managed   |
| `pomo`                   | Pomodoro timer for the terminal.                                                         | Brewfile go install              | managed   |
| `pytest`                 | Python testing framework. Commands: `py.test`, `pytest`.                                 | uv tool                          | unmanaged |
| `reddix`                 | Terminal Reddit client.                                                                  | manual installer / copied binary | managed   |
| `regname`                | Tool for inspecting or generating registrable domain names.                              | cargo install                    | unmanaged |
| `rsspod-dl`              | CLI downloader for RSS podcast feeds. Commands: `rsspod`.                                | uv tool                          | unmanaged |
| `rustlings`              | Rust exercise runner and teaching CLI.                                                   | cargo install                    | unmanaged |
| `sad`                    | CLI search and replace / Space Age seD                                                   | Homebrew formula                 | managed   |
| `serpl`                  | Simple terminal UI for search and replace                                                | Homebrew formula                 | managed   |
| `sevenzip`               | 7-Zip is a file archiver with a high compression ratio                                   | Homebrew formula                 | managed   |
| `shfmt`                  | Autoformat shell script source code                                                      | Homebrew formula                 | managed   |
| `skhd`                   | Simple hotkey-daemon for macOS                                                           | Homebrew formula                 | managed   |
| `stormy`                 | Terminal weather client.                                                                 | Brewfile go install              | managed   |
| `tattoy`                 | Text-based terminal compositor                                                           | Homebrew formula                 | managed   |
| `tbl`                    | Local table-formatting utility from a personal Rust project checkout.                    | cargo install                    | unmanaged |
| `termchat`               | Terminal chat client.                                                                    | cargo install                    | unmanaged |
| `termframe`              | Terminal output SVG screenshot tool                                                      | Homebrew formula                 | managed   |
| `terminal-notifier`      | Send macOS User Notifications from the command-line                                      | Homebrew formula                 | managed   |
| `terminal-toys`          | Collection of playful terminal demos and utilities.                                      | cargo install                    | unmanaged |
| `termscp`                | Feature rich terminal file transfer and explorer                                         | Homebrew formula                 | managed   |
| `theattyr`               | Terminal text and animation utility.                                                     | cargo install                    | unmanaged |
| `tlrc`                   | Official tldr client written in Rust                                                     | Homebrew formula                 | managed   |
| `tree-sitter`            | Incremental parsing library                                                              | Homebrew formula                 | managed   |
| `ugdb`                   | Terminal UI frontend for gdb.                                                            | cargo install                    | managed   |
| `uv`                     | Extremely fast Python package installer and resolver, written in Rust                    | Homebrew formula                 | managed   |
| `wget`                   | Internet file retriever                                                                  | Homebrew formula                 | managed   |
| `wiki-tui`               | Wikipedia browser for the terminal.                                                      | cargo install                    | managed   |
| `wtfis`                  | Passive hostname, domain, and IP lookup tool                                             | Homebrew formula                 | managed   |
| `wut-cli`                | General-purpose CLI utility package installed with uv. Commands: `wut`.                  | uv tool                          | unmanaged |
| `yabai`                  | A tiling window manager for macOS based on binary space partitioning                     | Homebrew formula                 | managed   |
| `yarn`                   | JavaScript package manager                                                               | Homebrew formula                 | managed   |

## Install Sources Reviewed

### [cm-util/ctrld-configs/homebrew/Brewfile](/Users/kirbylittle/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile)

- Homebrew formulas (162): `act`, `aichat`, `ast-grep`, `atac`, `atuin`, `aws-shell`, `awscli`, `bash`, `bat`, `bat-extras`, `bob`, `bottom`, `btop`, `fontconfig`, `cariddi`, `chafa`, `chezmoi`, `cmake`, `coreutils`, `doggo`, `dolt`, `duck`, `dust`, `folly`, `fizz`, `wangle`, `fbthrift`, `fb303`, `edencommon`, `eget`, `node`, `eslint`, `eslint_d`, `eva`, `eza`, `fd`, `libidn2`, `ffmpegthumbnailer`, `fish`, `fnm`, `fontforge`, `fselect`, `fzf`, `gh`, `git`, `git-delta`, `git-flow`, `gitleaks`, `gitwatch`, `glow`, `gnupg`, `go`, `gobackup`, `gping`, `graphviz`, `lua`, `highlight`, `hub`, `imagemagick`, `joshuto`, `jq`, `jql`, `lazydocker`, `lazygit`, `lcdf-typetools`, `lefthook`, `libpq`, `llvm`, `lolcat`, `luajit`, `luarocks`, `markdownlint-cli`, `maven`, `miller`, `mole`, `mongosh`, `mosh`, `mtr`, `mvfst`, `nowplaying-cli`, `nvm`, `pandoc`, `pipx`, `pngpaste`, `pnpm`, `poppler`, `prettier`, `prettierd`, `procs`, `qpdf`, `ripgrep`, `rustup`, `sad`, `serpl`, `sevenzip`, `shfmt`, `snitch`, `sq`, `ssh-vault`, `starship`, `stylua`, `switchaudio-osx`, `tailscale`, `television`, `terminal-notifier`, `termscp`, `wireshark`, `termshark`, `terragrunt`, `terrascan`, `tflint`, `tlrc`, `tmux`, `toilet`, `tokei`, `tree`, `tree-sitter`, `trippy`, `uv`, `vhs`, `wget`, `whosthere`, `wtfis`, `yarn`, `zoxide`, `adembc/tap/lazyssh`, `ahkohd/oyo/oy`, `ameshkov/tap/dnslookup`, `bellicose100xp/tap/jiq`, `clawscli/tap/claws`, `conikeec/tap/mcp-probe`, `dicklesworthstone/tap/bv`, `ggozad/formulas/oterm`, `gromgit/brewtils/taproom`, `harehare/tap/mq`, `hashicorp/tap/terraform`, `huseyinbabal/tap/taws`, `hyde46/hoard/hoard`, `idoavrah/homebrew/tftui`, `inkdrop-org/inkdrop-visualizer/inkdrop-visualizer`, `jordond/tap/jolt`, `kdash-rs/kdash/kdash`, `kiki-ki/tap/qo`, `koekeishiya/formulae/skhd`, `koekeishiya/formulae/yabai`, `kopecmaciej/vi-mongo/vi-mongo`, `lance0/tap/xfr`, `mach-kernel/pkgs/launchk`, `matt-wright86/tap/mardi-gras`, `mongodb/brew/mongodb-community`, `noborus/tap/ov`, `oven-sh/bun/bun`, `pamburus/tap/termframe`, `strongdm/comply/comply`, `tattoy-org/tap/tattoy`, `tokuhirom/tap/dcv`, `unhappychoice/tap/gitlogue`, `valkyrie00/bbrew/bbrew`, `vjeantet/tap/alerter`, `x52dev/tap/inspect-cert-chain`, `xwmx/taps/nb`, `zjrosen/perles/perles`
- Homebrew casks declared (42 total; only some contribute CLI/TUI tools): `1password`, `1password-cli`, `basictex`, `betterdisplay`, `chromedriver`, `miklosn/tap/cmdperf`, `cyberduck`, `displaycal`, `figma`, `font-departure-mono`, `font-departure-mono-nerd-font`, `font-symbols-only-nerd-font`, `foxit-pdf-editor`, `ghostty`, `github`, `google-chrome`, `hammerspoon`, `karabiner-elements`, `kitty@nightly`, `linear-linear`, `macfuse`, `stefanlogue/tools/meteor`, `microsoft-edge`, `mongodb-compass`, `mountain-duck`, `ngrok`, `notion`, `notion-calendar`, `obsidian`, `pgadmin4`, `postgres-app`, `postman`, `raycast`, `session-manager-plugin`, `sf-symbols`, `shottr`, `slack`, `sublime-text`, `surge-downloader/tap/surge`, `temurin@11`, `visual-studio-code`, `zoom`
- `go install` packages (7): `github.com/steveyegge/beads/cmd/bd`, `github.com/hymkor/csvi/cmd/csvi`, `github.com/nlamirault/e2c/cmd/e2c`, `github.com/steveyegge/gastown/cmd/gt`, `github.com/dimonomid/nerdlog/cmd/nerdlog`, `github.com/plutov/oq`, `github.com/satvikgosai/pipes.go`

### [.chezmoiscripts/run_once_after_2-install-various.sh](/Users/kirbylittle/.local/share/chezmoi/.chezmoiscripts/run_once_after_2-install-various.sh)

- npm globals (4): `@zed-industries/claude-code-acp`, `typescript`, `typescript-language-server`, `@anthropic-ai/claude-code`
- Go installs (8): `github.com/hymkor/csvi/cmd/csvi`, `github.com/Bahaaio/pomo`, `github.com/samyakbardiya/trex`, `github.com/nlamirault/e2c/cmd/e2c`, `github.com/dimonomid/nerdlog/cmd/nerdlog`, `github.com/Gaurav-Gosain/tuios/cmd/tuios`, `github.com/ashish0kumar/stormy`, `github.com/ziinaio/zmate`
- Cargo installs (11 plus `systemd-manager-tui` for SSH hosts): `wiki-tui`, `clock-tui`, `filessh`, `trippy`, `rustnet-monitor`, `gittype`, `glues`, `jocalsend`, `regname`, `hygg`, `ugdb`
- uv one-offs (1): `specify-cli`
- gh extensions (2): `dlvhdr/gh-dash`, `dlvhdr/gh-enhance`
- Manual/script-managed items detected in the file: `rustup`, `nix`, `ghostty_animation`, `reddix`, `yazi`, `ya`, plus a default Node runtime via `fnm`.

### [.chezmoidata/uv.toml](/Users/kirbylittle/.local/share/chezmoi/.chezmoidata/uv.toml)

- uv tools (10 unique tools across default and SSH variants): `pip`, `pipx`, `ruff-lsp`, `ruff`, `pre-commit`, `yapf`, `bagels`, `cfn-lint`, `neovim-remote`, `terminaltexteffects`

## Reproducibility Gaps

### Homebrew leaves not declared in Brewfile

- None.

### Cargo-installed crates not declared in chezmoi

- `basalt-tui`: Terminal UI for Basalt-related workflows. Commands: `basalt`.
- `bsv`: Terminal data viewer/parser from a local Rust project checkout.
- `cargo-audit`: Audit Cargo.lock dependencies for known RustSec vulnerabilities.
- `cargo-deny`: Check Cargo dependency graphs for licenses, bans, and advisories.
- `cargo-insta`: Helper CLI for managing insta snapshot tests.
- `cargo-vet`: Supply-chain auditing tool for Rust dependencies.
- `clock-cli`: Small terminal clock utility. Commands: `clock`.
- `csvlint`: CSV validation CLI.
- `kanha`: Additional Cargo-installed terminal utility.
- `killport-tui`: TUI for finding and killing processes bound to ports. Commands: `kp`.
- `mdbook`: Create books and long-form docs from Markdown.
- `needle-cli`: Terminal HTTP/API utility. Commands: `needle`.
- `oha`: HTTP load generator and benchmarking CLI.
- `ports-cli`: View and manage open ports from the terminal. Commands: `ports`.
- `regname`: Tool for inspecting or generating registrable domain names.
- `rustlings`: Rust exercise runner and teaching CLI.
- `ssh-list`: List and inspect SSH hosts/config from the terminal.
- `tbl`: Local table-formatting utility from a personal Rust project checkout.
- `termchat`: Terminal chat client.
- `terminal-toys`: Collection of playful terminal demos and utilities.
- `theattyr`: Terminal text and animation utility.
- `toktop`: Tokio-powered terminal process/system monitor.
- `tracker`: Terminal tracker utility from a Git checkout.
- `zellij`: Terminal workspace and multiplexer.

### Cargo tools declared only conditionally

These are declared in chezmoi, but only for an SSH/Linux-style environment profile, not for the current local machine profile.

- `systemd-manager-tui`: Interactive TUI for systemd services.

### uv tools not declared in chezmoi

- `csvkit`: Suite of CSV command-line utilities. Commands: `csvclean`, `csvcut`, `csvformat`, `csvgrep`, `csvjoin`, `csvjson`, `csvlook`, `csvpy`, `csvsort`, `csvsql`, `csvstack`, `csvstat`, `in2csv`, `sql2csv`.
- `pytest`: Python testing framework. Commands: `py.test`, `pytest`.
- `rsspod-dl`: CLI downloader for RSS podcast feeds. Commands: `rsspod`.
- `wut-cli`: General-purpose CLI utility package installed with uv. Commands: `wut`.

### npm globals not declared in chezmoi

- `codex`: OpenAI Codex CLI.

### PATH-local binaries with no install declaration found

- `amp`: Terminal text editor and pager-style tool.
- `bandwhich`: Terminal bandwidth utilization monitor.
- `beads-web-darwin-arm64`: Local Beads-related binary for web workflows.
- `bit`: Terminal utility installed manually into `~/.local/bin`.
- `br`: beads-rust CLI.
- `claude-alert`: Local notification helper for Claude/Codex workflows.
- `gruyere`: Terminal utility installed manually into `~/.local/bin`.
- `lazytail`: TUI log viewer with lazygit-style interactions.
- `oid-range`: OID range inspection utility.

## PATH Collisions

- `bd` appears in `/Users/kirbylittle/go/bin`, `/Users/kirbylittle/.local/share/pnpm`
- `cargo` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `cargo-clippy` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `cargo-fmt` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `clippy-driver` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `codex` appears in `/Users/kirbylittle/.local/share/pnpm`, `/opt/homebrew/bin`
- `gt` appears in `/Users/kirbylittle/.local/bin`, `/Users/kirbylittle/go/bin`
- `pip3` appears in `/Users/kirbylittle/.local/bin`, `/opt/homebrew/bin`
- `pip3.13` appears in `/Users/kirbylittle/.local/bin`, `/opt/homebrew/bin`
- `pipx` appears in `/Users/kirbylittle/.local/bin`, `/opt/homebrew/bin`
- `python3` appears in `/Users/kirbylittle/.local/bin`, `/opt/homebrew/bin`
- `python3.13` appears in `/Users/kirbylittle/.local/bin`, `/opt/homebrew/bin`
- `rust-gdb` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `rust-gdbgui` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `rust-lldb` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `rustc` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `rustdoc` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `rustfmt` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`
- `rustup` appears in `/Users/kirbylittle/.cargo/bin`, `/opt/homebrew/bin`

## Suggested Next Steps

- Decide whether each unmanaged tool should be added to [cm-util/ctrld-configs/homebrew/Brewfile](/Users/kirbylittle/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile), [.chezmoiscripts/run_once_after_2-install-various.sh](/Users/kirbylittle/.local/share/chezmoi/.chezmoiscripts/run_once_after_2-install-various.sh), or [.chezmoidata/uv.toml](/Users/kirbylittle/.local/share/chezmoi/.chezmoidata/uv.toml).
- For binaries that exist only in `~/.local/bin`, either codify their installation or treat them explicitly as machine-local tools outside the reproducible baseline.
- If you want a stricter follow-up audit, the next refinement would be mapping every declared package to the exact executable names it contributes and validating PATH precedence end to end.
