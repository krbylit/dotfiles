# Link Validation Summary - Task T055

**Date**: 2025-12-12
**Task**: Validate all internal links across documentation files

## Executive Summary

Validated **669 internal links** across **83 markdown files** in the dotfiles repository.

- **Valid links**: 617 (92.2%)
- **Broken links**: 52 (7.8%)
- **Fixed links**: 25 (automatic fixes applied)

## Validation Results

### Files Scanned
- Root documentation: `README.md`, `INSTALL.md`, `TROUBLESHOOTING.md`, `CHEZMOI.md`, `CLAUDE.md`
- Architecture docs: `docs/ARCHITECTURE.md`, `docs/DESIGN.md`, `docs/KEYMAPS.md`, `docs/CHEZMOI.md`
- Workflow guides: 6 files in `docs/workflows/`
- Tool configs: 15 README files in `dot_config/*/`
- Claude commands: 16 files in `dot_claude/commands/`
- Spec files: 14 files in `specs/001-comprehensive-docs/`

### Automatic Fixes Applied (25 links)

#### README.md (2 fixes)
- `./dot_config/exact_yabai/README.md` → `./dot_config/yabai/README.md`
- `./dot_config/exact_skhd/README.md` → `./dot_config/skhd/README.md`

#### TROUBLESHOOTING.md (21 fixes)
- Converted 21 absolute paths (`/Users/kirbylittle/.local/share/chezmoi/...`) to relative paths (`./...`)
- Fixed directory links to point to README.md files
- Updated `/Users/.../CHEZMOI.md` references to `./docs/CHEZMOI.md`

#### Other files (2 fixes)
- `docs/workflows/daily-development.md`: Fixed Neovim README path
- `dot_claude/commands/chore.doc-gen.md`: Fixed relative path to CLAUDE.md

## Remaining Broken Links Analysis

### Category 1: Template/Example Files (16 links)

**Status**: Intentional - do not fix

These are placeholder links in template and example files:

1. **dot_claude/commands/docs.create-adr.md** (13 links)
   - ADR template examples: `NNNN-title.md`, `0001-use-rust-for-query-service.md`, etc.
   - Generic placeholder: `URL`
   - These are example links meant to be replaced when creating actual ADRs

2. **dot_claude/commands/git.create-pr-desc.md** (1 link)
   - Template placeholder: `URL` for Notion card reference

3. **specs/001-comprehensive-docs/contracts/workflow-template.md** (2 links)
   - Template placeholders: `../path/to/doc.md`, `../../dot_config/tool/README.md`

**Recommendation**: Mark these files as templates in validation script excludes

### Category 2: TOC Anchor Mismatches (31 links)

**Status**: Files need TOC regeneration

Many README files have table of contents with incorrectly formatted anchors. The headings exist but TOC links don't match GitHub's anchor generation algorithm.

#### Affected files:
- `docs/ARCHITECTURE.md` (4 links)
  - Issue: TOC uses `#karabiner--skhd--yabai` but GitHub converts `↔` to nothing
  - Actual anchor: `#karabiner-skhd-yabai`

- `docs/KEYMAPS.md` (13 links)
  - Issue: TOC uses `#movement--navigation` but GitHub removes `&`
  - Actual anchors: `#movement-navigation`, `#windows-tabs`, `#file-operations-buffers`, etc.

- `dot_config/fish/README.md` (1 link)
- `dot_config/fish/TOOLS.md` (8 links)
- `dot_config/exact_nvim/README.md` (4 links)
- `dot_config/skhd/README.md` (1 link)
- `dot_config/yazi/README.md` (5 links)

**Root cause**: TOCs were likely auto-generated with incorrect anchor formatting rules

**Recommendation**: Regenerate TOCs using a tool that follows GitHub's anchor algorithm:
- Convert to lowercase
- Remove all special characters except alphanumeric, spaces, hyphens, underscores
- Replace spaces with hyphens
- Common removals: `&`, `↔`, `(`, `)`, `` ` ``

### Category 3: Genuinely Broken Links (5 links)

**Status**: Require manual investigation/fixes

1. **TROUBLESHOOTING.md line 769**
   - Link: `./dot_config/exact_nvim/lua/plugins/copilot.lua`
   - Issue: File does not exist
   - Investigation needed: Was copilot.lua removed? Should link be removed or updated?

2. **TROUBLESHOOTING.md lines 935, 1012, 1722** (3 links)
   - Links to `./docs/CHEZMOI.md` with anchors:
     - `#4-template-system`
     - `#5-cm-util-symlink-strategy`
     - `#secrets-and-encryption`
   - Issue: Anchors don't exist in `docs/CHEZMOI.md`
   - Investigation needed: Were these sections renamed/removed? Need to find correct anchors

3. **docs/CHEZMOI.md line 945**
   - Link: `../specs/001-comprehensive-docs/tasks.md#phase-9-polish--cross-cutting-concerns`
   - Issue: Anchor doesn't exist in tasks.md
   - Investigation needed: Was this phase renamed? Need correct anchor

4. **dot_claude/commands/chore.doc-gen.md line 344**
   - Link: `#invalidate_cache`
   - Issue: Anchor doesn't exist in same file
   - Investigation needed: Was this function/section removed?

## Validation Methodology

### Tools Created
1. **validate_links.py** - Python script to:
   - Find all markdown files (excluding vendor directories)
   - Extract internal links (relative/absolute paths, anchors)
   - Validate file existence and heading anchors
   - Generate detailed reports

2. **fix_links.py** - Python script to automatically fix common issues

### Anchor Generation Algorithm
Implemented GitHub's anchor generation rules:
1. Convert heading text to lowercase
2. Remove markdown formatting (backticks, links, emphasis)
3. Remove special characters except alphanumeric, spaces, hyphens, underscores
4. Replace spaces/underscores with hyphens
5. Handle duplicate headings by appending `-1`, `-2`, etc.

### Exclusions
Excluded vendor/plugin directories:
- `cm-util/ctrld-configs/yazi/plugins/`
- `cm-util/ctrld-configs/yazi/flavors/`
- `dot_config/yazi/plugins/`
- `dot_config/yazi/flavors/`
- `dot_hammerspoon/Spoons/`
- `secrets/.cursor/`

## Recommendations

### Immediate Actions
1. **Regenerate TOCs** in affected files using correct anchor algorithm
2. **Investigate 5 genuinely broken links** to determine correct targets
3. **Document template files** to exclude from future link validation

### Future Improvements
1. **Automate link validation** in pre-commit hooks or CI/CD
2. **Use consistent TOC generator** across all documentation
3. **Add link validation** to documentation contribution guidelines
4. **Consider markdown linter** with link checking (markdownlint with link plugins)

### Tool Integration
The validation scripts can be integrated into the development workflow:
```bash
# Run validation
python validate_links.py

# Apply automatic fixes
python fix_links.py

# Commit fixes
git add .
git commit -m "docs: fix broken internal links"
```

## Files Modified

### Documentation
- `README.md` - Fixed 2 directory path references
- `TROUBLESHOOTING.md` - Fixed 23 absolute paths and directory references

### Workflow Documentation
- `docs/workflows/daily-development.md` - Fixed Neovim README path

### Command Documentation
- `dot_claude/commands/chore.doc-gen.md` - Fixed relative path

## Statistics

| Metric | Count |
|--------|-------|
| Total markdown files | 83 |
| Total internal links | 669 |
| Valid links | 617 (92.2%) |
| Broken links (template placeholders) | 16 (2.4%) |
| Broken links (TOC mismatches) | 31 (4.6%) |
| Broken links (genuine issues) | 5 (0.7%) |
| Automatic fixes applied | 25 (3.7%) |

## Conclusion

The link validation successfully identified and fixed **25 broken internal links** (3.7% of total links). The remaining 52 broken links consist of:

- **16 intentional template placeholders** (no action needed)
- **31 TOC anchor mismatches** (requires TOC regeneration)
- **5 genuinely broken links** (requires investigation)

The documentation now has a **92.2% valid link rate**, with most remaining issues being TOC formatting rather than missing files. The actual critical broken links (5 genuine issues) represent only **0.7%** of all internal links.

### Next Steps
1. Investigate and fix the 5 genuinely broken links
2. Regenerate TOCs in 7 affected files
3. Consider excluding template files from future validations
4. Integrate link validation into CI/CD pipeline
