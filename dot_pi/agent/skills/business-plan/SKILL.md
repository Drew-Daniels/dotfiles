---
name: business-plan
description: Research and generate a full business plan document set for a new product
argument-hint: "<product name and brief description> [--dir <output-dir>]"
disable-model-invocation: false
---

# Business Plan

Generate a comprehensive set of research and strategy documents for a new product.

**Product description:** {{arguments}}

## Process

### Phase 1: Understand the Product

1. Parse the product name and description from the arguments
2. If `--dir <path>` is provided, use that as the output directory. Otherwise use `~/docs/<product-name>/`
3. Check if the directory already exists - if so, read existing docs and ask the user whether to update or start fresh
4. Ask the user to confirm:
   - The product's core purpose (one sentence)
   - Primary competitors to research (or let you identify them)
   - Any domain-specific considerations (e.g., regulatory, API dependencies, hardware requirements)
   - Business model preferences (subscription, one-time, freemium, open core, etc.)

### Phase 2: Research (Parallel)

Launch parallel research agents for each document area:

**Agent 1: Competitor Research**
- Identify 15-30 competitors across categories: major commercial, open source/self-hosted, privacy-first/niche, discontinued/failed
- For each: name, model (subscription/freemium/free/lifetime), pricing, free tier details, platform support, key differentiators
- User pain points from Reddit, HN, app store reviews, forums
- Gap analysis: where this product fits in the landscape
- Key differentiation arguments specific to this domain

**Agent 2: Competitor Financials**
- Deep dive on 4-6 top competitors: revenue, funding, user counts, growth rates, employee count, pricing history
- Unit economics where discoverable (CAC, LTV, churn)
- Market consolidation trends, acquisitions, pivots

**Agent 3: Market & Business Model**
- Total addressable market size with growth rates and sources
- Willingness-to-pay research for this specific domain
- Business model options evaluated against the product's constraints and goals
- Pricing strategy with comparable benchmarks from the competitive landscape
- Revenue projections (conservative/moderate/aggressive scenarios)
- Subscription economics if applicable (e.g., API costs that scale with users)

**Agent 4: Legal & Regulatory**
- Domain-specific regulations (financial: GLBA/PSD2, health: HIPAA/GDPR health data, etc.)
- Data privacy requirements by jurisdiction
- App store compliance requirements
- Export control considerations (if applicable)
- Terms of service requirements

**Agent 5: Licensing & Open Source**
- Licensing options and tradeoffs for this type of product (open source, proprietary, source-available, dual-license)
- Competitor licensing analysis (who is open source, who isn't, why)
- CLA strategy considerations if open source
- Dual-licensing viability

**Agent 6: Technical & Data Model**
- Data model research: what entities/schemas are needed, how competitors structure data
- Import/export formats common in this domain (e.g., OFX for finance, OPML for RSS)
- API integrations available (and their pricing/terms)
- Sync and collaboration considerations specific to this data model (if applicable)
- Platform-specific technical requirements

**Agent 7: Users & Go-to-Market**
- User personas (3-5 profiles with demographics, motivations, pain points)
- Positioning and messaging strategy
- Launch channels: which communities, subreddits, forums matter
- Community outreach plan
- Phased rollout strategy

### Phase 3: Generate Documents

Create the following documents in the output directory, each following the standard format (YAML frontmatter with `title` and `description`, date blockquote, TOC, tables for comparisons, cross-references to related docs):

| Document | Source Agents | Sections |
|---|---|---|
| `business-plan.md` | 3 | Market Size, Competitor Pricing Landscape, Willingness to Pay, Business Model Options, Recommended Model, Pricing Strategy, Revenue Projections, What to Avoid |
| `competitor-research.md` | 1 | Market Context, competitor categories (3-4 groups), Graveyard, User Pain Points, Gap Analysis, Differentiation Argument |
| `competitor-financials.md` | 2 | Company deep dives (4-6), Unit Economics, Market Trends |
| `legal-regulatory.md` | 4 | Domain regulations, Data privacy, App store compliance, Export controls |
| `licensing.md` | 5 | Licensing rationale, Competitor licensing, CLA strategy |
| `data-model-research.md` | 6 | Entity design, Import/export formats, API landscape, Sync/collaboration considerations |
| `personas-and-positioning.md` | 7 | User personas, Messaging strategy, Brand voice |
| `go-to-market.md` | 7 | Launch channels, Community strategy, Phased rollout |
| `feature-roadmap.md` | 1, 6 | P0/P1/P2/P3 feature tiers based on competitor analysis and technical research |
| `revenue-projections.md` | 2, 3 | Comparable company analysis, 5-year projections |
| `index.md` | all | Document index table with descriptions |

### Phase 4: Cross-Reference and Align

After generating all documents:

1. **Internal cross-references**: Add `> See also: [Related Doc](./related-doc.md)` blockquotes where documents reference each other
2. **Pricing consistency**: Verify the recommended pricing model is justified by competitive research and unit economics and is consistent across all documents
3. **Consistency check**: Ensure market size numbers, competitor details, and pricing match across all documents

### Phase 5: Summary

Present to the user:
- List of documents created with line counts
- Top 10 key findings across all research
- Recommended pricing model with rationale
- Areas where research was thin or needs follow-up
- Recommended next steps (e.g., "the nutrition database API pricing needs deeper investigation")

Ask if any areas need deeper research or revision before proceeding.

## Document Format Standards

Every document must follow this structure:

```markdown
---
title: Document Title
description: One-line summary
---

# Document Title

> Research conducted {month year}. {Scope note and cross-references to related docs.}

---

## Table of Contents

1. [Section](#section)
...

---

## Section

{Content}
```

**Conventions:**
- YAML frontmatter: `title` and `description` (required)
- Blockquote after heading with research date and cross-references
- Horizontal rules separating TOC from content
- Tables for all comparisons (competitors, pricing, features)
- Bold key numbers and findings for scannability
- Source attribution inline where possible
- "What to Avoid" section in business plan and go-to-market docs
- End with actionable takeaways, not vague conclusions

## Rules

- **Research agents run in parallel** — maximize speed
- **No filler** — every paragraph should contain specific, verifiable information
- **Quantify everything** — market sizes, user counts, pricing, growth rates with sources
- **Research the graveyard** — failed/discontinued competitors are as informative as successful ones
- **Pricing needs justification** — every pricing recommendation must be backed by competitive data and unit economics
- **Don't fabricate** — flag gaps honestly rather than inventing statistics
- **Stand-alone documents** — each doc should be readable independently
- Ask the user before proceeding to document generation, and again after completion for revisions
