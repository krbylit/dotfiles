#!/usr/bin/env fontforge
"""
Update base Departure glyphs in your custom patched font.
Also updates internal font names to avoid "duplicate font" errors.
"""
import fontforge
import sys

if len(sys.argv) != 4:
    print("Usage: fontforge -script update_departure_base_with_rename.py <custom_font.otf> <new_departure.otf> <output.otf>")
    print("")
    print("Example:")
    print("  fontforge -script update_departure_base_with_rename.py \\")
    print("    DepartureMonoPhosphorFill.otf \\")
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

print("\nUpdating base Departure glyphs...")
updated_count = 0
added_count = 0

# Get all glyphs from new Departure
for glyph in new_departure.glyphs():
    if glyph.unicode < 0:  # Skip unmapped glyphs
        continue
    
    unicode_val = glyph.unicode
    
    # Check if this glyph exists in custom font
    if unicode_val in custom:
        # Update existing glyph (this updates base Departure characters)
        new_departure.selection.select(unicode_val)
        new_departure.copy()
        custom.selection.select(unicode_val)
        custom.paste()
        updated_count += 1
    else:
        # Add new glyph (new characters added to Departure)
        new_departure.selection.select(unicode_val)
        new_departure.copy()
        custom.selection.select(unicode_val)
        custom.paste()
        added_count += 1

print(f"\nUpdated {updated_count} existing glyphs")
print(f"Added {added_count} new glyphs from updated Departure")

# Update font metadata to make it unique
print("\nUpdating font metadata to avoid duplicate font conflicts...")
print(f"  Original family name: {custom.familyname}")
print(f"  Original font name: {custom.fontname}")
print(f"  Original full name: {custom.fullname}")

# Append "Updated" to internal names
custom.familyname = custom.familyname + " Updated"
custom.fontname = custom.fontname + "Updated"
custom.fullname = custom.fullname + " Updated"

print(f"  New family name: {custom.familyname}")
print(f"  New font name: {custom.fontname}")
print(f"  New full name: {custom.fullname}")

print(f"\nSaving to: {output_path}")
custom.generate(output_path)

print("\n✓ Font updated successfully!")
print(f"\nYour custom glyphs (Nerd Fonts, Phosphor, manual edits) are preserved.")
print(f"Base Departure glyphs have been updated to the latest version.")
print(f"\nThe font will appear as '{custom.familyname}' in Font Book.")
print(f"After testing, you can replace the old font and remove the 'Updated' suffix.")
