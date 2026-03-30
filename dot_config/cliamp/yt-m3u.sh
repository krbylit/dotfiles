#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 PLAYLIST_URL OUTPUT_FILE [BROWSER]" >&2
  exit 1
fi

playlist_url="$1"
output_file="$2"
browser="${3:-chrome}"

{
  echo '#EXTM3U'
  yt-dlp --cookies-from-browser "$browser" \
    --flat-playlist \
    --print "%(title)s\t%(url)s" \
    "$playlist_url" |
    while IFS=$'\t' read -r title id; do
      printf '#EXTINF:-1,%s\n' "$title"
      printf 'https://www.youtube.com/watch?v=%s\n' "$id"
    done
} >"$output_file.m3u"
