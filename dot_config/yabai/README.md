# Yabai notes

## How to revert to older version of yabai

- Download desired `.tar.gz` from releases page on GitHub
- `brew edit koekeishiya/formulae/yabai`
- Change URL to desired version and update checksum
  ```
  url "https://github.com/koekeishiya/yabai/releases/download/v7.1.6/yabai-v7.1.6.tar.gz"
  sha256 "1d2b99f53c24056814cb4912ceba89ea54d095a32dabb1096771650c59f6df5c"
  ```
- To get checksum, download the tar, `shasum -a 256 yabai-v7.1.5.tar.gz`
