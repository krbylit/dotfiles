# set -gx NVM_DIR "$HOME/.nvm"
# set -gx nvm_default_version v23.6.1

# Initialize fnm if available
if command -q fnm
    fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines --log-level=quiet --shell fish | source
end

set -gx FNM_LOGLEVEL quiet
