#!/usr/bin/env fish
# Script to regenerate auto-generated fish completions
# Run this after updating tools that provide completions

set -l completions_dir (dirname (status --current-filename))/completions
set -l regenerated 0
set -l failed 0

echo "Regenerating fish completions..."
echo "Completions directory: $completions_dir"
echo ""

# Delta
if command -q delta
    echo "Regenerating delta completions..."
    if delta --generate-completion fish > $completions_dir/delta.fish
        echo "✓ Delta completions regenerated"
        set regenerated (math $regenerated + 1)
    else
        echo "✗ Failed to regenerate delta completions"
        set failed (math $failed + 1)
    end
else
    echo "⊘ Delta not installed, skipping"
end

# Restic
if command -q restic
    echo "Regenerating restic completions..."
    if restic generate --fish-completion $completions_dir/restic.fish
        echo "✓ Restic completions regenerated"
        set regenerated (math $regenerated + 1)
    else
        echo "✗ Failed to regenerate restic completions"
        set failed (math $failed + 1)
    end
else
    echo "⊘ Restic not installed, skipping"
end

# Alacritty
if command -q alacritty
    echo "⊘ Alacritty completions need manual generation (check alacritty docs)"
else
    echo "⊘ Alacritty not installed, skipping"
end

# Terraform
if command -q terraform
    echo "⊘ Terraform completions require: terraform -install-autocomplete"
else
    echo "⊘ Terraform not installed, skipping"
end

# Spotify Player
if command -q spotify_player
    echo "⊘ Spotify Player completions need manual generation (check spotify_player docs)"
else
    echo "⊘ Spotify Player not installed, skipping"
end

echo ""
echo "Summary:"
echo "  Regenerated: $regenerated"
echo "  Failed: $failed"
echo ""
echo "Note: Some completions require manual steps or tool-specific commands."
echo "See completions/README.md for details."
