function ytm --description "Run cliamp ytmusic with a yt-dlp wrapper that rewrites music.youtube.com URLs"
    set -l wrapdir (mktemp -d)
    set -l real_ytdlp (command -s yt-dlp)

    if test -z "$real_ytdlp"
        echo "yt-dlp not found in PATH" >&2
        return 1
    end

    printf '%s\n' \
        '#!/usr/bin/env bash' \
        'set -euo pipefail' \
        '' \
        "real_ytdlp=\"$real_ytdlp\"" \
        '' \
        'args=()' \
        'for arg in "$@"; do' \
        '  args+=("${arg//music.youtube.com\/watch/www.youtube.com\/watch}")' \
        done \
        '' \
        'exec "$real_ytdlp" "${args[@]}"' >"$wrapdir/yt-dlp"

    chmod +x "$wrapdir/yt-dlp"

    env PATH="$wrapdir:$PATH" cliamp --provider yt $argv
    set -l status_code $status

    rm -rf "$wrapdir"
    return $status_code
end
# Why this wrapper exists:
#
# We diagnosed a playback bug specific to cliamp's YouTube Music provider path.
#
# What worked:
# - cliamp could authenticate to YouTube Music and list private playlists/tracks.
# - Plain YouTube playback inside cliamp worked.
# - Manual playback worked when resolving a track with:
#     yt-dlp --cookies-from-browser safari -f ba -g 'https://www.youtube.com/watch?v=VIDEO_ID'
#   and then feeding that result to ffplay.
#
# What failed:
# - Tracks loaded from cliamp's YouTube Music provider failed at playback with:
#     "ERR: waiting for audio data: EOF"
# - Manual resolution/playback of the equivalent:
#     https://music.youtube.com/watch?v=VIDEO_ID
#   failed with HTTP 403, while the equivalent:
#     https://www.youtube.com/watch?v=VIDEO_ID
#   worked.
#
# Root cause:
# - The problem is not OAuth, playlist import, browser cookies, ffplay, or generic yt-dlp usage.
# - The problem is that cliamp's YouTube Music provider constructs track URLs using the
#   music.youtube.com/watch form.
# - In this environment, yt-dlp/ffplay can successfully play the www.youtube.com/watch form,
#   but the music.youtube.com/watch form resolves to a media URL that then 403s during playback.
# - Result: cliamp successfully loads playlist metadata, but the playback pipeline gets no audio
#   data and eventually reports EOF.
#
# What this wrapper does:
# - It temporarily shadows yt-dlp in PATH only for this cliamp launch.
# - Any argument containing a music.youtube.com/watch URL is rewritten to the equivalent
#   www.youtube.com/watch URL before delegating to the real yt-dlp binary.
# - This preserves cliamp's normal workflow while sidestepping the bad URL form.
#
# Why this is only a workaround:
# - The real bug is upstream in cliamp's YouTube Music playback path, not in this shell setup.
# - We are compensating for a bad URL emitted by cliamp rather than fixing the source.
#
# Robust permanent fix:
# 1. Fix cliamp:
#    Change the YouTube Music provider to emit/play tracks as:
#      https://www.youtube.com/watch?v=VIDEO_ID
#    instead of:
#      https://music.youtube.com/watch?v=VIDEO_ID
#    This is the correct long-term fix.
#
# 2. Optional upstream investigation:
#    It may also be worth understanding why yt-dlp/ffplay succeeds for www.youtube.com URLs but
#    not for the equivalent music.youtube.com URLs in this environment. However, since cliamp can
#    already work with the www.youtube.com form, cliamp should be fixed regardless.
#
# 3. Do not try to "fix" ffplay:
#    ffplay is only consuming the resolved media URL it is given. It is not the source of the bug.
#
# 4. Do not rely on this wrapper forever:
#    This is a local compatibility shim. If cliamp changes how it invokes yt-dlp, or if yt-dlp
#    argument handling changes, this wrapper may stop helping.
