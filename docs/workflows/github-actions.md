# GitHub Actions Workflows

## Purpose

This workflow explains the automated synchronization system between the private dotfiles repository (`dotfiles-private`) and the public dotfiles repository (`dotfiles`). The GitHub Actions workflows enable automatic daily syncing from private to public while maintaining security of sensitive files and secrets.

## Prerequisites

- [x] GitHub repository pair: private (`krbylit/dotfiles-private`) and public (`krbylit/dotfiles`)
- [x] SSH deploy key configured in GitHub secrets (`DOTFILES_PRIVATE_KEY`)
- [x] `.chezmoiignore` patterns configured to exclude sensitive files
- [x] Workflow files present in `.github/workflows/` directory
- [x] Branch structure: `main` and `develop` in both repositories

## Workflows Overview

The system consists of four GitHub Actions workflows that maintain synchronization between private and public repositories:

### 1. Daily Sync Main (`daily_sync_main.yaml`)

**Purpose**: Synchronizes the `main` branch from private to public repository daily

**Trigger**:

- Scheduled: Daily at 1 AM UTC (`cron: "0 1 * * *"`)
- Manual: Can be triggered via `workflow_dispatch`

**What it does**:

- Checks out the public repository's `main` branch
- Adds the private repository as a Git remote using SSH authentication
- Force-syncs private `main` branch into public `main` branch
- Creates a squashed commit with the private commit hash
- Force pushes to public `main` branch

### 2. Daily Sync Dev (`daily_sync_dev.yaml`)

**Purpose**: Synchronizes the `develop` branch from private to public repository daily

**Trigger**:

- Scheduled: Daily at 1 AM UTC (`cron: "0 1 * * *"`)
- Manual: Can be triggered via `workflow_dispatch`

**What it does**:

- Checks out the public repository's `develop` branch
- Adds the private repository as a Git remote using SSH authentication
- Force-syncs private `develop` branch into public `develop` branch
- Creates a squashed commit with the private commit hash
- Force pushes to public `develop` branch

### 3. Initial Public Setup (`initial_public_setup.yaml`)

**Purpose**: One-time setup to initialize or reset the public repository from private repository state

**Trigger**: Manual only (`workflow_dispatch`)

**What it does**:

- Creates orphan branches to disconnect from previous history
- Removes all files except `.github/` directory
- Clones the private repository and copies all content
- Creates initial commits on both `main` and `develop` branches
- Force pushes both branches to public repository

**Use case**: First-time setup or complete repository reset

### 4. Rebase Dev on Main (`rebase_dev_on_main.yaml`)

**Purpose**: Automatically rebases `develop` branch onto `main` after PR merges

**Trigger**: Pull request closure where:

- PR was merged (not just closed)
- Base branch is `main`
- Head branch is `develop`

**What it does**:

- Fetches both `main` and `develop` branches
- Checks out `develop` branch
- Rebases `develop` onto `main`
- Force pushes rebased `develop` branch with lease protection

**Use case**: Keeps `develop` up-to-date after releasing features to `main`

## Architecture

### Repository Strategy

```
┌─────────────────────────────────┐
│  dotfiles-private (krbylit)     │
│  ├── main branch                │
│  ├── develop branch             │
│  └── Contains ALL files         │
│      (including secrets)        │
└─────────────────────────────────┘
            │
            │ Daily Sync (1 AM UTC)
            │ GitHub Actions
            ▼
┌─────────────────────────────────┐
│  dotfiles (krbylit)             │
│  ├── main branch                │
│  ├── develop branch             │
│  └── Contains PUBLIC files      │
│      (secrets excluded)         │
└─────────────────────────────────┘
```

### Security Model

**What gets synced to public**:

- Configuration files for all tools (Fish, Neovim, Karabiner, skhd, Yabai, etc.)
- Documentation files (README.md, INSTALL.md, TROUBLESHOOTING.md, etc.)
- Scripts and automation (`.chezmoiscripts/`)
- GitHub Actions workflow definitions

**What gets excluded from public** (via `.chezmoiignore`):

- `secrets/` directory (private git submodule)
- `.aiderignore`, `.aider.*` files
- Root `README.md` (contains private notes)
- `cm-util/` directory (symlink utilities)

### Repository Gating

All workflows include a `check_repo` job that ensures they only run on the **public** repository (`krbylit/dotfiles`):

```yaml
check_repo:
  runs-on: ubuntu-latest
  outputs:
    should_run: ${{ steps.check.outputs.should_run }}
  steps:
    - id: check
      run: |
        if [[ "${{ github.repository }}" == "krbylit/dotfiles" ]]; then
          echo "should_run=true" >> $GITHUB_OUTPUT
        else
          echo "should_run=false" >> $GITHUB_OUTPUT
        fi
```

**Rationale**: Workflow definitions must exist in the private repository (source of truth), but should only execute in the public repository. Without this check, workflows would override themselves when syncing from private to public.

## Step-by-Step Procedures

### Set Up SSH Authentication

This procedure configures the SSH deploy key that allows GitHub Actions to access the private repository.

#### Step 1: Generate an SSH key pair

On your local machine:

```bash
ssh-keygen -t ed25519 -C "github-actions-dotfiles-sync" -f ~/.ssh/dotfiles_sync_key
```

**Expected result**: Two files are created:

- `~/.ssh/dotfiles_sync_key` (private key)
- `~/.ssh/dotfiles_sync_key.pub` (public key)

#### Step 2: Add public key as deploy key to private repository

1. Navigate to your private repository on GitHub: `https://github.com/krbylit/dotfiles-private/settings/keys`
2. Click "Add deploy key"
3. **Title**: `GitHub Actions Sync`
4. **Key**: Paste the contents of `~/.ssh/dotfiles_sync_key.pub`
5. **Allow write access**: Unchecked (read-only access is sufficient)
6. Click "Add key"

**Expected result**: Deploy key appears in the private repository's deploy keys list

#### Step 3: Add private key as GitHub secret to public repository

1. Copy the private key to clipboard:

   ```bash
   cat ~/.ssh/dotfiles_sync_key | pbcopy
   ```

2. Navigate to public repository secrets: `https://github.com/krbylit/dotfiles/settings/secrets/actions`
3. Click "New repository secret"
4. **Name**: `DOTFILES_PRIVATE_KEY`
5. **Value**: Paste the private key
6. Click "Add secret"

**Expected result**: Secret `DOTFILES_PRIVATE_KEY` appears in the public repository's secrets list

#### Step 4: Verify SSH authentication in workflow

The workflow uses this secret to authenticate:

```yaml
- name: Add Private Repo as Remote
  run: |
    mkdir -p ~/.ssh
    echo "${{ secrets.DOTFILES_PRIVATE_KEY }}" > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ssh-keyscan github.com >> ~/.ssh/known_hosts
    git remote add private git@github.com:krbylit/dotfiles-private.git
    git fetch private main
```

**Verification**: Check the next scheduled run or trigger manually (see "Manually Trigger a Sync")

#### Step 5: Secure the private key

```bash
# Remove the private key from your local machine (it's now in GitHub secrets)
rm ~/.ssh/dotfiles_sync_key ~/.ssh/dotfiles_sync_key.pub
```

**Security note**: The private key stored in GitHub secrets is encrypted at rest and only exposed during workflow execution in isolated runners.

### Manually Trigger a Sync

This procedure shows how to manually trigger a sync workflow outside the scheduled daily run.

#### Step 1: Navigate to GitHub Actions

1. Go to the public repository: `https://github.com/krbylit/dotfiles`
2. Click the "Actions" tab
3. Select the workflow you want to run:
   - "Daily Sync from Private Main"
   - "Daily Sync from Private Dev"
   - "Initial Public Repo Setup" (use cautiously - resets history)

#### Step 2: Trigger the workflow

1. Click "Run workflow" button on the right
2. Select the branch (should be `main` for the Actions to run from)
3. Click the green "Run workflow" button

**Expected result**: Workflow appears in the workflow runs list with status "queued" or "in progress"

#### Step 3: Monitor the workflow execution

1. Click on the workflow run to see details
2. Watch the job steps execute:
   - `check_repo` - Verifies running on public repository
   - `sync_main` or `sync_dev` - Performs the actual sync
3. Each step shows real-time logs

**Expected result**: All steps complete with green checkmarks

#### Step 4: Verify the sync

Check the latest commit on the synced branch:

```bash
# For main branch
git log -1 origin/main

# For develop branch
git log -1 origin/develop
```

**Expected result**: Commit message contains the private repository commit hash and timestamp:

```
abc123def456789 Thu Dec 12 01:00:00 UTC 2024
```

### Configure .chezmoiignore Exclusions

This procedure explains how to control which files are synced from private to public.

#### Step 1: Understand .chezmoiignore patterns

The `.chezmoiignore` file uses patterns to exclude files from the chezmoi target state. While primarily for chezmoi, these patterns also indicate what should stay private:

```
# Current .chezmoiignore
README.md           # Root README with private notes
cm-util            # Symlink utility directory
secrets            # Private git submodule
.aiderignore       # Aider AI tool config
.aider.input.history
.aider.chat.history.md
.aider.tags*
```

**Pattern syntax**:

- Exact match: `README.md` (only matches root README.md)
- Directory: `secrets` (matches directory and all contents)
- Wildcard: `*.secret` (matches all files ending in .secret)
- Glob: `**/*.env` (matches .env files in all subdirectories)

#### Step 2: Add new exclusion patterns

To exclude additional files/directories from the public repository:

```bash
# Edit .chezmoiignore
chezmoi edit ~/.chezmoiignore

# Or edit directly
vim ~/.local/share/chezmoi/.chezmoiignore
```

**Example additions**:

```
# Private API configurations
.config/private-service/

# Machine-specific secrets
.ssh/config.private

# Development tools
.cursor/
.vscode/
```

#### Step 3: Test exclusion patterns

Before committing, verify what would be excluded:

```bash
cd ~/.local/share/chezmoi

# List all tracked files
git ls-files

# Manually check if pattern matches what you expect
# (Note: .chezmoiignore affects chezmoi behavior, not git)
```

**Expected result**: Files matching `.chezmoiignore` patterns should not appear in the public repository after sync.

#### Step 4: Commit and sync

```bash
cd ~/.local/share/chezmoi
git add .chezmoiignore
git commit -m "chore: update .chezmoiignore exclusions"
git push origin main
```

**Expected result**: Next scheduled sync (or manual trigger) will respect the new exclusions.

#### Step 5: Verify exclusions in public repository

After the workflow runs:

```bash
# Clone the public repository
git clone https://github.com/krbylit/dotfiles.git /tmp/dotfiles-public
cd /tmp/dotfiles-public

# Verify excluded files are not present
ls -la secrets/  # Should not exist
ls -la cm-util/  # Should not exist
cat README.md    # Should not exist
```

**Expected result**: Excluded files/directories are not present in the public repository.

**Important**: The GitHub Actions sync performs a **full file replacement** (`git rm -rf . && git checkout private/main -- .`), so exclusions must be handled by not having those files in the private repository's tracked state, or by using `.gitignore` in the private repo.

**Correction**: The `.chezmoiignore` patterns don't directly affect what GitHub Actions syncs. To exclude files from the public sync, you need to:

1. Add them to `.gitignore` in the private repository, or
2. Modify the sync workflow to explicitly exclude patterns during the `git checkout` step

**Current behavior**: The workflow syncs **everything** from private to public. The `.chezmoiignore` only affects chezmoi's target state (what gets applied to `$HOME`), not what gets committed to Git.

**Recommended approach for sensitive files**:

- Keep them in a separate private git submodule (`secrets/`)
- Add the submodule directory to `.gitignore` in the private repo
- The submodule won't be cloned during the GitHub Actions sync

### Handle Encrypted Files

This procedure explains how the sync handles GPG-encrypted files and age-encrypted files.

#### Understanding encrypted file handling

**Current behavior**: Encrypted files in the private repository (e.g., `encrypted_*.asc` or `*.age`) are synced to the public repository **as-is** (still encrypted).

**Security implication**:

- Encrypted files are safe to sync publicly if the encryption is strong
- The decryption passphrase/key is NOT synced (stored in `chezmoi.toml` or environment)
- Public repository users cannot decrypt without the passphrase

**Example encrypted files**:

```
encrypted_dot_config/service/credentials.json.asc  # GPG symmetric encryption
encrypted_private-key.age                          # Age encryption
```

#### Step 1: Verify encrypted files are safe to sync

Before allowing encrypted files in public:

```bash
cd ~/.local/share/chezmoi

# List all encrypted files
find . -name "encrypted_*" -o -name "*.age"

# Verify each file is properly encrypted (not plaintext)
cat encrypted_dot_config/service/credentials.json.asc | head -5
```

**Expected result**: File contents show encrypted data (GPG ASCII armor or binary):

```
-----BEGIN PGP MESSAGE-----

jA0EBwMClTA7TpCBLNlg0kMBnP8AzG8m6r4VfYqFEhR...
-----END PGP MESSAGE-----
```

If you see plaintext, the file was not encrypted correctly.

#### Step 2: Ensure decryption keys are not in repository

**Critical check**: Verify that decryption passphrases and keys are **not** committed:

```bash
cd ~/.local/share/chezmoi

# Check for accidental passphrase storage
git grep -i "passphrase" | grep -v ".asc"

# Check for private keys
git grep "BEGIN PRIVATE KEY"

# Check chezmoi.toml is not committed (it contains passphrase)
git ls-files | grep chezmoi.toml
```

**Expected result**: No matches (passphrases should be in `~/.config/chezmoi/chezmoi.toml`, not in the chezmoi source directory)

**Important**: The `~/.config/chezmoi/chezmoi.toml` file is **outside** the chezmoi source directory and is not tracked by Git or synced to the public repository.

#### Step 3: Understand sync workflow behavior

The sync workflow does **not** decrypt files:

```yaml
# Full overwrite: Replace working directory with private repo state
git rm -rf .
git checkout private/main -- .
git add -A
```

This means:

- Encrypted files remain encrypted in transit and in the public repository
- The workflow runner never has access to decryption keys
- Users cloning the public repository will receive encrypted files

#### Step 4: Document encryption for public users

If your public repository contains encrypted files, add a note to `README.md`:

```markdown
## Encrypted Files

Some configuration files are encrypted using GPG symmetric encryption. To use these dotfiles:

1. You'll need to decrypt these files with your own passphrase:
   ```bash
   chezmoi init --apply <your-fork>
   ```
1. Or remove the encrypted files and replace with your own configurations

Encrypted files are marked with the `encrypted_*` prefix.

```

#### Step 5: Exclude truly sensitive files

For files that should **never** be public (even encrypted):

```bash
# Add to private repository's .gitignore
echo "highly-sensitive-file.txt" >> ~/.local/share/chezmoi/.gitignore

# Commit the .gitignore update
cd ~/.local/share/chezmoi
git add .gitignore
git commit -m "chore: exclude highly sensitive file from git"
git push origin main
```

**Expected result**: File will not be synced to public repository (not tracked by Git).

### Monitor Workflow Status

This procedure shows how to monitor and investigate workflow runs.

#### Step 1: View workflow runs

1. Navigate to Actions tab: `https://github.com/krbylit/dotfiles/actions`
2. See list of all workflow runs with status:
   - ✅ Green checkmark: Success
   - ❌ Red X: Failure
   - 🟡 Yellow circle: In progress
   - ⚪ Gray circle: Queued

#### Step 2: Inspect a specific run

1. Click on a workflow run to see details
2. View the workflow visualization showing job dependencies
3. Click on a job (e.g., `sync_main`) to see step-by-step logs

**Example successful run**:

```
✅ check_repo (3s)
✅ sync_main (45s)
  ✅ Checkout Public Main Branch (8s)
  ✅ Set Up Git User (1s)
  ✅ Add Private Repo as Remote (12s)
  ✅ Force Sync Private Main into Public Main (24s)
```

#### Step 3: Check for errors

If a workflow fails:

1. Click on the failed job
2. Expand the failed step (marked with ❌)
3. Read the error message in the logs

**Common errors**:

- **SSH authentication failure**: `Permission denied (publickey)`
  - **Cause**: `DOTFILES_PRIVATE_KEY` secret is missing or incorrect
  - **Fix**: Re-add the deploy key (see "Set Up SSH Authentication")

- **No changes to commit**: `nothing to commit, working tree clean`
  - **Cause**: No new changes in private repository since last sync
  - **Fix**: This is not an error - the workflow exits early (exit code 0)

- **Git conflict**: `error: Your local changes to the following files would be overwritten`
  - **Cause**: Uncommitted changes in the public repository (manual edits)
  - **Fix**: The workflow uses `git pull origin main || true` to ignore conflicts, then force-syncs

#### Step 4: Download workflow logs

For detailed debugging:

1. Click the ⋯ (three dots) menu on the workflow run
2. Select "Download log archive"
3. Extract the ZIP file and read logs offline

**Log structure**:

```
workflow-run-logs/
├── 1_check_repo/
│   └── 1_check.txt
└── 2_sync_main/
    ├── 1_Checkout Public Main Branch.txt
    ├── 2_Set Up Git User.txt
    ├── 3_Add Private Repo as Remote.txt
    └── 4_Force Sync Private Main into Public Main.txt
```

#### Step 5: Set up workflow notifications

To receive alerts on workflow failures:

1. Go to `https://github.com/settings/notifications`
2. Under "Actions", enable "Email" for failed workflows
3. Optionally, set up a GitHub App (e.g., Slack integration) for real-time notifications

**Expected result**: You'll receive an email when workflows fail.

## Verification

To verify the GitHub Actions synchronization is working correctly:

### 1. Verify workflows are enabled

```bash
# Check workflow files exist
ls -la ~/.local/share/chezmoi/.github/workflows/
```

**Expected**: Four workflow files present:

- `daily_sync_main.yaml`
- `daily_sync_dev.yaml`
- `initial_public_setup.yaml`
- `rebase_dev_on_main.yaml`

### 2. Verify SSH secret is configured

1. Go to `https://github.com/krbylit/dotfiles/settings/secrets/actions`
2. Confirm `DOTFILES_PRIVATE_KEY` is listed

**Expected**: Secret exists and shows "Updated X days ago"

### 3. Verify recent sync succeeded

```bash
# Clone public repository
git clone https://github.com/krbylit/dotfiles.git /tmp/dotfiles-public
cd /tmp/dotfiles-public

# Check last commit on main
git log -1 --oneline main

# Check last commit on develop
git log -1 --oneline develop
```

**Expected**: Commit messages contain commit hashes and recent timestamps (within last 24 hours if daily sync is working)

### 4. Verify excluded files are not in public repo

```bash
cd /tmp/dotfiles-public

# These should NOT exist
ls secrets/        # Should fail with "No such file or directory"
ls cm-util/        # Should fail
cat README.md      # Should fail (if excluded via .gitignore in private repo)
```

**Expected**: Sensitive files are absent from public repository

### 5. Verify workflow run history

1. Go to `https://github.com/krbylit/dotfiles/actions`
2. Check "Daily Sync from Private Main" and "Daily Sync from Private Dev"
3. Verify runs occur daily at ~1 AM UTC

**Expected**: Workflow runs show regular daily execution with success status

## Troubleshooting

### Problem: Daily sync workflow is not running

**Symptoms**:

- No workflow runs appear in Actions tab
- Last run was more than 24 hours ago
- Scheduled workflows are not triggering

**Solution**:

1. **Verify workflows are enabled**:
   - Go to repository Settings → Actions → General
   - Ensure "Allow all actions and reusable workflows" is selected
   - Ensure "Workflow permissions" is set to "Read and write permissions"

2. **Check if workflow files are on default branch**:

   ```bash
   cd ~/.local/share/chezmoi
   git checkout main
   ls -la .github/workflows/
   ```

   **Expected**: Workflow files exist on `main` branch (GitHub Actions only runs workflows from default branch)

3. **Manually trigger a workflow**:
   - Go to Actions → Select workflow → "Run workflow"
   - If manual trigger works but scheduled runs don't, the issue is with the cron schedule

4. **Verify cron syntax**:

   ```yaml
   schedule:
     - cron: "0 1 * * *"  # Correct: Daily at 1 AM UTC
   ```

   **Note**: GitHub Actions schedules are in UTC. Convert to your timezone:
   - 1 AM UTC = 5 PM PST (previous day)
   - 1 AM UTC = 6 PM PDT (previous day)

5. **Check repository activity**:
   GitHub disables scheduled workflows in repositories with no activity for 60 days. To re-enable:
   - Make any commit to the repository
   - Or manually trigger the workflow once

### Problem: SSH authentication failed

**Symptoms**:

- Workflow fails at "Add Private Repo as Remote" step
- Error message: `Permission denied (publickey)`
- Error message: `fatal: Could not read from remote repository`

**Solution**:

1. **Verify the secret exists**:
   - Go to `https://github.com/krbylit/dotfiles/settings/secrets/actions`
   - Confirm `DOTFILES_PRIVATE_KEY` is present

   If missing, follow "Set Up SSH Authentication" procedure.

2. **Verify the deploy key is added to private repo**:
   - Go to `https://github.com/krbylit/dotfiles-private/settings/keys`
   - Confirm deploy key is present and labeled "GitHub Actions Sync"

   If missing, re-add the public key.

3. **Check the secret contains the full private key**:
   The secret should include:

   ```
   -----BEGIN OPENSSH PRIVATE KEY-----
   b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAA...
   -----END OPENSSH PRIVATE KEY-----
   ```

   **Fix**: If the secret is truncated or malformed, delete and re-add it.

4. **Verify SSH key format**:
   GitHub Actions requires OpenSSH format (`ed25519` or `rsa`). If you see:

   ```
   Error loading key: invalid format
   ```

   Regenerate the key:

   ```bash
   ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/dotfiles_sync_key
   ```

5. **Test SSH authentication locally**:

   ```bash
   # Load the private key (from GitHub secret)
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/dotfiles_sync_key

   # Test connection to private repo
   ssh -T git@github.com
   git ls-remote git@github.com:krbylit/dotfiles-private.git
   ```

   **Expected**: Remote branches listed without errors.

### Problem: Workflow succeeds but public repo not updated

**Symptoms**:

- Workflow shows ✅ success
- But public repository doesn't have latest changes from private repo
- Commit hash in public doesn't match private

**Solution**:

1. **Check if workflow skipped due to no changes**:
   View the workflow logs → "Force Sync Private Main into Public Main" step:

   ```
   No changes to commit. Branch is up to date.
   ```

   This is expected if there were no new commits in private repo since last sync.

2. **Verify private repository has new commits**:

   ```bash
   cd ~/.local/share/chezmoi
   git log -5 --oneline
   ```

   Compare commit hashes with public repository:

   ```bash
   git clone https://github.com/krbylit/dotfiles.git /tmp/dotfiles-public
   cd /tmp/dotfiles-public
   git log -1
   ```

3. **Check if force push succeeded**:
   Look for this in workflow logs:

   ```
   + git push origin main --force
   To github.com:krbylit/dotfiles.git
    + abc123...def456 main -> main (forced update)
   ```

   If you see an error here, check repository permissions.

4. **Verify repository permissions**:
   - Go to repository Settings → Actions → General
   - Under "Workflow permissions", ensure "Read and write permissions" is selected
   - Save changes

5. **Manually verify sync**:

   ```bash
   # Clone both repositories
   git clone git@github.com:krbylit/dotfiles-private.git /tmp/private
   git clone git@github.com:krbylit/dotfiles.git /tmp/public

   # Compare file trees
   diff -r /tmp/private /tmp/public --exclude=.git --exclude=secrets
   ```

   **Expected**: No differences (except excluded directories)

### Problem: Rebase workflow fails after PR merge

**Symptoms**:

- "Rebase Dev on Main" workflow fails after merging a develop → main PR
- Error message: `error: could not apply abc123... commit message`
- Develop branch has conflicts with main

**Solution**:

1. **Understand the conflict**:
   The rebase workflow tries to replay `develop` commits on top of `main`. If there are conflicting changes, the rebase fails.

2. **Manually resolve the rebase**:

   ```bash
   cd ~/.local/share/chezmoi

   # Fetch latest changes
   git fetch origin main
   git fetch origin develop

   # Checkout develop and rebase
   git checkout develop
   git rebase main

   # If conflicts occur, resolve them
   git status  # Shows conflicted files

   # Edit conflicted files, then
   git add <resolved-files>
   git rebase --continue

   # Force push the rebased develop
   git push origin develop --force-with-lease
   ```

3. **Prevent future conflicts**:
   - Keep `develop` up-to-date by regularly merging or rebasing from `main`
   - Avoid making changes directly to `main` outside of PRs
   - Use linear history (rebase instead of merge commits)

4. **Alternative: Merge instead of rebase**:
   If you prefer merge commits, modify the workflow:

   ```yaml
   - name: Merge `main` into `develop`
     run: |
       git checkout develop
       git merge main --no-ff
   ```

   This avoids rebase conflicts but creates merge commits.

5. **Skip the rebase workflow**:
   If the workflow is blocked, manually rebase and push (step 2 above), then re-run the workflow or skip it.

### Problem: Workflow runs on private repository instead of public

**Symptoms**:

- Workflow runs appear on `dotfiles-private` repository's Actions tab
- Workflow logs show "should_run=false" and jobs are skipped
- No sync occurs

**Solution**:

This is **expected behavior** due to the repository gating check:

```yaml
check_repo:
  outputs:
    should_run: ${{ steps.check.outputs.should_run }}
  steps:
    - id: check
      run: |
        if [[ "${{ github.repository }}" == "krbylit/dotfiles" ]]; then
          echo "should_run=true" >> $GITHUB_OUTPUT
        else
          echo "should_run=false" >> $GITHUB_OUTPUT
        fi
```

**Why this happens**:

- Workflow files exist in both private and public repositories (copied during sync)
- Workflows execute wherever they are defined
- The `check_repo` gate ensures actual work only happens in the public repo

**Verification**:

1. Check the `check_repo` job output in the workflow run
2. If `should_run=false`, the workflow correctly skipped (running on private repo)
3. Check the public repository's Actions tab for the actual sync

**No action needed**: This is the intended design. Workflows are defined in private repo (source of truth) but only execute in public repo.

### Problem: Encrypted files are decrypted in public repository

**Symptoms**:

- Files with `encrypted_` prefix appear as plaintext in public repository
- Sensitive data is visible in GitHub web interface
- GPG/age encryption was bypassed

**IMMEDIATE ACTION**:

1. **Rotate all exposed secrets immediately**:
   - Change passwords
   - Regenerate API keys
   - Revoke compromised credentials

2. **Remove sensitive data from public repository history**:

   ```bash
   # Clone public repository
   git clone https://github.com/krbylit/dotfiles.git /tmp/dotfiles-public
   cd /tmp/dotfiles-public

   # Use BFG Repo-Cleaner to remove sensitive files
   brew install bfg
   bfg --delete-files "sensitive-file.txt" .

   # Or use git-filter-repo
   git filter-repo --path sensitive-file.txt --invert-paths

   # Force push cleaned history
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```

3. **Make repository temporarily private**:
   - Go to repository Settings → Danger Zone
   - Click "Change visibility" → "Make private"
   - This prevents further exposure while you clean up

**ROOT CAUSE ANALYSIS**:

Encrypted files should **never** be decrypted during the sync. The workflow does:

```yaml
git checkout private/main -- .  # Copies files as-is
```

If files appear decrypted in public, one of these occurred:

1. **Files were never encrypted in private repo**:

   ```bash
   cd ~/.local/share/chezmoi
   cat encrypted_file.asc  # Should show encrypted content, not plaintext
   ```

   **Fix**: Re-encrypt the file:

   ```bash
   chezmoi re-add --encrypt ~/.config/service/credentials.json
   ```

2. **Chezmoi applied and committed decrypted target state**:
   If you accidentally ran:

   ```bash
   chezmoi apply
   cd ~
   git add .config/service/credentials.json  # Decrypted version
   git commit
   ```

   **Fix**: Never commit from `$HOME`. Only commit from `~/.local/share/chezmoi`.

3. **Workflow has a custom decryption step**:
   Review `.github/workflows/daily_sync_*.yaml` for any GPG/age decryption commands.

   **Fix**: Remove decryption steps from workflow.

**PREVENTION**:

1. **Verify encryption before committing**:

   ```bash
   cd ~/.local/share/chezmoi
   cat encrypted_* | head -5  # Should show encrypted data
   ```

2. **Use pre-commit hooks to block plaintext secrets**:
   The existing gitleaks hook should catch this. Ensure it's enabled:

   ```bash
   cd ~/.local/share/chezmoi
   pre-commit run gitleaks --all-files
   ```

3. **Use secrets submodule for highly sensitive data**:
   Instead of encrypting files, store them in the `secrets/` submodule (excluded from public sync).

### Problem: Public repository is out of sync with private

**Symptoms**:

- Public repository has commits not present in private
- Diverged history between repositories
- Workflow fails with "non-fast-forward" errors

**Solution**:

1. **Identify the divergence**:

   ```bash
   # Clone both repositories
   git clone git@github.com:krbylit/dotfiles-private.git /tmp/private
   git clone git@github.com:krbylit/dotfiles.git /tmp/public

   # Compare commit histories
   cd /tmp/private
   git log --oneline -10 main > /tmp/private-commits.txt

   cd /tmp/public
   git log --oneline -10 main > /tmp/public-commits.txt

   diff /tmp/private-commits.txt /tmp/public-commits.txt
   ```

2. **Determine the cause**:
   - **Manual commits to public repo**: Someone committed directly to public (not recommended)
   - **Workflow force-push failed**: Network issue or permissions error during push
   - **Private repo was force-pushed**: History rewrite in private repo

3. **Reset public repository to match private** (DESTRUCTIVE):

   **Warning**: This erases public repository history. Only use if public repo should always mirror private.

   ```bash
   # Manual method
   cd /tmp/public
   git fetch origin
   git reset --hard <private-repo-commit-hash>
   git push origin main --force
   ```

   **Or use the Initial Public Setup workflow**:
   - Go to Actions → "Initial Public Repo Setup" → "Run workflow"
   - This completely resets public repo from private repo state

4. **Merge public changes back into private** (if public has valuable commits):

   ```bash
   cd ~/.local/share/chezmoi
   git remote add public https://github.com/krbylit/dotfiles.git
   git fetch public main
   git merge public/main
   git push origin main
   ```

   Next sync will then include those commits.

5. **Prevent future divergence**:
   - **Never commit directly to public repository**
   - All changes should go through private repo → automatic sync
   - Use branch protection rules on public repo to prevent direct pushes to `main`

## Related Documentation

- [Secrets Management](./secrets-management.md) - Managing sensitive data, encryption, and the secrets submodule
- [Multi-Machine Synchronization](./multi-machine-sync.md) - Syncing dotfiles across multiple machines
- [Configuration Changes](./configuration-changes.md) - Making changes to dotfiles using chezmoi workflow
- [Troubleshooting Guide](../../TROUBLESHOOTING.md) - General troubleshooting for dotfiles
- [GitHub Actions Documentation](https://docs.github.com/en/actions) - Official GitHub Actions reference
- [Git SSH Authentication](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) - Setting up SSH keys for GitHub

## Notes

- **Force push behavior**: All sync workflows use `git push --force` to ensure the public repository exactly mirrors the private repository. This means any manual changes to the public repository will be overwritten on the next sync.

- **Workflow files in both repos**: Workflow definitions exist in both private and public repositories (they get synced). However, the `check_repo` gate ensures they only execute on the public repository. This design allows the private repository to be the single source of truth.

- **Scheduled workflow limitations**: GitHub disables scheduled workflows after 60 days of repository inactivity. To re-enable, make any commit or manually trigger a workflow.

- **Commit message format**: Sync workflows create squashed commits with the format `<private-commit-hash> <timestamp>`. The original commit messages from the private repository are preserved in commented-out code but not currently included in the sync commit.

- **Branch synchronization**: The system syncs both `main` and `develop` branches independently. Changes to one branch in private will only sync to the same branch in public, not across branches.

- **Rebase workflow timing**: The `rebase_dev_on_main.yaml` workflow only triggers on merged PRs where `develop` was merged into `main`. It does not run on every PR merge, only when releasing features from develop to main.

- **SSH key permissions**: The deploy key added to the private repository only requires read access (not write). The sync is a one-way pull from private to public, so GitHub Actions doesn't need to push to the private repository.

- **Secrets in workflow logs**: GitHub automatically redacts registered secrets (like `DOTFILES_PRIVATE_KEY`) from workflow logs. If a secret appears in logs, it will show as `***` instead of the actual value.

- **Alternative: Git submodules**: This sync approach uses GitHub Actions. An alternative architecture would use the public repository as a git submodule of the private repository, but this requires manual pushes and doesn't support automatic synchronization.

- **Public repository purpose**: The public repository serves as a portfolio/showcase of dotfiles configuration and can be forked by others. The private repository retains sensitive configurations and the secrets submodule.
