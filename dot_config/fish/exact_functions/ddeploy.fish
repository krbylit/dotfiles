function ddeploy
    set DATESTAMP (date +%Y%m%d)
    set SESSION docker-build
    set LOGFILE "docker_build_{$DATESTAMP}_"(date +%H%M%S)".log"

    if tmux has-session -t docker-build ^/dev/null
        set SESSION "docker-build-{$DATESTAMP}"
        echo "⚠️ Existing 'docker-build' tmux session found."
    end

    echo "🚀 Starting new tmux session: $SESSION"
    echo "📄 Logging build output to: $LOGFILE"
    echo "Run 'dlog' to tail build output."
    echo "Run 'dtail' to tail container logs."
    echo "Run 'exportlogs' to dump container logs to CWD."

    tmux new-session -d -s $SESSION bash -c "
        echo 'Logging to $LOGFILE'
        docker compose build 2>&1 | tee \"$LOGFILE\" && \
        docker compose down && \
        docker compose up -d && \
        tmux kill-session -t \"$SESSION\"
    "
end
