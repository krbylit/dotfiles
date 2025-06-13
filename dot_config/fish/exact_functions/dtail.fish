function dtail
    set names (docker ps --format '{{.Names}}')
    if test -z "$names"
        echo "🚫 No running containers found."
        return 1
    end

    set filters
    for name in $names
        set filters $filters "CONTAINER_NAME=$name"
    end

    echo "📦 Tailing logs for: $names"
    journalctl -f -o short-iso $filters
end
