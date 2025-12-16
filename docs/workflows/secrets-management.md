# Secrets Management

## Purpose

This workflow explains how to securely manage secrets, API keys, and sensitive configuration data in the dotfiles repository. The secrets management system combines multiple layers of security: a private git submodule for sensitive files, GPG symmetric encryption for individual secrets, 1Password integration for shared credentials, and automated scanning to prevent accidental leaks.

## Prerequisites

- [x] Chezmoi installed (v2.0.0 or later)
- [x] GPG installed (for symmetric encryption)
- [x] 1Password CLI (op) installed (if using 1Password integration)
- [x] Git configured with authentication
- [x] Pre-commit hooks configured (for gitleaks scanning)

## Components Overview

The secrets management architecture consists of four complementary components:

### 1. Secrets Submodule

A private git repository (`secrets/`) that stores sensitive configuration files that should never appear in the public dotfiles repository. This submodule is automatically initialized during `chezmoi init` and is excluded from the target state via `.chezmoiignore`.

**Use cases**:

- API configuration files
- Private shell environment variables
- Service-specific credentials
- Machine-specific secrets

### 2. GPG Symmetric Encryption

Individual files encrypted with GPG using a passphrase-based symmetric encryption. Chezmoi handles encryption/decryption transparently using the `encrypted_` prefix pattern.

**Use cases**:

- Single sensitive files that need version control
- Small credentials that don't warrant a full submodule
- Cross-machine secrets that need to be in the main repo

### 3. 1Password Integration

Direct access to 1Password vaults via service accounts, allowing templates to reference secrets without storing them in the repository at all.

**Use cases**:

- Shared team credentials
- Rotating API keys
- Secrets that should never touch disk in plain text

### 4. Gitleaks Scanning

Pre-commit hook that scans for accidentally committed secrets using pattern matching. Configured via `.pre-commit-config.yaml` with exceptions in `.gitleaksignore`.

**Use cases**:

- Preventing accidental secret leaks
- Catching hardcoded credentials
- Validating all commits before they reach GitHub

## Step-by-Step Procedures

### Initialize Secrets Submodule

This procedure sets up the private secrets repository as a git submodule within your chezmoi source directory.

#### Step 1: Configure secrets repository URL during chezmoi init

When running `chezmoi init` for the first time, you'll be prompted for the secrets repository URL.

```bash
chezmoi init
```

**Prompt**: `Enter git@github.com URL to optional repo containing dotfile secrets`

**Input**: Enter your private secrets repository URL (e.g., `git@github.com:username/dotfiles-secrets.git`) or leave blank to skip.

**Expected result**: Chezmoi creates `.chezmoi.toml.tmpl` with the secrets repository URL stored in the `data.secretsRepo` field.

#### Step 2: Verify submodule initialization

The `run_once_before_1-setup-secrets-submodule.sh.tmpl` script automatically runs before other chezmoi operations and creates the `.gitmodules` file.

```bash
# Check that .gitmodules was created
cat ~/.local/share/chezmoi/.gitmodules
```

**Expected result**:

```
[submodule "secrets"]
    path = secrets
    url = git@github.com:username/dotfiles-secrets.git
```

**Note**: This script only runs on local machines (not via SSH) to prevent remote machines from attempting to clone private repositories.

#### Step 3: Initialize and update the submodule

Navigate to the chezmoi source directory and initialize the submodule:

```bash
cd ~/.local/share/chezmoi
git submodule init
git submodule update --remote
```

**Expected result**: The `secrets/` directory is created and populated with files from your private repository.

#### Step 4: Verify secrets directory exists

```bash
ls -la ~/.local/share/chezmoi/secrets/
```

**Expected result**: Directory contents match your private secrets repository. The directory should contain files like environment variables, API keys, or other sensitive configuration.

**Important**: The `secrets/` directory is excluded from the target state via `.chezmoiignore`, meaning files inside it are never copied to `$HOME`. They exist solely for use in chezmoi templates and configuration.

### Add New Secrets

This procedure covers the decision process and commands for adding new secrets to your dotfiles.

#### Step 1: Decide on the appropriate storage method

Use this decision tree to determine where to store your secret:

```
Does the secret need to be shared across a team?
├─ YES → Use 1Password Integration (see Step 2a)
└─ NO → Continue

    Is this a single file or credential?
    ├─ YES → Use GPG Encryption (see Step 2b)
    └─ NO → Continue

        Does this involve multiple related files or configs?
        ├─ YES → Use Secrets Submodule (see Step 2c)
        └─ NO → Reconsider if this needs to be a secret at all
```

#### Step 2a: Add secret via 1Password (team/shared secrets)

For secrets that should be retrieved dynamically from 1Password:

```bash
# In a chezmoi template file (*.tmpl), reference the 1Password secret
{{ (onepasswordRead "op://vault/item/field") }}
```

**Example** (in `.chezmoi.toml.tmpl` or any template):

```toml
[data]
    github_token = {{ onepasswordRead "op://Private/GitHub/token" | quote }}
```

**Expected result**: When chezmoi processes the template, it fetches the secret from 1Password using the service account configured in `chezmoi.toml`.

**Verification**:

```bash
chezmoi execute-template '{{ onepasswordRead "op://Private/GitHub/token" }}'
```

#### Step 2b: Add secret via GPG encryption (individual files)

For single files that need encryption:

```bash
# Add the file to chezmoi source directory with encrypted_ prefix
chezmoi add --encrypt ~/.config/service/credentials.json
```

This creates `~/.local/share/chezmoi/encrypted_dot_config/service/credentials.json.age` (or `.gpg` depending on encryption method).

**Expected result**: File is encrypted using the GPG passphrase configured during `chezmoi init`.

**Verification**:

```bash
# Verify the file is encrypted (should show binary/encrypted content)
cat ~/.local/share/chezmoi/encrypted_dot_config/service/credentials.json.asc

# Verify chezmoi can decrypt it
chezmoi cat ~/.config/service/credentials.json
```

#### Step 2c: Add secret via secrets submodule (multiple files/configs)

For adding files to the private secrets submodule:

```bash
# Navigate to secrets directory
cd ~/.local/share/chezmoi/secrets

# Add your secret file
echo "export SECRET_API_KEY=abc123" > env_vars.sh

# Commit to the secrets repository
git add env_vars.sh
git commit -m "feat: add API key for service X"
git push origin main
```

**Expected result**: File is committed to the private secrets repository (not the main dotfiles repo).

**Use in templates**: Reference secrets submodule files in chezmoi templates:

```bash
# Example: Source secrets in a shell config template
{{ if pathExists (joinPath .chezmoi.sourceDir "secrets/env_vars.sh") }}
source "{{ joinPath .chezmoi.sourceDir "secrets/env_vars.sh" }}"
{{ end }}
```

### Configure GPG Passphrase

This procedure sets up GPG symmetric encryption for chezmoi.

#### Step 1: Verify GPG is installed

```bash
gpg --version
```

**Expected result**: GPG version 2.4.0 or later is displayed.

If GPG is not installed:

```bash
# macOS
brew install gnupg

# Linux
sudo apt install gnupg  # Debian/Ubuntu
sudo dnf install gnupg  # Fedora
```

#### Step 2: Set passphrase during chezmoi init

When running `chezmoi init`, you'll be prompted for an encryption passphrase:

```bash
chezmoi init
```

**Prompt**: `passphrase`

**Input**: Enter a strong passphrase (this will be used for all GPG encryption/decryption)

**Expected result**: Passphrase is stored in `~/.config/chezmoi/chezmoi.toml`:

```toml
encryption = "gpg"

[data]
    passphrase = "your-passphrase-here"

[gpg]
    symmetric = true
    args = ["--batch", "--passphrase", "your-passphrase-here", "--no-symkey-cache"]
```

#### Step 3: Test encryption/decryption

Create a test encrypted file:

```bash
# Create a test secret file
echo "test-secret-content" > ~/test-secret.txt

# Add it with encryption
chezmoi add --encrypt ~/test-secret.txt

# Verify it's encrypted in the source directory
cat ~/.local/share/chezmoi/encrypted_test-secret.txt.asc
```

**Expected result**: The file content is encrypted (binary/base64 encoded).

```bash
# Verify chezmoi can decrypt it
chezmoi cat ~/test-secret.txt
```

**Expected result**: Original content `test-secret-content` is displayed.

```bash
# Clean up test file
rm ~/test-secret.txt
chezmoi forget ~/test-secret.txt
```

#### Step 4: Update passphrase (if needed)

To change your encryption passphrase:

```bash
# Edit chezmoi config
chezmoi edit-config
```

Update the `passphrase` field in both `[data]` and `[gpg]` sections, then save.

**Warning**: Changing the passphrase requires re-encrypting all existing encrypted files:

```bash
# Re-encrypt all files with new passphrase
chezmoi re-add --encrypt ~/.config/service/credentials.json
```

### Set Up 1Password Integration

This procedure configures chezmoi to access 1Password vaults via service accounts.

#### Step 1: Create a 1Password service account

Follow 1Password's documentation to create a service account with read access to the vaults containing your secrets.

**Documentation**: <https://developer.1password.com/docs/service-accounts/get-started/>

**Expected result**: You receive a service account token (starts with `ops_`).

#### Step 2: Authenticate the 1Password CLI

Set the service account token as an environment variable:

```bash
# Add to your shell profile (e.g., ~/.config/fish/config.fish)
export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here"
```

**Verification**:

```bash
op account list
```

**Expected result**: Your 1Password account is listed.

#### Step 3: Configure chezmoi for 1Password service account mode

Edit `~/.config/chezmoi/chezmoi.toml` (or use the template `.chezmoi.toml.tmpl`):

```toml
[onepassword]
    mode = "service"
```

**Expected result**: Chezmoi uses the `OP_SERVICE_ACCOUNT_TOKEN` for authentication instead of interactive login.

#### Step 4: Test 1Password integration

```bash
# Test reading a secret from 1Password
chezmoi execute-template '{{ onepasswordRead "op://Private/TestItem/password" }}'
```

Replace `Private/TestItem/password` with an actual vault/item/field path from your 1Password account.

**Expected result**: The secret value is displayed.

#### Step 5: Use 1Password secrets in templates

In any chezmoi template file (e.g., `.config/service/config.toml.tmpl`):

```toml
[api]
    token = {{ onepasswordRead "op://Private/ServiceAPI/token" | quote }}
```

**Apply the template**:

```bash
chezmoi apply
```

**Expected result**: The target file contains the actual secret fetched from 1Password.

### Prevent Secret Leaks with Gitleaks

This procedure explains how the gitleaks pre-commit hook protects against accidental secret commits.

#### Step 1: Verify pre-commit hooks are installed

```bash
# Check if pre-commit is installed
pre-commit --version
```

If not installed:

```bash
# macOS
brew install pre-commit

# Linux
pip install pre-commit
```

#### Step 2: Install pre-commit hooks for the repository

```bash
cd ~/.local/share/chezmoi
pre-commit install
```

**Expected result**: Git hooks are installed in `.git/hooks/pre-commit`.

**Verification**:

```bash
ls -la .git/hooks/pre-commit
```

#### Step 3: Understand gitleaks configuration

The `.pre-commit-config.yaml` file configures gitleaks:

```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.30.0
    hooks:
      - id: gitleaks
```

Gitleaks scans for common secret patterns:

- AWS credentials
- GitHub tokens
- Private keys
- API keys
- Generic secrets (high-entropy strings)

#### Step 4: Test gitleaks scanning

Run gitleaks manually on all files:

```bash
cd ~/.local/share/chezmoi
pre-commit run gitleaks --all-files
```

**Expected result**: If no secrets are detected, you'll see:

```
gitleaks................................................................Passed
```

If secrets are found:

```
gitleaks................................................................Failed
- hook id: gitleaks
- exit code: 1

Finding:     <secret-pattern>
Secret:      <redacted>
File:        path/to/file.ext
```

#### Step 5: Handle false positives

If gitleaks flags a false positive (e.g., example credentials in documentation), add it to `.gitleaksignore`:

```bash
# Edit .gitleaksignore
vim ~/.local/share/chezmoi/.gitleaksignore
```

Add the file and pattern in the format: `path/to/file:rule-name:line-number`

**Example** (current `.gitleaksignore`):

```
.chezmoidata/pillager-rules.toml:private-key:16
.chezmoidata/pillager-rules.toml:private-key:26
dot_hammerspoon/Spoons/VimMode.spoon/lib/contextual_modal.lua:generic-api-key:78
```

**Verification**:

```bash
pre-commit run gitleaks --all-files
```

**Expected result**: The ignored patterns no longer trigger failures.

#### Step 6: Automatic scanning on commit

Gitleaks now runs automatically whenever you commit:

```bash
cd ~/.local/share/chezmoi
git add some-file.txt
git commit -m "feat: add configuration"
```

**Expected result**: If secrets are detected, the commit is blocked with an error message. If no secrets are found, the commit proceeds normally.

## Verification

To verify the secrets management workflow is configured correctly:

### 1. Verify secrets submodule

```bash
cd ~/.local/share/chezmoi
git submodule status
```

**Expected**: Submodule is initialized with a commit hash (not `-` prefix).

### 2. Verify GPG encryption works

```bash
# Create test encrypted file
echo "test" > ~/test.txt
chezmoi add --encrypt ~/test.txt

# Verify encrypted
cat ~/.local/share/chezmoi/encrypted_test.txt.asc | head -5

# Verify decryption
chezmoi cat ~/test.txt

# Clean up
rm ~/test.txt
chezmoi forget ~/test.txt
```

**Expected**: File encrypts and decrypts successfully.

### 3. Verify 1Password integration

```bash
chezmoi execute-template '{{ onepasswordRead "op://Private/TestItem/password" }}'
```

**Expected**: Secret is retrieved without errors.

### 4. Verify gitleaks scanning

```bash
cd ~/.local/share/chezmoi
pre-commit run gitleaks --all-files
```

**Expected**: Scan completes (passes or lists known exceptions).

### 5. Check chezmoi configuration

```bash
chezmoi doctor
```

**Expected**: All checks pass (warnings about dirty working tree are normal during development).

## Troubleshooting

### Problem: GPG passphrase not working

**Symptoms**:

- `Error: failed to decrypt file: gpg: decryption failed: Bad session key`
- Chezmoi prompts for passphrase repeatedly
- Encrypted files cannot be decrypted

**Solution**:

1. Verify the passphrase in chezmoi config:

```bash
chezmoi edit-config
```

Check that `[data].passphrase` and `[gpg].args` contain the correct passphrase.

1. Test GPG manually:

```bash
echo "test" | gpg --symmetric --passphrase "your-passphrase" | gpg --decrypt --passphrase "your-passphrase"
```

1. If the passphrase is correct but still fails, clear GPG cache:

```bash
gpgconf --kill gpg-agent
```

1. Re-add encrypted files with the correct passphrase:

```bash
chezmoi re-add --encrypt ~/.config/service/credentials.json
```

### Problem: Secrets submodule not initializing

**Symptoms**:

- `secrets/` directory is empty or doesn't exist
- `git submodule status` shows `-<hash>` (uninitialized)
- Chezmoi init completes but no `.gitmodules` file exists

**Solution**:

1. Verify the secrets repository URL was set during init:

```bash
chezmoi data | grep secretsRepo
```

If empty, re-run init:

```bash
chezmoi init --force
```

1. Manually initialize the submodule:

```bash
cd ~/.local/share/chezmoi
git submodule init
git submodule update --remote
```

1. Check authentication to the private repository:

```bash
# Test SSH key access
ssh -T git@github.com

# Or manually clone
git clone git@github.com:username/dotfiles-secrets.git test-clone
```

1. Verify `.gitmodules` was created:

```bash
cat ~/.local/share/chezmoi/.gitmodules
```

If missing, manually create it:

```bash
cat <<EOF > ~/.local/share/chezmoi/.gitmodules
[submodule "secrets"]
    path = secrets
    url = git@github.com:username/dotfiles-secrets.git
EOF

git submodule init
git submodule update
```

### Problem: 1Password CLI authentication failures

**Symptoms**:

- `Error: failed to execute template: error calling onepasswordRead: exit status 1`
- `[ERROR] authentication required`
- Chezmoi cannot retrieve 1Password secrets

**Solution**:

1. Verify the 1Password CLI is authenticated:

```bash
op account list
```

If no accounts are listed, sign in:

```bash
# For service accounts
export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here"

# For user accounts
eval $(op signin)
```

1. Verify the service account token is set:

```bash
echo $OP_SERVICE_ACCOUNT_TOKEN
```

If empty, add to your shell profile:

```bash
# For Fish shell
set -Ux OP_SERVICE_ACCOUNT_TOKEN "ops_your_token_here"

# For Bash/Zsh
echo 'export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here"' >> ~/.bashrc
```

1. Test 1Password CLI directly:

```bash
op item get "TestItem" --vault "Private"
```

1. Verify chezmoi 1Password configuration:

```bash
chezmoi edit-config
```

Ensure `[onepassword].mode = "service"` is set.

1. Check the secret reference path format:

```bash
# Correct format
op://VaultName/ItemName/FieldName

# Example
op://Private/GitHub/token
```

Use `op item list` to verify vault and item names.

### Problem: Gitleaks false positives

**Symptoms**:

- Pre-commit hook fails on non-secret content
- Example code or documentation triggers secret detection
- Commits are blocked incorrectly

**Solution**:

1. Identify the false positive:

```bash
pre-commit run gitleaks --all-files
```

Note the file path, rule name, and line number.

1. Add to `.gitleaksignore`:

```bash
echo "path/to/file.ext:rule-name:line-number" >> ~/.local/share/chezmoi/.gitleaksignore
```

**Example**:

```bash
echo "docs/examples.md:generic-api-key:42" >> .gitleaksignore
```

1. Verify the exception works:

```bash
pre-commit run gitleaks --all-files
```

1. If you need to ignore an entire file:

```bash
# Add multiple lines for each detected secret in the file
path/to/file.ext:rule-1:10
path/to/file.ext:rule-2:25
```

1. For persistent issues, consider refactoring the code:

```diff
- API_KEY = "sk-test-abc123"  # Looks like a real secret
+ API_KEY = "sk-test-EXAMPLE"  # Clearly fake
```

### Problem: Encrypted files out of sync

**Symptoms**:

- Changes to encrypted files not appearing in target
- `chezmoi diff` shows differences but `chezmoi apply` doesn't fix them
- Encrypted files have wrong content after applying

**Solution**:

1. Verify the file is actually encrypted in the source directory:

```bash
ls -la ~/.local/share/chezmoi/encrypted_*
```

1. Re-add the file with encryption:

```bash
chezmoi re-add --encrypt ~/.config/service/credentials.json
```

1. Check for decryption errors:

```bash
chezmoi apply --verbose
```

1. Verify the passphrase hasn't changed:

```bash
chezmoi edit-config
```

1. Clear chezmoi cache and re-apply:

```bash
rm -rf ~/.cache/chezmoi
chezmoi apply --force
```

### Problem: Secrets appearing in dotfiles repository

**Symptoms**:

- Gitleaks scanning detects secrets in committed files
- Secrets accidentally committed to public repository
- GitHub secret scanning alerts

**Solution**:

**IMMEDIATE ACTION** (if secrets were pushed to GitHub):

1. Rotate the compromised secret immediately (change passwords, regenerate API keys)

2. Remove the secret from git history:

```bash
# Use BFG Repo-Cleaner or git-filter-repo
brew install bfg

# Remove the secret file from all history
bfg --delete-files credentials.json ~/.local/share/chezmoi

# Or remove secret strings
echo "secret-string-to-remove" > secrets.txt
bfg --replace-text secrets.txt ~/.local/share/chezmoi

# Force push (after confirming with team if shared repo)
cd ~/.local/share/chezmoi
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force
```

1. Verify the secret is removed:

```bash
git log --all --full-history -- path/to/file
```

**PREVENTION**:

1. Add the file pattern to `.chezmoiignore`:

```bash
echo "secrets" >> ~/.local/share/chezmoi/.chezmoiignore
echo "*.secret" >> ~/.local/share/chezmoi/.chezmoiignore
```

1. Use encryption for sensitive files:

```bash
chezmoi add --encrypt ~/.config/service/credentials.json
```

1. Move to 1Password for dynamic secrets:

```toml
# Instead of storing in files, use 1Password
{{ onepasswordRead "op://Private/ServiceAPI/token" }}
```

1. Ensure pre-commit hooks are installed:

```bash
cd ~/.local/share/chezmoi
pre-commit install
pre-commit run gitleaks --all-files
```

## Related Documentation

- [Installation Guide](../../INSTALL.md) - Initial dotfiles setup including secrets configuration
- [Chezmoi Workflow Guide](../../CHEZMOI.md) - Managing configuration changes with chezmoi
- [Troubleshooting Guide](../../TROUBLESHOOTING.md) - General troubleshooting for dotfiles
- [Chezmoi Official Docs](https://www.chezmoi.io/) - Comprehensive chezmoi documentation
- [1Password Service Accounts](https://developer.1password.com/docs/service-accounts/) - 1Password integration setup
- [Gitleaks Documentation](https://github.com/gitleaks/gitleaks) - Secret scanning configuration

## Notes

- The `secrets/` submodule is excluded from the target state via `.chezmoiignore`, so files inside it are never copied to `$HOME`. They exist solely for use in chezmoi templates and source configuration.

- The `.chezmoiscripts/run_once_before_1-setup-secrets-submodule.sh.tmpl` script only runs on local machines (not via SSH) to prevent remote machines from attempting to clone private repositories without proper authentication.

- GPG symmetric encryption uses the passphrase stored in `chezmoi.toml` with the `--batch` flag to avoid interactive prompts. The `--no-symkey-cache` flag prevents GPG from caching the passphrase.

- 1Password service account tokens should be set as environment variables (`OP_SERVICE_ACCOUNT_TOKEN`) rather than stored in configuration files to avoid accidental leakage.

- Gitleaks scanning runs automatically on every commit via pre-commit hooks. To bypass (not recommended), use `git commit --no-verify`, but this should only be done in exceptional circumstances.

- The `.gitleaksignore` file uses the format `path:rule:line` to ignore specific patterns. This is more precise than ignoring entire files, but can become verbose for files with many exceptions.

- When syncing dotfiles across multiple machines, ensure each machine has access to the secrets submodule repository (via SSH keys or PAT) and has the correct GPG passphrase configured.

- Rotating secrets stored in encrypted files requires re-encrypting with `chezmoi re-add --encrypt <file>` after updating the passphrase in `chezmoi.toml`.

- For team environments, consider using 1Password shared vaults instead of encrypted files or secrets submodules, as this provides better access control and audit logging.
