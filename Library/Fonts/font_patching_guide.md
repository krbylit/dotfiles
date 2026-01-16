# Departure Mono Custom Font Patching Guide

## Overview

This guide documents the process of creating and maintaining the custom `Departure Mono Phosphor Fill` font used in this dotfiles repository. The custom font combines:

- **Base font**: Departure Mono (bitmap-inspired monospace font)
- **Icon sets**: Nerd Fonts + Phosphor icons
- **Custom modifications**: Manual glyph additions/corrections + Em size adjustment

## Background: Original Font Creation

### What Was Done Originally (December 2024)

1. **Started with**: Stock Departure Mono Regular (Em size: 550)
2. **Patched with Nerd Fonts**: Used the [Nerd Fonts patcher](https://github.com/ryanoasis/nerd-fonts) to add programming icons
3. **Patched with Phosphor icons**: Added Phosphor icon set for additional glyphs
4. **Manual edits in FontForge GUI**:
   - Fixed missing/incorrect glyphs manually
   - **Changed Em size from 550 → 1000** to match icon sizes (critical for consistency)
5. **Result**: `DepartureMonoPhosphorFill.otf`

### Why Em Size Was Changed

Icons (Nerd Fonts, Phosphor) typically use Em size 1000, but Departure Mono uses Em size 550. This size mismatch caused icons to appear much larger than text characters in the terminal. By changing the font's Em size to 1000, all glyphs render at consistent sizes.

**Note**: Changing Em size preserves pixel-perfect rendering because it adjusts the coordinate system, not the glyph shapes themselves.

## The Update Problem

Departure Mono released version 1.500 with additional characters. The goal was to incorporate these new characters into the custom font while preserving:

- All Nerd Fonts icons
- All Phosphor icons
- All manual glyph corrections
- The Em size 1000 adjustment

## Solution: Patching New Departure Onto Custom Font

Instead of rebuilding from scratch, we merge the updated Departure glyphs into the existing custom font.

### Key Challenges Encountered

1. **Font name conflicts**: macOS Font Book detects duplicates by internal metadata, not filename
2. **Size mismatch**: New Departure (Em 550) glyphs appeared tiny next to existing glyphs (Em 1000)
3. **Window title rendering**: macOS native controls render fonts differently than terminal grid

## The Complete Update Process

### Prerequisites

```bash
# Install FontForge (command-line tool)
brew install fontforge

# Download latest Departure Mono
# https://github.com/rektdeckard/departure-mono/releases
```

### Step 1: Check Font Metrics

First, verify the Em size difference between your custom font and new Departure:

```bash
fontforge -script check_em_size.py \
  DepartureMonoPhosphorFill.otf \
  DepartureMono-Regular.otf
```

**Script: `check_em_size.py`**

```python
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
```

**Expected output:**

- Custom font: Em size 1000
- New Departure: Em size 550
- Scale factor: ~1.818x

### Step 2: Update Departure Glyphs with Correct Em Size

This script imports new Departure glyphs and scales them to Em size 1000:

```bash
fontforge -script update_departure_with_em_size.py \
  DepartureMonoPhosphorFill.otf \
  DepartureMono-Regular.otf \
  DepartureMonoPhosphorFill-Updated.otf
```

**Script: `update_departure_with_em_size.py`**

```python
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
```

### Step 3: Fix OS/2 Metrics for Window Titles (If Needed)

If the font renders too small in Ghostty window titles, fix the OS/2 table metrics:

```bash
fontforge -script fix_os2_metrics.py \
  DepartureMonoPhosphorFill-Updated.otf \
  DepartureMonoPhosphorFill-Updated-Fixed.otf
```

**Script: `fix_os2_metrics.py`**

```python
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
```

### Step 4: Install and Test

1. **Install the font**: Open `DepartureMonoPhosphorFill-Updated.otf` in Font Book
2. **Test in Ghostty**: Update `ghostty.conf.tmpl`:
   ```
   font-family = "Departure Mono Phosphor Fill Updated"
   ```
3. **Verify**:
   - Base characters render at correct size
   - Icons (Nerd Fonts, Phosphor) still work
   - No size mismatches
   - Window titles render correctly

### Step 5: Finalize (Optional)

Once confirmed working, you can:

1. Remove the old font from Font Book
2. Rename the updated font to remove " Updated" suffix:
   - Modify the script to not append "Updated"
   - Or manually rename in FontForge GUI

## Pixel-Perfect Rendering Notes

### Departure Mono Recommendations

From the [Departure Mono documentation](https://github.com/rektdeckard/departure-mono):

> For pixel-perfect results, set the font size to increments of 11px.

### Ghostty Font Size Configuration

Ghostty's `font-size` setting uses **points (pt)**, not pixels. The conversion depends on display DPI:

**For Retina/HiDPI displays (most modern Macs):**

- DPI: 144 (2x scaling)
- Formula: `pixels = points × 2`
- For 11px increments: use point sizes **5.5, 11, 16.5, 22, 27.5, 33**

**Example configuration:**

```conf
# 16.5pt = 33px on Retina display (multiple of 11px for pixel-perfect rendering)
font-size = 16.5
```

### Why Em Size Matters

- Changing **Em size** (coordinate system) = pixel-perfect ✓
- Scaling **glyphs** (distorting shapes) = NOT pixel-perfect ✗

By changing Em size from 550 → 1000, we maintain pixel-perfectness while ensuring all glyphs render at consistent sizes.

## Troubleshooting

### Font appears as duplicate in Font Book

**Cause**: Font Book checks internal metadata (family name, PostScript name), not filename.

**Solution**: The update script appends " Updated" to the font's internal names. After testing, you can replace the old font entirely.

### Icons are much larger than text

**Cause**: Em size mismatch between base glyphs and icons.

**Solution**: Use the `update_departure_with_em_size.py` script which adjusts Em size, not the simple scaling script.

### Window titles render too small

**Cause**: macOS native controls use OS/2 table metrics differently than terminal rendering.

**Solutions**:

1. Use `fix_os2_metrics.py` to correct the OS/2 table
2. Or use the old font for window titles only:
   ```conf
   font-family = "Departure Mono Phosphor Fill Updated"
   window-title-font-family = "Departure Mono Phosphor Fill"
   ```

## Tools Used

- **FontForge** (CLI): Font editing and scripting - `brew install fontforge`
- **Nerd Fonts patcher**: Icon patching - https://github.com/ryanoasis/nerd-fonts
- **Phosphor icons**: Additional icon set - https://phosphoricons.com/

## Git History

Original font creation commit:

```
212ee84 - cm: add departure mono font and nerd font patch (Dec 1, 2024)
```

## Future Updates

When Departure Mono releases new versions:

1. Download the new `DepartureMono-Regular.otf`
2. Run `update_departure_with_em_size.py` to merge new glyphs
3. Test thoroughly in terminal and window titles
4. Replace the old font file in the repository

## Additional Resources

- [Departure Mono GitHub](https://github.com/rektdeckard/departure-mono)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [FontForge Documentation](https://fontforge.org/docs/)
- [Ghostty Configuration](https://ghostty.org/docs/config)

## Summary

This custom font combines the best of multiple sources:

- **Departure Mono**: Pixel-perfect bitmap-inspired monospace font
- **Nerd Fonts**: Programming icons and symbols
- **Phosphor**: Additional icon coverage
- **Manual corrections**: Custom glyph fixes
- **Em size adjustment**: Consistent rendering across all glyphs

By maintaining this font through scripting rather than manual GUI work, future updates are reproducible and documented.
