# set -gx NVM_DIR "$HOME/.nvm"
# set -gx nvm_default_version v23.6.1

fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines --shell fish | source
