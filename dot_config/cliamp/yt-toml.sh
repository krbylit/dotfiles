#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 PLAYLIST_URL PLAYLIST_NAME [BROWSER]" >&2
  exit 1
fi

playlist_url="$1"
playlist_name="$2"
browser="${3:-chrome}"

output_file="./${playlist_name}.toml"

python3 - "$playlist_url" "$output_file" "$browser" <<'PY'
import subprocess
import sys
from pathlib import Path

playlist_url = sys.argv[1]
output_file = Path(sys.argv[2])
browser = sys.argv[3]

cmd = [
    "yt-dlp",
    "--cookies-from-browser", browser,
    "--flat-playlist",
    "--print", "%(title)s\t%(url)s",
    playlist_url,
]

proc = subprocess.run(cmd, capture_output=True, text=True)

if proc.returncode != 0:
    sys.stderr.write(proc.stderr)
    sys.exit(proc.returncode)

def toml_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')

lines = []
for raw_line in proc.stdout.splitlines():
    if not raw_line.strip():
        continue

    parts = raw_line.split("\t", 1)
    if len(parts) != 2:
        continue

    title, video_id = parts
    title = title.strip()
    video_id = video_id.strip()

    if not title or not video_id:
        continue

    path = f"https://www.youtube.com/watch?v={video_id}"

    lines.append("[[track]]")
    lines.append(f'path = "{toml_escape(path)}"')
    lines.append(f'title = "{toml_escape(title)}"')
    lines.append("")

output_file.write_text("\n".join(lines), encoding="utf-8")
print(output_file)
PY
