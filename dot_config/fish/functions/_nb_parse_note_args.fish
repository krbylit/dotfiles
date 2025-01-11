function _nb_parse_note_args
    # Initialize variables
    set -l path ""
    set -l filename ""
    set -l content ""

    switch (count $argv)
        case 1
            # Single argument: Either path or content
            if string match -q "*/*" $argv[1]
                set path $argv[1]
            else
                set content $argv[1]
            end
        case 2
            # Two arguments: First is path, second is content
            set path $argv[1]
            set content $argv[2]
        case '*'
            # Vaiable arguments: First is path, others are content
            set path $argv[1]
            set content (string join "\n" $argv[2..-1])
    end

    # Parse the path
    if test -n "$path"
        set filename (string match -r --groups-only ".*/(.*)\$" $path)
        set path (string match -r --groups-only "(.*/).*\$" $path)
        # Set empty path instead of "/"
        if test (string length $path) -eq 1
            set path ""
        end
        if not string match -q "*.*" $filename
            if test -n "$filename"
                set filename "$filename.md"
            end
        end
    end

    # Output results
    echo -e "$path\n$filename\n$content"
end
