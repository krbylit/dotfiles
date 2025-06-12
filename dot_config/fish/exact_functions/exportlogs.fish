function exportlogs
    if test (count $argv) -lt 1
        echo "Usage: exportlogs <container-name> [YYYYMMDD or json] [json]"
        return 1
    end

    set name $argv[1]
    set date ""
    set format short-iso
    set extension txt

    if test (count $argv) -ge 2
        if test $argv[2] = json
            set format json-pretty
            set extension json
        else if string match -rq '^[0-9]{8}$' -- $argv[2]
            set date $argv[2]
        end
    end

    if test (count $argv) -ge 3
        if test $argv[3] = json
            set format json-pretty
            set extension json
        end
    end

    set filename "$name-$date-logs.$extension"

    if test -n "$date"
        set since (string sub -s 1 -l 4 $date)"-"(string sub -s 5 -l 2 $date)"-"(string sub -s 7 -l 2 $date)" 00:00:00"
        set until (string sub -s 1 -l 4 $date)"-"(string sub -s 5 -l 2 $date)"-"(string sub -s 7 -l 2 $date)" 23:59:59"
        echo "📅 Exporting logs for '$name' on $date in $format format..."
        journalctl CONTAINER_NAME="$name" --since="$since" --until="$until" -o "$format" >"$filename"
    else
        echo "📦 Exporting last 1000 logs for '$name' in $format format..."
        journalctl CONTAINER_NAME="$name" -n 1000 -o "$format" >"$filename"
    end

    if test $status -eq 0
        echo "✅ Logs saved to $filename"
    else
        echo "❌ Failed to export logs. Check container name and journald configuration."
    end
end
