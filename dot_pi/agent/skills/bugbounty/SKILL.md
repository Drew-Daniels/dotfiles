---
name: bugbounty
description: Comprehensive bug hunt — find logic errors, data corruption risks, race conditions, edge cases, and off-by-one errors in the codebase
argument-hint: "[optional: specific file, directory, or area to focus on]"
disable-model-invocation: false
---

# Bug Bounty

Hunt for real bugs — logic errors, data corruption risks, race conditions, unhandled edge cases, and incorrect behavior. This is NOT a style/refactor audit or a security audit. The goal is to find code that **produces wrong results, crashes, corrupts data, or behaves unexpectedly** under real-world conditions.

If the user specified a focus area: {{arguments}}
Otherwise, hunt across the entire codebase.

## Process

### Phase 1: Understand the System

- Read project configuration files and CLAUDE.md/README to understand the tech stack, architecture, and data model
- Identify the most critical data paths — what operations would cause the worst damage if they go wrong (data writes, sync, encryption, financial calculations, auth)
- Understand the concurrency model (async/await, isolates, threads, workers)
- Note the database design (schema, constraints, transactions)
- Identify external integration points (APIs, file I/O, platform channels)

### Phase 2: Data Integrity Bugs

Search for code that could corrupt, lose, or silently mishandle data:

**Write path correctness**
- Database writes that should be transactional but aren't (multiple writes that must succeed or fail together)
- Missing rollback on partial failure (first write succeeds, second throws, first isn't reverted)
- Upsert/update logic that overwrites fields it shouldn't (updating a full row when only one field changed)
- Soft-delete or archive logic that misses related/child records
- Bulk operations that silently skip failures instead of reporting them

**Read path correctness**
- Queries that assume data exists when it might not (missing null checks after lookups)
- Stale reads — reading a value, doing async work, then using the value without re-checking
- Pagination/offset bugs that skip or duplicate items
- Sort order assumptions that don't hold after data changes
- Filter logic that produces incorrect results for edge-case inputs (empty string, null, zero, negative)

**Data transformation bugs**
- Lossy conversions (truncating doubles to ints, timezone-unaware datetime parsing, encoding issues)
- String-to-number parsing without error handling
- JSON/XML parsing that silently drops unknown fields or mishandles nested structures
- Date/time arithmetic that doesn't account for DST, leap years, or timezone offsets
- Unicode handling issues (string length vs. grapheme count, normalization)

### Phase 3: State & Concurrency Bugs

**Race conditions**
- Shared mutable state accessed from multiple async operations without synchronization
- Check-then-act patterns where the condition can change between check and act
- UI state that can get out of sync with underlying data (optimistic updates without rollback)
- File operations that don't handle concurrent access (two processes writing the same file)
- Background task completing after the UI context is disposed

**State machine errors**
- States that can become invalid (e.g., `isLoading=true` and `error!=null` simultaneously)
- Missing state transitions (state gets stuck — no path from error back to idle)
- Event handlers that don't check current state before acting (processing input while loading)
- Disposed/unmounted controllers or subscriptions that still receive events

**Lifecycle bugs**
- Resources not cleaned up (streams, timers, controllers, file handles, HTTP clients)
- Listeners/subscriptions that outlive their owner (memory leaks, ghost callbacks)
- Initialization order dependencies that aren't enforced
- Re-entrant calls to methods that aren't re-entrant safe

### Phase 4: Error Handling Bugs

**Silent failures**
- Catch blocks that swallow exceptions without logging or recovery (especially `catch (_) {}`)
- Async functions where errors vanish because the Future isn't awaited
- Error handlers that put the system in an inconsistent state
- Fallback/default values that mask real problems (returning empty list instead of propagating error)

**Error propagation bugs**
- Errors caught too broadly (`catch (e)` when only specific exceptions should be caught)
- Error recovery that doesn't fully restore state (partial rollback)
- User-facing error messages that expose internal details or are misleading
- Retry logic without backoff, max attempts, or idempotency checks

**Null / absence handling**
- Null dereference after a conditional that doesn't cover all paths
- Optional chaining that silently produces null where a value is required downstream
- Map/collection access with keys that might not exist
- APIs that return null vs. empty collection inconsistently

### Phase 5: Logic Errors

**Off-by-one and boundary errors**
- Loop bounds (< vs. <=, 0-indexed vs. 1-indexed)
- Substring/slice operations at string boundaries
- Pagination (page 0 vs. page 1, last page calculation)
- Comparison operators (> vs. >=) in threshold checks
- Clamp/range operations that exclude valid boundary values

**Boolean logic errors**
- Inverted conditions (checking `!=` when `==` was intended, or vice versa)
- Short-circuit evaluation that skips necessary side effects
- De Morgan's law violations in complex boolean expressions
- Truthiness confusion (empty string, zero, empty list treated as false when it shouldn't be)

**Algorithm correctness**
- Sorting comparators that aren't consistent (violate transitivity)
- Deduplication that uses wrong equality (reference vs. value, case sensitivity)
- Search/filter logic that produces false positives or false negatives
- Accumulator patterns that don't handle the empty case
- Math operations that can overflow, underflow, or produce NaN/Infinity

### Phase 6: Integration & Platform Bugs

**API integration bugs**
- HTTP responses not checked for status codes before parsing body
- Timeout handling that leaves operations in limbo
- Retry logic that can cause duplicate side effects (non-idempotent POST retried)
- API response shape assumptions that will break when the API returns unexpected fields or structures
- Missing content-type or encoding handling

**Platform-specific bugs**
- Platform checks that miss a platform (e.g., handles iOS and Android but crashes on macOS)
- File path construction that doesn't work cross-platform (hardcoded separators, case sensitivity)
- Features used on platforms that don't support them (without proper feature detection)
- Permissions not requested before accessing protected resources

**UI/UX bugs** (if applicable)
- User input not trimmed/normalized before processing
- Forms that can be submitted multiple times (double-tap, rapid click)
- Async operations that don't show loading state or disable interaction
- Navigation that can push duplicate routes
- Text overflow, layout breakage on extreme content (very long strings, empty content)

### Phase 7: Test Analysis

- Read existing tests to understand what IS tested
- Identify logic that has tests but the tests don't cover edge cases
- Look for tests that are testing the wrong thing (passing but not actually validating correctness)
- Find assertions that are too loose (checking type but not value, checking length but not content)
- Identify test gaps — complex logic with zero test coverage

## Output Format

Present findings organized by **confidence and severity**:

### Confirmed Bugs (Definitely wrong — can demonstrate incorrect behavior)
For each finding:
- **Location**: file path and line range
- **Bug**: clear description of the incorrect behavior
- **Trigger**: specific input or condition that causes the bug
- **Impact**: what goes wrong (data loss, crash, wrong result, UX glitch)
- **Fix**: concrete correction

### Likely Bugs (Almost certainly wrong — would need runtime verification)
Same format, plus:
- **Why likely**: reasoning for why this is probably a bug, not intentional

### Suspicious Code (Smells like a bug — warrants investigation)
Same format, plus:
- **Question**: what would need to be true for this NOT to be a bug

## Rules

- **Read the actual code.** Use Grep and Glob extensively. Every finding must reference specific lines.
- **Prove it or flag uncertainty.** If you can trace the bug to a concrete wrong result, it's "confirmed." If you need runtime context, it's "likely." If it depends on assumptions, it's "suspicious."
- **Prioritize by blast radius.** Data corruption > crash > wrong result > UX glitch. A silent data-corruption bug in a rarely-hit path is worse than a visible crash in a common path.
- **Think like a user, not a linter.** The question isn't "does this follow best practices?" — it's "will this break in production?"
- **Check the tests.** If a function has tests, check whether the tests actually validate the behavior you're worried about. A tested edge case isn't a finding.
- **Consider real-world inputs.** Empty strings, null values, Unicode, very large inputs, concurrent access, network timeouts, disk full, permission denied.
- **Don't report style issues.** This is not a refactor audit. Ugly code that works correctly is not a finding.
- After presenting findings, **ask the user which bugs they want to fix** before making any changes.

## Phase 8: Fix Plan

After the user confirms which bugs to fix, present the plan inline:

**For each confirmed/likely bug:**
1. **Root cause**: one sentence explaining why the bug exists
2. **Fix**: exact code change (file, line range, what to change)
3. **Test**: how to verify the fix (specific test case with input and expected output)
4. **Risk**: could this fix break anything else? what to watch for

**Ordering:**
- Fix data-corruption bugs first
- Fix crash bugs second
- Group related bugs that share a root cause
- Each fix should be independently committable

Present as a numbered checklist for user approval before making changes.
