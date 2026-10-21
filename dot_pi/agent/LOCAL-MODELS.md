# Local Models Guide

Models running locally via Ollama on M5 Max 128GB.

## Coding

| Model | SWE-bench | Size | Speed | When to use |
|---|---|---|---|---|
| **qwen3.6:27b** | 77.2% | 18 GB | Fast (dense 27B) | **Daily driver.** Best benchmark score at this size. Dense architecture = fast token generation. |
| qwen3-coder-next | 70.6% | 51 GB | Slow (MoE 80B) | Hard multi-file refactors where you need maximum reasoning depth. Context capped at 64K for speed. |
| devstral-small-2 | 68.0% | 15 GB | Fast (dense 24B) | Vision (can read screenshots), 384K context, agentic multi-file edits. Lightest coding model. Western provenance (Mistral, France). |
| qwen3-coder | 60.4% | 18 GB | Fast (MoE 30B, 3B active) | Fallback if qwen3.6 has issues with a specific task. |

**Pick qwen3.6:27b unless:**
- You need vision input (screenshots, diagrams) - use devstral-small-2
- The task is exceptionally complex and you can tolerate slower output - use qwen3-coder-next
- You care about Western model provenance - use devstral-small-2

## Summarization & ETL

| Model | Size | When to use |
|---|---|---|
| **gemma4:12b** | 7.7 GB | Legal text summarization, PDF vision fallback, structured JSON extraction. Default for `etl/llm/ollama.py`. Thinking disabled for batch speed (~1s/section). |
| qwen3.5:4b | 4.0 GB | High-volume classification. Fast alternative to GLiClass for text categorization tasks. |

## General Reasoning

| Model | Size | When to use |
|---|---|---|
| **qwen3.5:27b** | 19 GB | Deep analysis, research questions, long document understanding. Multimodal (images). Good at structured reasoning. |

## Embeddings

| Model | Size | When to use |
|---|---|---|
| **nomic-embed-text** | 274 MB | Semantic similarity, template legislation detection, fuzzy entity matching. 768-dim, 8192 context. 152 embeds/sec. Always loaded, negligible memory. |

## Cloud Models (via `ollama signin`)

For tasks too large for local inference. Require Ollama paid plan or credits.

| Model | When to use |
|---|---|
| kimi-k2.7-code:cloud | Top cloud coding model. Use for the hardest problems when local quality isn't enough. |
| gemma4:31b-cloud | Full-size Gemma for long document summarization. |
| kimi-k3:cloud | #1 on frontend coding arena. Weights not released yet. |

## Quick Reference

```
Ctrl+P          Cycle through models in pi
/model          Search and select a model
ollama ps       See what's currently loaded
ollama list     See all downloaded models
```

## Memory Budget

128 GB total, ~105 GB usable for models (rest for OS + apps).

| Combo | Total | Headroom |
|---|---|---|
| qwen3.6:27b + gemma4:12b + nomic-embed | ~26 GB | 79 GB free |
| qwen3-coder-next + nomic-embed | ~51 GB | 54 GB free |
| qwen3.6 + devstral-small-2 + gemma4 + nomic-embed | ~41 GB | 64 GB free |

Ollama auto-unloads idle models after 5 minutes by default. Two coding models can coexist for A/B testing.

## Context Management

### billion-context (installed)

A context compression proxy (1.8M downloads/mo) that runs as a native pi plugin. Instead of pi's built-in compaction ("summarize everything before the cut point"), billion-context injects tools the model calls to compress/decompress conversation ranges with layered summaries.

**How it works:**
- Injects `compress`, `decompress`, `search_context`, `acp_status` tools
- The model decides when to compress old context (nudged at ~40K token growth intervals)
- Compressed ranges can be decompressed on demand if you need exact details
- Keeps prefix cache intact (compressed summaries are stable prefixes)
- Supports month-long single sessions (the author ran an 18.76B token study over 4.5 months)

**Status commands:**
```
/acp              Show compression status, blocks, and usage
/acp-cache        Cache hit rate report with attribution
```

**Config:** `~/.config/billion-context/billion-context.json`

Current settings:
- `nudgeGrowthTokens: 40000` - first compression ~40K tokens into session
- `subagents: false` - built-in subagent tools disabled

**Remove if needed:** `bili plugin remove pi` or delete `"npm:billion-context"` from packages in settings.json.

### Compaction settings (pi native, as fallback)

Pi's built-in compaction still acts as a safety net behind billion-context.

| Setting | Value | What it does |
|---|---|---|
| `reserveTokens` | 8192 | Compaction fires when context exceeds `contextWindow - 8192` |
| `keepRecentTokens` | 12000 | Recent tokens kept verbatim after compaction (rest summarized) |

All local models are set to 128K context windows except qwen3-coder-next (64K, for speed at 51GB).

### Tips for long sessions

- **Start focused.** A narrow initial prompt means less context consumed by the goal/constraints summary.
- **Use `/compact [instructions]`** manually when switching tasks mid-session to clean up irrelevant context.
- **Watch the footer.** The percentage (e.g. `48.2%/128k`) shows context usage. If it climbs fast, the model is reading large files - consider trimming what you ask it to read.
- **`Ctrl+P` to Claude** for tasks that genuinely need 200K+ context (huge codebase exploration). Local models cap at 128K.

## Installed Extensions

| Package | Purpose | Commands |
|---|---|---|
| `@ollama/pi-web-search` | Web search and fetch via Ollama cloud | - |
| `billion-context` | Context compression - layered model-driven compression, decompression on demand | `/acp`, `/acp-cache` |
| `pi-lens` | Real-time code feedback - LSP diagnostics, ruff linting, type checking, ast-grep structural rules, read-guard, impact cascade | `/lens-health`, `/lens-map` |
| `pi-memory` | Persistent memory across sessions - semantic search over daily logs and long-term memory | `/memory` |

| `pi-background-tasks` | Durable background shell tasks - run long commands without blocking conversation | - |
| `pi-btw` | Parallel side conversations - ask questions without interrupting the main run | `/btw`, `/btw:ask`, `/btw:inject` |
| `@ff-labs/pi-fff` | SIMD-accelerated fuzzy file/content search - replaces fd/rg with pre-indexed, frecency-ranked search | `/fff-health`, `fffind`, `ffgrep` |

### Why these extensions matter for local models

**pi-lens** is the most impactful. Local models make more subtle mistakes than Claude (wrong imports, type mismatches, off-by-one errors). pi-lens catches these on every edit via LSP + ruff + pyright, before they compound across multiple files. The read-guard prevents edits to files the model hasn't read - a common local model failure mode.

**pi-memory** compensates for shorter sessions. With 128K context on local models (vs 200K on Claude), you'll compact and start new sessions more often. Memory preserves project knowledge ("PA admin code uses section_id as PK", "the ETL default model is gemma4:12b") across those boundaries.

**pi-background-tasks** lets you run `just run`, `just test`, or pipeline tasks without blocking the conversation - important when local model responses are slower than Claude.

**pi-btw** adds `/btw` side conversations that run in parallel. While the main agent works on a multi-file refactor, ask a side question ("what does this function do?") without derailing the current task. The side thread uses its own sub-session and stays out of main context.

**pi-fff** replaces pi's built-in `find`/`grep` (which spawn `fd`/`rg` subprocesses per call) with a Rust-native SIMD-accelerated search engine. Files are pre-indexed at session start, ranked by frecency (files you access often rank higher), and fuzzy-matched. In a 9,000-file codebase, the model finds the right file faster and wastes less context on search misses.
