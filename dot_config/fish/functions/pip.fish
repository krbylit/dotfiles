# Lazy load pyenv to speed up shell startup
function pip
    # Only load once
    functions --erase pip

    # TODO: Figure out how to remove `(virutalenv)` from prompt
    set -e PYENV_VIRTUALENV_PROMPT
    set -e PYENV_VIRTUALENV_VERBOSE_ACTIVATE
    pyenv virtualenv-init - fish | source
    pyenv init - fish | source

    command pip $argv
end
