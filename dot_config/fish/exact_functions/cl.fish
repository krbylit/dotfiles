function cl --wraps='claude' --description 'Claude Code in Zellij'
    set -l id (random 100000 999999)

    set -l session "claude-$id"

    set -l layout_file (mktemp /tmp/claude-zellij.$session.kdl)

    printf '%s\n' \
        'layout {' \
        '    default_tab_template {' \
        '        pane size=1 borderless=true {' \
        '            plugin location="zellij:tab-bar"' \
        '        }' \
        '        children' \
        '        pane size=1 borderless=true {' \
        '            plugin location="zellij:status-bar"' \
        '        }' \
        '    }' \
        '    tab name="claude" {' \
        '        pane command="claude"' \
        '    }' \
        '}' >"$layout_file"

    zellij -n "$layout_file" -s $session

    rm -f "$layout_file"
end
