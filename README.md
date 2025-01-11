# Chezmoi synchronized configs

## New env setup

### On macOS

- Probably want to disable press-and-hold on macOS `defaults write -g ApplePressAndHoldEnabled -bool false`
  - This has some annoying implications when using KB navigation (e.g. holding `k` to scroll up pops up the macOS character selector)
- Disable macOS font smoothing, it prevents pixel perfect text rendering `defaults -currentHost write -g AppleFontSmoothing -int 0` (then restart)
- `defaults write -g NSServicesMinimumItemCountForContextSubmenu -int 5` sets the number of items required for the "Services" submenu to appear in the right-click context menu. Setting to a number higher than the number of services selected in `Settings > Keyboard > Shortcuts > Services` will prevent the submenu from appearing. This allows us to "replace" the default "New Terminal Tab at Folder" that appears in the main context menu with our custom terminal service e.g. "New Ghostty Tab Here".

## Dependencies

### Manual Installs

- Docker
- [YabaiIndicator](https://github.com/xiamaz/YabaiIndicator)

### Python

- cfnlint
- ruff_lsp
- ruff
- textual
- rich
- flask
- yapf
-

### Node

- prettier
- eslint_d
- eslint-cli

## Lua

- [Quick primer](https://learnxinyminutes.com/docs/lua/)

## Delta notes

- [Themes](https://github.com/dandavison/delta/blob/main/themes.gitconfig)

## Watchman notes

- `watchman watch "${CHEZMOI_SOURCE_PATH}"` will watch the directory for changes.
- `echo '["trigger", "'${CHEZMOI_SOURCE_PATH}'", {"name": "chezmoi-apply", "command": ["chezmoi", "apply", "--force"]}]' | watchman -j` tells watchman to run `chezmoi apply --force` when changes are detected.
- `watchman shutdown-server` to stop the watchman server.

## Chezmoi notes

- "Source state" refers to the dirs/files in the chezmoi directory.
- "Destination state" refers to the current dirs/files in local environment.
- "Target state" refers to the desired dir/file state that chezmoi will apply to the
  local environment.
- [Setting up externally modified files (e.g. program settings)](https://www.chezmoi.io/user-guide/manage-different-types-of-file/#handle-configuration-files-which-are-externally-modified)
- `chezmoi edit <file>` will open the file in the editor specified in the `EDITOR` environment variable.
- `chezmoi apply` will apply the changes to the "source" files.
- `chezmoi diff` will show the differences between the "source" files and the "destination" files.
- `chezmoi cd` will change the working directory to the chezmoi directory.
- `chezmoi update` will pull from the chezmoi repository and apply the changes.
- `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:krbylit/configs.git` will install chezmoi and apply my configs on a new machine.
- `private_` prefix sets target file permissions to 0600

## 1Password notes

- <https://www.chezmoi.io/user-guide/password-managers/1password/#1password-connect>
- Using 1Pass Service Accounts, Chezmoi must be configured for `onepassword.mode="service"` in the `.chezmoi.toml`
- `OP_SERVICE_ACCOUNT_TOKEN` must be set in environment or chezmoi will stop with an error

## Vimium notes

- "Restore settings" can only take <=8KB of data
  - <https://github.com/philc/vimium/issues/4371>

### Themes

- <https://github.com/mxxjng/vimium-glass-theme>
- <https://github.com/catppuccin/vimium>

## File encryption notes

### Encrypting with `gpg`

- Files encrypted with a passphrase
- With the setup in `.chezmoi.toml`, chezmoi will prompt for the passphrase once first time `chezmoi init` is run, then will store the passphrase in the config file on the local machine

### Encrypting with `rage`

- Generate key with `rage-keygen -o $HOME/key.txt`
- Set encryption method to `rage` in `.chezmoi.toml` and specify `identity` and `recipient`

## nvim config workflow

- Since I like to edit by opening the nvim/ dir and going from there, `chezmoi edit` does not edit the "source" files in `~/.config/nvim/`, but instead the files in `~/.local/share/chezmoi/`.

  - This means that to see changes, `chezmoi apply` must be run to copy the changes to the "source" files.

## Application dependencies

- `Neovim` >0.10.0
  - <https://neovim.io/>
  - `brew install neovim`
- `Kitty`
  - <https://sw.kovidgoyal.net/kitty/binary/>
  - `curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin`
- `Starship`
  - <https://starship.rs/>
  - `brew install starship`
- `watchman` for detecting source changes and running `chezmoi apply` automatically
  - <https://github.com/facebook/watchman>
  - `brew install watchman`
- `delta` diff tool for git
  - <https://dandavison.github.io/delta/installation.html>
  - brew install git-delta
- `luajit` for neovim config using luarocks
  - `brew install luajit`
  - NOTE: currently only used for `lfs` to dynamically import from `plugin-keymaps`
  - TODO: consider alternate method to eliminate this dependency
- `1password-cli` for 1Password Service Account management of SSH keys
  - `brew install 1password-cli`
  - <https://developer.1password.com/docs/cli/get-started>
    `rage` for file encryption
  - `brew install rage`
  - <https://github.com/str4d/rage#installation>
