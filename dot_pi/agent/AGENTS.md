# Global Instructions

## Writing Style

- Never use em dashes (-) or en dashes. Use regular hyphens (-) instead.

## CLI Power Tools

Prefer these over `grep`/`find` for searching and refactoring:

### Codebase Search

- **rg (ripgrep)** - fast recursive search, respects `.gitignore`. Default for all text search.
- **fd** - fast file finder, respects `.gitignore`. Default for all file-path searches.
- **difft (difftastic)** - structural diffs that understand Go/SQL/HTML ASTs. Use for reviewing refactoring changes where `git diff` is noisy.

```bash
# rg: search Go files for a function name, excluding generated code
rg 'SyncMeeting' --type go --glob '!**/gen/**'

# rg: search with context lines
rg -C3 'campaign_finance' internal/db/queries/

# fd: find all migration files
fd '.sql' internal/db/migrations/

# difft: structural diff of current changes
git difftool --tool=difftastic
```

### JSON

- **jq** - query, filter, and transform JSON. The default tool for any JSON work.
- **jless** - interactive terminal viewer. Use to explore structure without dumping thousands of lines into context.
- **dasel** - surgical in-place edits by path. Use for targeted field updates without rewriting the whole file.

```bash
# jq: filter and extract
jq '.[] | select(.type == "something")' data.json

# jq: count entries grouped by a field
jq 'group_by(.type) | map({type: .[0].type, count: length})' data.json

# jless: browse a large file interactively (vim-like navigation)
jless data.json

# jless: pipe filtered output for exploration
jq '[.[] | select(.active)]' data.json | jless

# dasel: read a specific path
dasel -f data.json '.[0].id'

# dasel: update a specific field in-place
dasel put -f data.json -t string -v "new_value" '.[0].name'
```

### CSV

**qsv** - fast CSV toolkit for inspecting and filtering data files.

```bash
# Preview structure and types
qsv headers data.csv
qsv stats data.csv | qsv table

# Filter rows by column value
qsv search -s column_name 'pattern' data.csv

# Select specific columns
qsv select name,amount,date data.csv

# Sort by a column descending
qsv sort -s amount -R data.csv | qsv table

# Join two CSV files on a shared key
qsv join key1 file1.csv key2 file2.csv
```

### Structural Refactoring

For sweeping code changes, use the right tool for the pattern:

- **comby** - text-structural matching (balanced braces, multi-line args). Best for qualified function calls (`pkg.Func(...)`) which are the majority of Go call sites.
- **ast-grep (sg)** - AST-aware matching. Best for struct literals and function definitions. Does NOT work for qualified function calls in Go.
- **gofmt -r** - built-in, zero-install. Best for simple single-expression rewrites.
- **gopls rename** - type-safe renames that follow the dependency graph across packages.

```bash
# comby: preview matches before applying
comby 'queries.OldName(:[args])' 'queries.NewName(:[args])' .go -match-only -count

# comby: rename a sqlc query + its params struct
comby 'queries.OldName(:[args])' 'queries.NewName(:[args])' .go
comby 'gen.OldNameParams{:[fields]}' 'gen.NewNameParams{:[fields]}' .go

# gofmt -r: simple expression swap
gofmt -r 'a.OldField -> a.NewField' -w internal/

# gopls rename: type-safe cross-package rename
gopls rename -w internal/server/router.go:42:15 NewMethodName
```
