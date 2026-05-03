---
name: refactor
description: Comprehensively audit the codebase for code smells, testability issues, and refactoring opportunities
argument-hint: "[optional: specific directory or area to focus on]"
disable-model-invocation: false
---

# Refactor Audit

Perform a comprehensive codebase audit for code smells and refactoring opportunities. **Testability is the primary lens** — code that is hard to test almost always indicates a design problem.

If the user specified a focus area: {{arguments}}
Otherwise, audit the entire codebase.

## Process

### Phase 1: Discover the Codebase Structure

- Read project configuration files (pubspec.yaml, package.json, build files, etc.) to understand the tech stack
- Read any CLAUDE.md, README, or architecture docs to understand intended patterns
- Map the directory structure and identify the major layers/modules
- Identify the existing test directory structure and what is/isn't tested

### Phase 2: Testability Analysis (Primary Focus)

Search thoroughly for these patterns that make code hard to test:

**Hard dependencies & tight coupling**
- Classes that directly instantiate their dependencies instead of accepting them via constructor injection
- Static method calls that perform I/O, network, or database access
- Global mutable state or singletons that carry state between tests
- Direct file system, network, or platform channel access without abstraction

**God objects & bloated classes**
- Classes/files over ~300 lines — likely doing too much
- Classes with many unrelated public methods (low cohesion)
- Methods with more than 3-4 parameters (often a missing abstraction)
- Methods over ~50 lines — candidates for extraction

**Logic buried in untestable places**
- Business logic inside UI/widget code that should be in a service or provider
- Complex conditional logic inside build methods or templates
- Data transformation or validation mixed into I/O operations
- Callback chains or deeply nested closures with embedded logic

**Missing seams**
- No interface/abstract class where swapping implementations would help testing
- Date/time access via `DateTime.now()` instead of an injectable clock
- Random number generation without injection
- Platform checks that can't be overridden in tests

### Phase 3: General Code Smells

Search for these additional patterns:

**Duplication & DRY violations**
- Copy-pasted logic across files (search for similar code blocks)
- Nearly identical classes that differ only in small ways
- Repeated error handling or validation patterns that could be centralized

**Abstraction problems**
- Leaky abstractions where implementation details leak across layer boundaries
- Over-abstraction: unnecessary interfaces, wrappers, or indirection with only one implementation and no testing benefit
- Primitive obsession: using raw strings/ints where a value object would add clarity and safety

**Control flow smells**
- Deeply nested conditionals (arrow/pyramid code)
- Long switch/case or if/else chains that could be polymorphism or a map
- Boolean parameters that change method behavior (hidden branching)
- Try/catch blocks that silently swallow errors

**Naming & clarity**
- Misleading names (method does more or different than name suggests)
- Ambiguous abbreviations or inconsistent naming conventions
- Comments explaining "what" instead of the code being self-documenting

### Phase 4: Cross-Cutting Concerns

- Inconsistent error handling strategies across the codebase
- Missing or inconsistent logging patterns
- State management patterns that vary without reason
- Inconsistent data flow patterns (some areas follow the architecture, others don't)

## Output Format

Present findings organized by **severity and impact**, not by category:

### Critical (High impact, likely causing bugs or blocking testability)
For each finding:
- **Location**: file path and line range
- **Smell**: what the problem is
- **Why it matters**: concrete impact on testability, maintainability, or correctness
- **Suggested fix**: specific refactoring approach (keep it minimal — don't over-engineer)

### Moderate (Worth refactoring when touching this code)
Same format as above.

### Minor (Nice-to-have improvements)
Same format as above.

## Rules

- **Read the actual code** — do not guess or assume. Use Grep and Glob extensively.
- **Focus on structural issues**, not style nitpicks (formatting, comment style, naming conventions that are merely preferences)
- **Respect the existing architecture** — suggest improvements within the project's chosen patterns, don't propose wholesale rewrites
- **Quantify when possible** — "5 files duplicate this pattern" is better than "there's some duplication"
- **Prioritize actionable findings** — every item should have a clear, concrete fix
- **Don't suggest adding complexity** — the fix should make the code simpler, not add layers
- After presenting findings, **ask the user which items they want to address** before making any changes

### Phase 5: Refactoring Plan

After the user confirms which items to address, **present the plan inline** for review — do NOT write it to a file unless the user explicitly asks.

**For each selected item, include:**
1. **Goal**: One-sentence description of the desired end state
2. **Steps**: Ordered list of concrete code changes (file paths, what to add/move/remove)
3. **Dependencies**: Which items must be done before this one (e.g., "Clock injection must happen before service tests can be written")
4. **Test strategy**: What tests to add or update to verify the refactoring didn't break anything
5. **Complexity**: trivial / small / medium / large

**Plan structure:**
- Group related items into **phases** that can be completed and committed independently
- Order phases so that earlier phases unblock later ones (e.g., inject dependencies before writing tests that need mocks)
- Each phase should leave the codebase in a working state — no half-finished refactors
- Keep phases small enough to review in a single PR

**Present the plan as a numbered checklist** so the user can approve, reorder, or skip phases. Do not begin making code changes until the user approves.
