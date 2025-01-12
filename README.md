# Chezmoi synchronized configs

## New env setup

### On macOS

- Probably want to disable press-and-hold on macOS `defaults write -g ApplePressAndHoldEnabled -bool false`
  - This has some annoying implications when using KB navigation (e.g. holding `k` to scroll up pops up the macOS character selector)
- Disable macOS font smoothing, it prevents pixel perfect text rendering `defaults -currentHost write -g AppleFontSmoothing -int 0` (then restart)
- `defaults write -g NSServicesMinimumItemCountForContextSubmenu -int 5` sets the number of items required for the "Services" submenu to appear in the right-click context menu. Setting to a number higher than the number of services selected in `Settings > Keyboard > Shortcuts > Services` will prevent the submenu from appearing. This allows us to "replace" the default "New Terminal Tab at Folder" that appears in the main context menu with our custom terminal service e.g. "New Ghostty Tab Here".

## Dependencies

### Manual Installs

These are not installed by chezmoi, so must be installed manually.

- Docker
- [YabaiIndicator](https://github.com/xiamaz/YabaiIndicator)

## Checking the Repository for Secrets

### Pre-commit hook

We have a pre-commit hook that scans for secrets with `gitleaks` on every commit. This is installed with our Homebrew packages and set up with `.pre-commit-config.yaml`, `.gitleaksignore`, and `run_after_2-install-various.sh`.

### Manually scan the repository, including commit history

- Save `jsonextra.tmpl` in root dir:

  ```
  [{{ $lastFinding := (sub (len . ) 1) }}
  {{- range $i, $finding := . }}{{with $finding}}
      {
          "Description": {{ quote .Description }},
          "StartLine": {{ .StartLine }},
          "EndLine": {{ .EndLine }},
          "StartColumn": {{ .StartColumn }},
          "EndColumn": {{ .EndColumn }},
          "Line": {{ quote .Line }},
          "Match": {{ quote .Match }},
          "Secret": {{ quote .Secret }},
          "File": "{{ .File }}",
          "SymlinkFile": {{ quote .SymlinkFile }},
          "Commit": {{ quote .Commit }},
          "Entropy": {{ .Entropy }},
          "Author": {{ quote .Author }},
          "Email": {{ quote .Email }},
          "Date": {{ quote .Date }},
          "Message": {{ quote .Message }},
          "Tags": [{{ $lastTag := (sub (len .Tags ) 1) }}{{ range $j, $tag := .Tags }}{{ quote . }}{{ if ne $j $lastTag }},{{ end }}{{ end }}],
          "RuleID": {{ quote .RuleID }},
          "Fingerprint": {{ quote .Fingerprint }}
      }{{ if ne $i $lastFinding }},{{ end }}
  {{- end}}{{ end }}
  ]
  ```

- Run `gitleaks git --report-path "gitleaks-report.json" --report-format template --report-template jsonextra.tmpl`

## Chezmoi notes

- "Source state" refers to the dirs/files in the chezmoi directory.
- "Destination state" refers to the current dirs/files in local environment.
- "Target state" refers to the desired dir/file state that chezmoi will apply to the
  local environment.
- [Setting up externally modified files (e.g. settings which programs can alter at runtime, see `btop.conf` or `karabiner.json`)](https://www.chezmoi.io/user-guide/manage-different-types-of-file/#handle-configuration-files-which-are-externally-modified)
- `chezmoi edit <file>` will open the file in the editor specified in the `EDITOR` environment variable.
- `chezmoi apply` will apply the changes to the "source" files.
- `chezmoi diff` will show the differences between the "source" files and the "destination" files.
- `chezmoi cd` will change the working directory to the chezmoi directory.
- `chezmoi update` will pull from the chezmoi repository and apply the changes.
- `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:krbylit/dotfiles.git` will install chezmoi and apply our configs on a new machine.

## 1Password notes

- <https://www.chezmoi.io/user-guide/password-managers/1password/#1password-connect>
- Using 1Pass Service Accounts, Chezmoi must be configured for `onepassword.mode="service"` in the `.chezmoi.toml`
- `OP_SERVICE_ACCOUNT_TOKEN` must be set in environment or chezmoi will stop with an error

## File encryption notes

- Files encrypted with a passphrase
- With the setup in `.chezmoi.toml`, chezmoi will prompt for the passphrase once first time `chezmoi init` is run, then will store the passphrase in the config file on the local machine
- To edit encrypted files, we must use the typical Chezmoi workflow of `chezmoi edit <file>` since `chezmoi.nvim` will not work with encrypted files.

## nvim config workflow

- We have various config aliases in `fish/functions/`. For nvim, run `vc`.
- Since we have `chezmoi.nvim`, any saved changes to files made with nvim in `~/.local/share/chezmoi` will be automatically applied to the target state, so we don't need to run `chezmoi apply` afterwards.
