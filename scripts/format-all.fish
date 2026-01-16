#!/usr/bin/env fish
# Format all files in chezmoi repo using appropriate formatters
# Falls back to Neovim conform for files without standalone formatters
# ./format-all.fish > format-log.txt 2>&1

# ============================================================================
# Configuration: File types and their formatters
# ============================================================================
# Format: extension|formatter_command|mode (batch or per-file)
set -l formatters \
    "lua|stylua|batch" \
    "fish|fish_indent -w|batch" \
    "sh|shfmt -w|batch" \
    "py|yapf -i|batch" \
    "json|prettier --write|per-file" \
    "yaml|prettier --write|per-file" \
    "yml|prettier --write|per-file" \
    "toml|taplo format|batch" \
    "md|prettier --write|per-file"
# "vim|nvim --headless -c \"silent! lua vim.bo.filetype='vim'; require('conform').format({timeout_ms=3000,lsp_fallback=true})\" -c write -c quitall!|per-file" \
# "rb|nvim --headless -c \"silent! lua vim.bo.filetype='ruby'; require('conform').format({timeout_ms=3000,lsp_fallback=true})\" -c write -c quitall!|per-file" \
# "conf|nvim --headless -c \"silent! lua vim.bo.filetype='conf'; require('conform').format({timeout_ms=3000,lsp_fallback=true})\" -c write -c quitall!|per-file" \
# "tmpl|nvim --headless -c \"silent! lua require('conform').format({timeout_ms=3000,lsp_fallback=true})\" -c write -c quitall!|per-file"
# Files to exclude from formatting
set -l exclude_patterns \
    "CHEZMOI_DETECT_*" \
    "*.swp" \
    "*.tmp" \
    ".git/*"

# ============================================================================
# Main
# ============================================================================
set repo_root (chezmoi source-path)
cd $repo_root

echo "Formatting all files in chezmoi repo..."
echo ""

# Track statistics
set -l total_files 0
set -l format_results

# Build fd exclude arguments
set -l fd_excludes
for pattern in $exclude_patterns
    set -a fd_excludes --exclude $pattern
end

# Process each formatter
for formatter_spec in $formatters
    set -l parts (string split "|" $formatter_spec)
    set -l ext $parts[1]
    set -l cmd $parts[2]
    set -l mode $parts[3]

    # Extract the base command (first word) to check if it exists
    set -l base_cmd (string split " " $cmd)[1]

    # Check if formatter command exists
    if not command -v $base_cmd >/dev/null 2>&1
        set -l file_count (fd -e $ext $fd_excludes 2>/dev/null | wc -l | string trim)
        if test $file_count -gt 0
            echo "Skipping $file_count .$ext files (formatter '$base_cmd' not found)"
        end
        continue
    end

    # Count files
    set -l file_count (fd -e $ext $fd_excludes | wc -l | string trim)

    if test $file_count -gt 0
        echo "Formatting $file_count .$ext files..."

        # Execute formatter based on mode
        if test "$mode" = batch
            # Batch mode: pass all files to single formatter invocation
            set -l cmd_parts (string split " " $cmd)
            fd -e $ext $fd_excludes -X $cmd_parts
        else
            # Per-file mode: limit parallelism to prevent system overload
            set -l cmd_parts (string split " " $cmd)
            fd -e $ext $fd_excludes --threads=4 -x $cmd_parts
        end

        set total_files (math $total_files + $file_count)
        set -a format_results "  $file_count .$ext files"
        echo "  Done"
    end
end

# Summary
echo ""
echo "All files formatted successfully!"
echo ""
echo "Files formatted:"
for result in $format_results
    echo $result
end
echo ""
echo "Total: $total_files files"
