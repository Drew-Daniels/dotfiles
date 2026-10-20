---
name: commit
description: Commit your changes. Files with mixed changes are ok to commit. Do NOT stash, pop, or touch unrelated files.
---

Commit your changes. Files with mixed changes are ok to commit. Do NOT stash, pop, or touch unrelated files.

## Context

Gather context by running these commands:

1. `git status` - see what's changed
2. `git diff HEAD` - see the actual changes (staged and unstaged)
3. `git branch --show-current` - current branch
4. `git log --oneline -10` - recent commits for style reference

## Rules

- Stage only the files you modified or deleted in this session. Use `git add <file> ...` with explicit paths. NEVER use `git add -A` or `git add .` - these sweep in untracked files from other work sessions.
- Files with mixed changes (your changes plus unrelated changes) are ok to commit together - do NOT try to split them
- Do NOT stash, pop, or touch unrelated files
- Do NOT use any other tools or do anything else besides staging and committing
