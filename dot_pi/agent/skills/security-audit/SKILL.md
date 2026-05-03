---
name: security-audit
description: Comprehensive security audit of the codebase for vulnerabilities, secrets, and unsafe patterns
argument-hint: "[optional: specific area or concern to focus on]"
disable-model-invocation: false
---

# Security Audit

Perform a comprehensive security audit of the codebase. **Read actual code — do not guess.**

If the user specified a focus area: {{arguments}}
Otherwise, audit the entire codebase.

## Process

### Phase 1: Understand the Attack Surface

- Read project configuration and dependency files to understand the tech stack
- Read any CLAUDE.md, README, or architecture docs to understand data flow
- Identify what sensitive data the application handles (credentials, PII, financial data, tokens, keys)
- Map trust boundaries: user input entry points, external API calls, local storage, IPC, network boundaries
- Identify authentication and authorization mechanisms

### Phase 2: Secrets & Credential Exposure

Search thoroughly for:

**Hardcoded secrets**
- API keys, tokens, passwords, connection strings in source code
- Secrets in configuration files that are tracked in version control
- Private keys, certificates, or signing keys in the repo
- Default/fallback credentials in code

**Insufficient secret protection**
- Secrets stored in plaintext in local storage, shared preferences, or SQLite without encryption
- Secrets logged to console, crash reports, or analytics
- Secrets passed as URL query parameters (visible in logs, history, referrer headers)
- Secrets in environment variables without documentation of required setup

**Check files**: `.env*`, `*.config`, `*.json`, `*.yaml`, `*.yml`, `*.properties`, `*.plist`, `*.xml`, CI/CD configs, Docker files

### Phase 3: Input Validation & Injection

**SQL injection**
- Raw SQL construction with string concatenation or interpolation
- Unparameterized queries, especially with user-provided values
- ORM/query builder misuse that bypasses parameterization

**Command injection**
- Shell commands built with user input (`Process.run`, `exec`, `system`, etc.)
- Path traversal via unsanitized file paths from user input

**Cross-site scripting (XSS) / content injection**
- WebView usage with JavaScript enabled and untrusted content
- HTML rendering of user-supplied data without sanitization
- Deep link / URL scheme handlers that don't validate input

**Deserialization**
- Parsing untrusted JSON/XML/binary data without schema validation
- Type confusion from dynamic deserialization

### Phase 4: Authentication & Authorization

**Authentication weaknesses**
- Missing or bypassable authentication on sensitive operations
- Weak password/PIN requirements
- Missing brute-force protection or rate limiting
- Session tokens that don't expire or aren't invalidated on logout
- Biometric auth that falls back to weak alternatives without user awareness

**Authorization gaps**
- Missing ownership checks (can user A access user B's data?)
- Client-side-only authorization that isn't enforced server-side
- Privilege escalation paths
- IDOR (insecure direct object reference) patterns

### Phase 5: Data Protection

**Data at rest**
- Sensitive data stored unencrypted on disk
- Encryption with weak algorithms (DES, RC4, MD5 for passwords, ECB mode)
- Hardcoded or predictable encryption keys/IVs
- Key derivation without proper KDF (PBKDF2, Argon2, scrypt)
- Missing database encryption where required
- Sensitive data in application logs or debug output
- Cache/temp files containing sensitive data that aren't cleaned up

**Data in transit**
- HTTP used instead of HTTPS
- Missing certificate pinning for sensitive connections
- TLS verification disabled (`badCertificateCallback`, `--insecure`, verify=False)
- Sensitive data in URLs instead of request body

**Data leakage**
- Sensitive data in crash reports, analytics, or error messages
- Clipboard exposure of sensitive data without clearing
- Screenshot/screen recording exposure of sensitive screens (missing FLAG_SECURE or equivalent)
- Excessive data in logs (full request/response bodies, tokens, PII)

### Phase 6: Cryptography

- Use of deprecated or broken algorithms (MD5, SHA1 for security, DES, RC4)
- Custom cryptography implementations instead of established libraries
- Predictable random number generation for security-sensitive values (using `math.Random` instead of `SecureRandom`)
- Missing or improper IV/nonce handling (reuse, predictable values)
- Symmetric encryption without authentication (AES-CBC without HMAC — use AES-GCM)
- Key management issues: keys derived from insufficient entropy, keys stored alongside encrypted data

### Phase 7: Dependency & Supply Chain

- Check dependency files for known vulnerable versions (cross-reference with known CVEs if recognizable)
- Overly broad dependency version ranges that could pull in compromised versions
- Dependencies pulled from untrusted or non-default registries
- Vendored dependencies that are outdated
- Unused dependencies that increase attack surface

### Phase 8: Platform-Specific Concerns

**Mobile (iOS/Android/Flutter)**
- Insecure data storage (SharedPreferences for secrets, unencrypted databases)
- Missing root/jailbreak detection where relevant
- Exported components (activities, services, content providers) without protection
- Overly broad permissions
- Deep link handlers that don't validate origin or input
- WebView misconfigurations (JavaScript bridges, file access)
- Backup inclusion of sensitive data (allowBackup=true)

**Desktop**
- IPC mechanisms without authentication
- File permissions too broad on sensitive files
- Local server/socket endpoints without access control

**Web**
- Missing security headers (CSP, HSTS, X-Frame-Options)
- CORS misconfiguration
- CSRF protection gaps
- Cookie security flags (Secure, HttpOnly, SameSite)

### Phase 9: Logic & Design Flaws

- Race conditions in security-critical operations (TOCTOU)
- Error handling that reveals internal details (stack traces, SQL errors, file paths)
- Fail-open patterns (security checks that default to allowing on error)
- Missing audit logging for security-relevant events
- Timing side channels in authentication comparisons (use constant-time comparison)

## Output Format

Organize findings by **severity** using standard rating:

### Critical (Exploitable now, data breach risk)
For each finding:
- **Location**: file path and line range
- **Vulnerability**: what the issue is (reference CWE where applicable)
- **Impact**: what an attacker could achieve
- **Proof**: the specific code pattern found
- **Fix**: concrete remediation steps

### High (Exploitable with some effort or conditions)
Same format.

### Medium (Defense-in-depth gaps, hardening opportunities)
Same format.

### Low (Minor issues, best practice deviations)
Same format.

### Positive Findings
Briefly note security measures that are done well — this helps the user understand what's already covered and builds confidence in the audit.

## Rules

- **Read the actual code** — use Grep and Glob extensively. Do not guess.
- **No false positives** — only report issues you can point to in the code. If uncertain, flag it as "needs verification" rather than asserting.
- **Be specific** — "line 42 of auth_service.dart concatenates user input into SQL" not "there might be SQL injection somewhere"
- **Prioritize exploitability** — a theoretical issue behind three layers of authentication is lower severity than an unauthenticated endpoint
- **Consider the threat model** — a local-first app with optional sync has different risks than a public web API
- **Don't suggest security theater** — only recommend controls proportional to the actual risk
- After presenting findings, **ask the user which items they want to address** before making any changes

## Phase 10: Remediation Plan

After presenting findings and the user confirms, create a prioritized remediation plan:

### Plan Structure

1. **Present the plan inline** for the user to review and give feedback on — do NOT write it to a file unless the user explicitly asks
2. **Group fixes into waves** based on dependency and priority:

   **Wave 1 — Critical (immediate)**: Fixes for issues that are exploitable now with real impact. These should be addressed before any release.

   **Wave 2 — High (short-term)**: Issues exploitable with some effort or preconditions. Address within the current development cycle.

   **Wave 3 — Medium (hardening)**: Defense-in-depth improvements. Schedule into upcoming work.

   **Wave 4 — Low (best practices)**: Minor improvements to address opportunistically.

3. **For each fix in the plan, include**:
   - The finding reference (e.g., "Finding #1: XSS via EPUB HTML")
   - Severity and CWE (if applicable)
   - Files to modify (with line ranges)
   - Step-by-step implementation approach — concrete enough that a developer (or Claude) can execute without ambiguity
   - Testing strategy: how to verify the fix works (unit test, manual test, reproduction steps)
   - Estimated complexity: trivial / small / medium / large
   - Dependencies: note if one fix must land before another

4. **Include a summary table** at the top of the plan:

   | # | Finding | Severity | Wave | Complexity | Files |
   |---|---------|----------|------|------------|-------|

5. **Note any architectural considerations** — if multiple fixes touch the same area, suggest combining them. If a fix requires a new dependency or abstraction, call it out.

### Rules for the plan
- Be concrete and actionable — "sanitize HTML" is not enough; specify which sanitizer, which function, which inputs
- Don't gold-plate — propose the minimum effective fix, not a rewrite
- Order within each wave by: (1) highest impact first, (2) lowest complexity first when impact is equal
- If a finding was marked "needs verification", include a verification step before the fix
