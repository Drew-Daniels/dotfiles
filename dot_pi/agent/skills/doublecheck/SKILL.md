---
name: doublecheck
description: Re-verify a proposed plan for completeness, gaps, risks, and overlooked concerns before execution
argument-hint: "[optional: specific area to focus on]"
disable-model-invocation: false
---

# Doublecheck

You have been asked to critically re-examine the most recent plan or proposal in this conversation. **Do not implement anything. Your job is to find what's missing.**

If the user specified a focus area: {{arguments}}
Otherwise, audit the entire plan.

## Process

### 1. Restate the Plan

Briefly summarize the plan as you understand it — the goals, the proposed changes, and the expected outcomes. Keep this to a few bullet points so the user can confirm you're looking at the right thing.

### 2. Coverage Check

For each stated goal or requirement, verify:
- Is there a concrete step in the plan that addresses it?
- Are there requirements that were mentioned but silently dropped?
- Are there items the user asked for that the plan only partially covers?

Flag anything that was requested but isn't accounted for.

### 3. Edge Cases & Failure Modes

For each planned change, consider:
- What happens if this fails at runtime? Is there error handling?
- Are there platform-specific concerns (iOS vs Android vs desktop)?
- Are there concurrency or timing issues?
- Could this break existing functionality or tests?
- Are there data migration concerns?

### 4. Dependency & Ordering Issues

Check whether:
- Steps are listed in the right order (does step 3 depend on step 1 completing first?)
- There are circular dependencies between changes
- Any step requires work not mentioned in the plan (hidden prerequisites)
- The plan accounts for regenerating generated code, running migrations, etc.

### 5. Scope Creep & Overengineering

Assess whether:
- Any proposed change goes beyond what was actually asked for
- Simple problems are getting complex solutions
- New abstractions are being introduced where inline code would suffice
- The plan adds dependencies or infrastructure that aren't justified by the requirements

### 6. Security & Correctness

If applicable, check:
- Does the plan introduce any new attack surface?
- Are inputs validated at trust boundaries?
- Are secrets, credentials, or PII handled correctly?
- Are there race conditions or TOCTOU issues in the proposed changes?

### 7. Testing Strategy

Verify:
- Does the plan include how to verify each change works?
- Are there existing tests that will need updating?
- Are there gaps where new tests should be added but aren't mentioned?

### 8. Verdict

Summarize your findings in a clear table:

| Category | Status | Notes |
|----------|--------|-------|
| Coverage | ... | ... |
| Edge cases | ... | ... |
| Ordering | ... | ... |
| Scope | ... | ... |
| Security | ... | ... |
| Testing | ... | ... |

Then give one of:
- **Ready to execute** — no significant gaps found
- **Minor gaps** — list them, but safe to proceed with awareness
- **Needs revision** — list the issues that should be addressed before starting

**Wait for the user to respond before taking any action.**
