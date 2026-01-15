#!/usr/bin/env fontforge
"""
Fix OS/2 table metrics to ensure proper rendering in macOS window titles.
"""
import fontforge
import sys

if len(sys.argv) != 3:
    print("Usage: fontforge -script fix_os2_metrics.py <input.otf> <output.otf>")
    sys.exit(1)

input_path = sys.argv[1]
output_path = sys.argv[2]

print(f"Opening: {input_path}")
font = fontforge.open(input_path)

print(f"\nCurrent metrics:")
print(f"  Em Size: {font.em}")
print(f"  Ascent: {font.ascent}")
print(f"  Descent: {font.descent}")

# Get OS/2 metrics
print(f"  OS/2 WinAscent: {font.os2_winascent}")
print(f"  OS/2 WinDescent: {font.os2_windescent}")
print(f"  OS/2 TypoAscent: {font.os2_typoascent}")
print(f"  OS/2 TypoDescent: {font.os2_typodescent}")

# Set OS/2 metrics to match internal metrics
print(f"\nSetting OS/2 metrics to match internal font metrics...")
font.os2_winascent = font.ascent
font.os2_windescent = font.descent
font.os2_typoascent = font.ascent
font.os2_typodescent = -font.descent

print(f"  New OS/2 WinAscent: {font.os2_winascent}")
print(f"  New OS/2 WinDescent: {font.os2_windescent}")
print(f"  New OS/2 TypoAscent: {font.os2_typoascent}")
print(f"  New OS/2 TypoDescent: {font.os2_typodescent}")

print(f"\nSaving to: {output_path}")
font.generate(output_path)

print("\n✓ OS/2 metrics fixed!")
