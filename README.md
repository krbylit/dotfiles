# Chezmoi synchronized configs

## New env setup

### On macOS

- Some macOS settings are changed in the `..macos-settings.sh` Chezmoi script in `.chezmoiscripts/`.

## Dependencies

### Manual Installs

These are not installed by chezmoi, so must be installed manually.

- Docker
- [YabaiIndicator](https://github.com/xiamaz/YabaiIndicator)
- Firefox extensions:
  - Sidebery (horizontal tabs)
  - Vimium
  - Firenvim

## GitHub Actions notes

> [!TODO]
>
> - Currently we have to manually sync any changes to workflow yamls. If we change workflow in private repo and try to sync, we get a permission error even though repos appear to be configured to allow bots to change workflows.
> - Finish setup for handling no error on empty diff between private and public.
> - Add step to `rm -f` `encrypted_` chezmoi files before committing to public, making clone and initial setup easier for others.

### Setup of public dotfiles repo

- Initialize a local repo: `git init`.
- Copy `.github/` to the local public repo.
- Commit and push to remote public repo.
- Run 'Initial Public Repo Setup' action on GitHub in the public repo.

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
