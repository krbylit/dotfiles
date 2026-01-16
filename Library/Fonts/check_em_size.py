#!/usr/bin/env fontforge
"""
Check Em size and font metrics to understand what was changed.
"""
import fontforge
import sys

if len(sys.argv) < 2:
    print("Usage: fontforge -script check_em_size.py <font1.otf> [font2.otf]")
    sys.exit(1)

for font_path in sys.argv[1:]:
    print(f"\n{'='*60}")
    print(f"Font: {font_path}")
    print(f"{'='*60}")

    font = fontforge.open(font_path)

    print(f"Em Size: {font.em}")
    print(f"Ascent: {font.ascent}")
    print(f"Descent: {font.descent}")
    print(f"Family Name: {font.familyname}")
    print(f"Font Name: {font.fontname}")
    print(f"Full Name: {font.fullname}")

    # Check a sample glyph size
    if ord('A') in font:
        glyph = font[ord('A')]
        bb = glyph.boundingBox()
        print(f"\nSample 'A' glyph:")
        print(f"  Bounding box: {bb}")
        print(f"  Height: {bb[3] - bb[1]}")
        print(f"  Width: {glyph.width}")

    font.close()

print(f"\n{'='*60}")
