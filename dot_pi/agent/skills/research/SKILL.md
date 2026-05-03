---
name: research
description: Conduct extensive research on a topic using parallel web search, then compile findings into structured documents
argument-hint: "<topic description> [--dir <output-dir>]"
disable-model-invocation: false
---

# Research

Conduct extensive, multi-source research on a topic and compile findings into well-structured documents.

**Topic:** {{arguments}}

## Process

### Phase 1: Understand the Request

1. Parse the arguments:
   - The topic/question to research
   - If `--dir <path>` is provided, use that as the output directory. Otherwise ask the user where to save the output (suggest `~/docs/<project-name>/`)
2. Check if the output directory already exists. If it does, read existing documents to understand what's already been researched — avoid duplicating work
3. If the topic is broad (e.g., "password manager app"), ask the user to confirm the scope and which specific areas to cover. If the topic is specific (e.g., "CRDT conflict resolution strategies"), proceed directly

### Phase 2: Plan the Research

Before searching, outline 4-8 research threads that can be pursued in parallel. Present this plan to the user for approval. Example threads for an app research project:
- Competitor landscape and market analysis
- Technical architecture and implementation approaches
- User pain points and community sentiment
- Legal/regulatory considerations
- Pricing and business model research
- Security and privacy considerations

Each thread should be specific enough to yield focused results but broad enough to be comprehensive.

### Phase 3: Execute Parallel Research

Launch multiple Agent subagents in parallel (one per research thread). Each agent should:
- Use web search tools (WebSearch, firecrawl_search, firecrawl_scrape) extensively
- Search across multiple source types: official docs, blog posts, Reddit/HN discussions, academic papers, GitHub repos, news articles
- Collect **specific facts with sources** — not vague summaries
- Look for contrarian viewpoints and edge cases, not just the mainstream consensus
- Note quantitative data: market sizes, growth rates, pricing, user counts, performance benchmarks
- Identify primary sources over secondary ones

### Phase 4: Compile into Documents

Create well-structured markdown documents in the output directory. Follow this format for each document:

```markdown
---
title: Document Title
description: One-line summary of what this document covers
---

# Document Title

> Research conducted {current month and year}. {Brief description of scope and methodology.}

---

## Table of Contents

1. [Section 1](#section-1)
2. [Section 2](#section-2)
...

---

## Section 1

{Content with tables, bullet points, and specific data points.}
```

**Document conventions:**
- YAML frontmatter with `title` and `description`
- Blockquote after the heading noting when research was conducted
- Full table of contents with anchor links
- Use tables for comparisons, feature matrices, and structured data
- Use blockquotes for key insights or notable quotes
- Cite sources inline where possible
- Bold key findings and numbers for scannability
- End each document with a summary or "Key Takeaways" section

### Phase 5: Create Index

Create an `index.md` in the output directory that links to all research documents with a brief description of each:

```markdown
---
title: Reference
description: Strategy documents, market research, and decision records
---

# Reference

{Brief context about what was researched and why.}

| Document | What you'll find |
|---|---|
| [Document Title](./document-slug) | Brief description |
```

### Phase 6: Review and Refine

After creating all documents:
1. Read through each document checking for:
   - Contradictions between documents
   - Claims without evidence
   - Gaps in coverage
   - Outdated information
2. Present a summary to the user:
   - How many documents were created
   - Key findings across all documents (top 5-10 insights)
   - Areas where research was thin or conflicting
   - Suggested follow-up research topics
3. Ask if any areas need deeper investigation

## Research Quality Standards

- **Prefer primary sources**: Official docs, SEC filings, published research over blog summaries
- **Date-stamp findings**: Note when data was current (e.g., "as of March 2026")
- **Quantify claims**: "$3.4B market in 2024" not "large market"
- **Acknowledge uncertainty**: If sources conflict, present both sides rather than picking one
- **Look for the graveyard**: Research failed products/approaches — knowing what didn't work is as valuable as knowing what does
- **Check Reddit and HN**: Real user sentiment often differs dramatically from marketing claims
- **Cross-reference numbers**: If one source says "1M users" and another says "5M users", investigate which is current and note the discrepancy

## Rules

- Launch research agents **in parallel** to maximize speed
- Each document should stand alone — a reader shouldn't need to read other docs to understand it
- Don't pad documents with obvious filler or generic advice. Every paragraph should contain specific, useful information
- If a research thread yields thin results, say so honestly rather than stretching limited findings
- Keep individual documents focused. Prefer 8 focused documents over 3 sprawling ones
- Do not fabricate data, statistics, or quotes. If you can't verify something, flag it as unverified
