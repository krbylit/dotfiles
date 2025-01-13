function _nb_upsert_note
    set path $argv[1]
    set filename $argv[2]
    set content $argv[3]
    set full_path (string join "" $path $filename)
    if test (nb list $full_path)
        if test -n "$content"
            nb edit $full_path --content $content
        else
            nb edit $full_path
        end
    else
        if test -n "$content"
            nb add $full_path --content $content
        else
            nb add $full_path --edit
        end
    end
end
