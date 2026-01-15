#!/usr/bin/env fontforge
"""
Update base Departure glyphs while matching Em size for pixel-perfect rendering.

This script:
1. Imports new Departure glyphs
2. Scales them to match your custom font's Em size (1000)
3. Preserves all custom glyphs (Nerd Fonts, Phosphor, manual edits)
"""
import fontforge
import sys

if len(sys.argv) != 4:
    print("Usage: fontforge -script update_departure_with_em_size.py <custom_font.otf> <new_departure.otf> <output.otf>")
    print("")
    print("Example:")
    print("  fontforge -script update_departure_with_em_size.py \\")
    print("    DepartureMonoPhosphorFill-OLD.otf \\")
    print("    DepartureMono-Regular.otf \\")
    print("    DepartureMonoPhosphorFill-Updated.otf")
    sys.exit(1)

custom_font_path = sys.argv[1]
new_departure_path = sys.argv[2]
output_path = sys.argv[3]

print(f"Opening custom font: {custom_font_path}")
custom = fontforge.open(custom_font_path)

print(f"Opening new Departure: {new_departure_path}")
new_departure = fontforge.open(new_departure_path)

# Get Em sizes
custom_em = custom.em
new_em = new_departure.em
scale_factor = custom_em / new_em

print(f"\nEm Size Analysis:")
print(f"  Custom font Em size: {custom_em}")
print(f"  New Departure Em size: {new_em}")
print(f"  Scale factor needed: {scale_factor:.6f}x")

# First, scale the new Departure font to match Em size
print(f"\nScaling new Departure font from {new_em} to {custom_em} Em units...")
new_departure.em = custom_em
new_departure.ascent = custom.ascent
new_departure.descent = custom.descent

print("\nUpdating base Departure glyphs...")
updated_count = 0
added_count = 0

# Get all glyphs from new Departure
for glyph in new_departure.glyphs():
    if glyph.unicode < 0:  # Skip unmapped glyphs
        continue
    
    unicode_val = glyph.unicode
    
    # Check if this is a base Departure glyph (not icon)
    # Icons typically start at 0xE000 (Private Use Area)
    # Also check common icon ranges: 0xF0000-0xFFFFF
    is_icon = (unicode_val >= 0xE000 and unicode_val <= 0xF8FF) or \
              (unicode_val >= 0xF0000 and unicode_val <= 0x10FFFF)
    
    if is_icon:
        continue  # Skip icons, keep the old custom ones
    
    # Copy the glyph from new Departure
    new_departure.selection.select(unicode_val)
    new_departure.copy()
    
    if unicode_val in custom:
        custom.selection.select(unicode_val)
        custom.paste()
        updated_count += 1
    else:
        custom.selection.select(unicode_val)
        custom.paste()
        added_count += 1

print(f"\nUpdated {updated_count} existing glyphs")
print(f"Added {added_count} new glyphs from updated Departure")

# Update font metadata to make it unique
print("\nUpdating font metadata...")
# Remove any existing "Updated" suffix first
custom.familyname = custom.familyname.replace(" Updated", "") + " Updated"
custom.fontname = custom.fontname.replace("Updated", "") + "Updated"
custom.fullname = custom.fullname.replace(" Updated", "") + " Updated"

print(f"  Font will appear as: {custom.familyname}")

# Verify Em size is still correct
print(f"\nFinal Em size: {custom.em}")
print(f"Final Ascent: {custom.ascent}")
print(f"Final Descent: {custom.descent}")

print(f"\nSaving to: {output_path}")
custom.generate(output_path)

print("\n✓ Font updated successfully!")
print(f"\nNew Departure glyphs scaled to Em size {custom_em} for pixel-perfect rendering.")
print(f"Your custom glyphs (Nerd Fonts, Phosphor, manual edits) are preserved.")
