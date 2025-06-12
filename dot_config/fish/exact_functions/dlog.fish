function dlog
    ls -t docker_*.log | head -n 1 | xargs tail -f
end
