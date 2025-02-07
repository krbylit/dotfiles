function help --description 'colorized --help output'
    $argv --help 2>&1 | bat --plain --language=help
end
