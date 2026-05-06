---
name: quality-review
description: "Comprehensive code review: rules compliance, DRY/reuse, runtime + infra correctness, and efficiency. Adapted for the klrunning Astro + TypeScript + Terraform stack. Use after implementation, before pushing."
---

# Quality Review

Review all changed code for rules compliance, reuse, runtime/infrastructure correctness, and efficiency. If a plan file is available, also validate that the implementation matches its intent. Report findings only — do not implement fixes.

## Phase 1: Prepare Agent Context

Determine the diff source and build a focused file list. Do NOT read the diff, rules, or files yourself — the agents gather their own context.

1. Determine the diff command:
   - If a PR number is provided: `gh pr diff <number>`
   - Otherwise: `git diff origin/master...HEAD`
2. Get the list of all changed files: `git diff origin/master...HEAD --name-only`
3. Split into source files and test files using this repo's conventions:
   - **Source**: `web/src/**/*.{astro,ts,tsx,js,mjs}`, `web/*.{ts,mjs}` (configs), `infra/**/*.tf`, `.github/workflows/**/*.yml`
   - **Tests**: `web/**/*.test.{ts,tsx}`, `web/**/*.spec.{ts,tsx}` (no formal test suite yet — empty test list is fine)
4. Check if a **plan file** was provided by the caller (or exists at a known path). Note whether intent review should run.

## Phase 2: Launch Review Agents in Parallel

Spawn agents concurrently using the Agent tool. Each agent has its own scope, checks, and output format defined in its agent file. **Do NOT rewrite or augment agent prompts** — no review focus areas, checklists, methodology, or additional instructions. The agents are self-sufficient. Use a minimal prompt like:

```
Review the changes in this repo.
- Diff command: [command from Phase 1]
- Source files: [non-test file list]
- Test files: [test file list]
- [any additional context from caller]
```

**Always launch these four:**
1. **quality-review-rules** — checks every changed file against documented project rules (CLAUDE.md, `.claude/rules/` if present)
2. **quality-review-dry** — granular duplication analysis and existing utility reuse
3. **quality-review-quality** — TS runtime correctness (async, types, error handling) and Terraform configuration correctness (references, IAM, dependencies)
4. **quality-review-efficiency** — redundant work, missed concurrency, bundle/build cost, image handling

**Conditionally launch (only when a plan file is available):**
5. **code-review-validator** — intent review: verifies the implementation accomplishes what the plan intended. Add plan file and test summary paths to its prompt:
   ```
   Review the changes in this repo.
   - Diff command: [command from Phase 1]
   - Source files: [non-test file list]
   - Plan file: [path]
   - Test summary: [path, if available]
   ```

## Phase 3: Consolidate and Report

After all agents complete, read their output files to gather findings:
- `.mcp-output/quality-review-rules.md`
- `.mcp-output/quality-review-dry.md`
- `.mcp-output/quality-review-quality.md`
- `.mcp-output/quality-review-efficiency.md`
- `.mcp-output/intent-review.md` (only if intent review ran)

Deduplicate (same issue found by multiple agents → report once). Classify by severity:

- **Critical** — correctness bugs, data loss risks, security issues (e.g. SA over-privileged, secrets exposed, WIF condition missing)
- **High** — rule violations that must be fixed, missing required tests, significant DRY violations
- **Medium** — quality/efficiency improvements, minor rule deviations, non-critical DRY
- **Low** — style, naming, minor optimizations

Each finding should give the user enough context to decide whether to fix it — without needing to open the file. Include:
1. **Summary** — 1-2 sentences explaining what's wrong and why it matters
2. **Code snippet** (optional) — include a short snippet (max 5 lines) when it makes the issue immediately obvious. Skip for conceptual issues (missing tests, architectural concerns). Pull directly from the agent's raw output.
3. **File references** — one or more `file:line` references. Paths MUST be fully qualified relative to the repo root (e.g. `web/src/pages/index.astro:42`, `infra/github_actions.tf:18`).

Keep each finding under 10 lines total. Don't pad — some findings need only a sentence and a link.

Output format — group by severity (high first). Each finding uses `#### [N] [severity] [reviewer] Title` where `reviewer` is one of: `rules`, `dry`, `quality`, `efficiency`, `intent`. Omit empty severity sections.

```
## Quality Review

### High

#### [1] [high] [quality] Finding title
Description — 1-2 sentences.
```ts
codeSnippet() // optional, max 5 lines
```
- `file:line`

### Medium

#### [2] [medium] [dry] Finding title
Description.
- `file:line`
- `file:line`

### Low

#### [3] [low] [efficiency] Finding title
Description.
- `file:line`

### Acknowledged
Issues noted but outside this PR's scope (pre-existing, accepted trade-offs).
- [Finding]. [file:line]. Reason: [one sentence].

### Intent (only if intent review ran)
**Intent:** [one sentence from code-review-validator]
**Verdict:** [PASS / FAIL]

### Acceptance Criteria (only if intent review ran)
- [x] [Criterion]
- [ ] [Criterion]: [why not met]

### Summary
- Critical: N, High: N, Medium: N, Low: N
- Intent: [PASS / FAIL / NOT RUN]
- Verdict: [PASS / NEEDS FIXES]
```

Write the full output to `.mcp-output/quality-review.md` in the repo root.

## Presenting to the user

After writing the file, present the findings to the user in chat. Use the same content but reformat the finding titles for readability: `#### [N] [severity] [reviewer] Title` in the file becomes `#### [N] Title [reviewer]` in chat (severity is already conveyed by the section grouping). Keep file paths fully qualified.

## Important

- **Read-only** — report findings, do not make changes
- **Cite rules** — every rule violation must reference the specific rule file and text (CLAUDE.md, `.claude/rules/` if present)
- **Be granular on DRY** — "lots of duplication" is useless feedback. Identify the specific duplicated units, what differs, and how to extract.
- **Type and async semantics matter** — verify promises are awaited, types are safe, async chains don't swallow errors.
- **Terraform semantics matter** — verify resource references resolve, `depends_on` reflects real dependencies, IAM bindings target the right principal, and `attribute_condition` actually constrains who can authenticate.
- **Skip false positives** — pre-existing issues not introduced by this PR, linter/compiler-catchable issues, style preferences not documented in the rules
- **Do not check build signal** — CI runs separately
- **Acknowledged section is load-bearing** — the orchestrator extracts it for the PR description. Always include it when intent review runs, even if empty.
