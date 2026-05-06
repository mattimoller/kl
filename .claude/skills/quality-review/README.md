# /quality-review

Automated code review skill that orchestrates specialized review agents in parallel. Run after implementation, before pushing.

Ported from Strise's `monoverse` repo and adapted for klrunning's stack (Astro + TypeScript + Terraform). The original was tuned for Scala + SQL — most of the SQL-specific guidance has been replaced with TypeScript runtime correctness and Terraform configuration correctness.

## Agents

| Agent | Focus |
|-------|-------|
| quality-review-rules | Rules compliance against `CLAUDE.md` and `.claude/rules/` |
| quality-review-dry | Code duplication, missed reuse of existing utilities/modules |
| quality-review-quality | TS runtime correctness, Terraform config correctness, error handling |
| quality-review-efficiency | Redundant work, missed parallel async, client-bundle cost, image handling |
| code-review-validator | Intent validation — does the code accomplish what the plan intended? |

The first four always run. The intent reviewer only runs when a plan file is provided.

## Output

All findings are consolidated into `.mcp-output/quality-review.md`, classified by severity (Critical / High / Medium / Low). The directory is gitignored.
