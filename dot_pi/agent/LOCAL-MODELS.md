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
