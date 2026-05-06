# klrunning.com

A marketing site for our running club. Starts as a static site (info, photos, graphics) and may grow over time. No backend planned for v1.

This file is the working contract between Mathias and Claude (and a quick orientation for any future contributor). It is intentionally short; details live in the code.

---

## Stack

| Layer | Choice | Why |
|---|---|---|
| Frontend | **Astro + TypeScript** | Content-leaning site, ships near-zero JS by default, great DX |
| Hosting | **Firebase Hosting** | Google-owned, free tier, automatic TLS, low ops overhead |
| Infra-as-Code | **Terraform** | Single source of truth for GCP resources |
| Cloud | **GCP** — project `mathias-privat` | |
| DNS | **Cloud DNS** managed zone | Registrar stays at Squarespace; nameservers point to Cloud DNS |
| CI/CD | **GitHub Actions** | Auth via Workload Identity Federation — no long-lived service-account keys |

## Repo layout

```
.
├── CLAUDE.md          # this file
├── web/               # Astro app (added in PR #2)
├── infra/             # Terraform (added in PR #3)
└── .github/workflows/ # CI + deploy pipelines
```

## Working agreements

These exist because this is a side project Mathias wants to run with real engineering hygiene — PRs are the project log, not just a review gate.

### Pull requests

- **Every change goes through a PR.** Never push to `main`.
- **Small, focused PRs.** One concern per PR. Splitting scaffolding into 3 PRs is correct, not pedantic.
- **PR description = the durable record.** Explain *why*, not just *what*. Future-you reads this in 6 months.
- **CI must pass before merge.** No `--no-verify`, no merging red.
- **Squash merge** by default — one commit per PR on `main`. The repo is configured so the squash commit subject **is the PR title**, so the PR title is the commit message that lands on `main`.
- **PR title must follow [Conventional Commits](https://www.conventionalcommits.org/).** Format: `<type>(<optional scope>): <subject>` — e.g. `feat(web): add hero section`, `chore(infra): bump terraform google provider`, `docs: clarify deploy steps`. Enforced by `.github/workflows/commitlint.yml`.

### Branches & commits

- Branch from `main`. Naming is loose — pick something descriptive (`infra/firebase-hosting`, `web/hero-section`, `ci/deploy-workflow`).
- In-branch commits can be informal (WIP-style is fine while iterating). Only the **squashed PR title** has to satisfy Conventional Commits, since that's the only commit that lands on `main`.
- Rebase on `main` before merging if there are conflicts; don't merge `main` into the branch.

### Infra changes

- Run `terraform fmt` and `terraform validate` locally before committing.
- Paste the relevant `terraform plan` output into the PR description for any infra PR.
- Treat `terraform apply` as production: read the plan carefully, apply manually for now (no auto-apply on merge until we're confident).

## Secrets & what stays out of git

Already covered by `.gitignore`, but explicit so we're aligned:

- **Never commit:** `*.tfvars` (contains billing account ID, project number), `.env*`, `*.tfstate`, service-account JSON keys (we shouldn't have any — WIF removes the need).
- **Commit:** `*.tfvars.example` with placeholders, `.terraform.lock.hcl` (pins provider versions).
- **GitHub Actions secrets:** GCP project ID, WIF provider name, deploy SA email. No raw keys.

## Local dev quickstart

Filled in as scaffolding lands. Targets:

```bash
# web/   — Astro dev server (added in PR #2)
cd web && npm install && npm run dev

# infra/ — Terraform (added in PR #3)
cd infra && terraform init && terraform plan
```

## Notes for Claude

- **Default to action over planning** for low-risk work (file edits, scaffolding, doc updates). Ask before destructive ops, before changes to shared GCP state, and before anything touching DNS for a domain that may already be serving traffic.
- **One PR per scope unit.** If a request spans frontend + infra + CI, propose a multi-PR plan first.
- **Surface uncertainty.** If a Squarespace/GCP/Firebase detail is fuzzy, say so rather than guessing.
- **Don't introduce abstractions ahead of need.** This is a marketing site, not a platform.
