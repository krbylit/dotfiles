# Claude Assistant Guide for Dotfiles Repository

## Development Commands
- Code formatting: Uses Neovim with conform.nvim (stylua, fish_indent, shfmt, prettierd, yapf)
- Edit configuration: `chezmoi edit <file>`
- Apply changes: `chezmoi apply`
- Update repository: `chezmoi update`
- Search codebase: `rg <pattern>` or use Fish function `rg_fzf_search`

## Code Style Guidelines
- Fish shell: Use `fish_indent` for consistent formatting
- Lua: Format with `stylua`, follow Neovim Lua style conventions
- Shell scripts: Format with `shfmt`
- Python: Use `yapf` formatter, `pyright` and `ruff` for linting
- JavaScript/TypeScript: Follow ESLint rules, use TypeScript for type safety
- Configuration files: Use YAML or TOML with proper schema validation
- Naming: Use snake_case for Fish functions, follow language conventions elsewhere
- Documentation: Include README.md files in directories explaining purpose

## Repository Structure
- Managed using [chezmoi](https://www.chezmoi.io/) dotfile manager
- Configuration organized by tool with README files explaining usage
- Secrets kept in `secrets/` directory (excluded from version control)