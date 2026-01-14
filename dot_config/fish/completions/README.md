# Fish Shell Completions

This directory contains shell completion files for various tools.

## Completion Types

### Auto-Generated Completions
These completions are generated automatically by the tools themselves and should not be manually edited. When tools are updated, regenerate these files using the script below.

| File | Tool | Command to Regenerate |
|------|------|----------------------|
| `delta.fish` | git-delta | `delta --generate-completion fish > completions/delta.fish` |
| `alacritty.fish` | Alacritty | Generated via `alacritty` (check their docs for latest method) |
| `restic.fish` | Restic | `restic generate --fish-completion completions/restic.fish` |
| `terraform.fish` | Terraform | `terraform -install-autocomplete` (installs to fish config) |
| `spotify_player.fish` | spotify_player | Check tool documentation for generation method |

### Plugin-Managed Completions
These are installed and managed by fisher:
- `fisher.fish` - Managed by fisher plugin
- `fishtape.fish` - Managed by fishtape plugin  
- `fzf_configure_bindings.fish` - Managed by fzf.fish plugin

### Custom/Manual Completions
These are manually created or customized:
- `nux.fish` - Custom completion for nux command
- `tmuxinator.fish` - Custom tmuxinator completions

## Regenerating Auto-Generated Completions

To regenerate all auto-generated completions:

```bash
# From the fish config directory
./regenerate-completions.fish
```

Or regenerate individual completions:

```bash
# Delta
delta --generate-completion fish > ~/.config/fish/completions/delta.fish

# Restic (if installed)
restic generate --fish-completion ~/.config/fish/completions/restic.fish
```

## Adding New Auto-Generated Completions

When adding a new tool with auto-generated completions:

1. Generate the completion file using the tool's command
2. Place it in this directory
3. Update this README with the generation command
4. Update `regenerate-completions.fish` script
5. Consider adding the file to `.gitignore` (optional)

## Notes

- Auto-generated files may have headers or comments indicating they are generated
- Always regenerate completions after updating the corresponding tool
- Plugin-managed completions should not be modified manually
- For tools without built-in completion generation, check if community completions exist
