# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

`dovelx-skill` is a **declarative plugin package** (no compiled code) that delivers software-engineering workflow skills for Claude Code and Cursor. Skills are Markdown files with YAML frontmatter; agents are Markdown files that describe sub-agent roles. There is no runtime build step.

## Validation Commands

```bash
# Validate SKILL.md & agent file frontmatter and directory-name alignment
bash scripts/validate-skills.sh

# Validate JSON syntax in all 4 manifests, agent path existence, and version consistency
bash scripts/smoke-check-manifests.sh
```

Run both before opening a PR. CI (`validate.yml`) runs them automatically on push to paths under `skills/`, `.claude-plugin/`, `.cursor-plugin/`, or `scripts/`.

## CI Pipeline

Two GitHub Actions workflows in `.github/workflows/`:

- **`validate.yml`** — Triggered on push/PR to `main` touching skills/plugin/scripts paths. Runs 4 parallel jobs: (1) validate-skills.sh, (2) plugin JSON required-field checks via `jq`, (3) agent file path existence, (4) version-number consistency across all 4 manifests.
- **`release.yml`** — Triggered by `v*.*.*` tag push. Validates tag matches manifest versions, extracts release notes from `CHANGELOG.md`, creates a GitHub Release.

## Installation (Claude Code)

```bash
# Install from marketplace (dovelx-ggdd/dovelx-skill)
/plugin marketplace add dovelx-ggdd/dovelx-skill
/plugin install dovelx@dovelx-skill
```

## Debugging Skills

### Claude Code

```bash
# Install from local path (development mode)
/plugin install dovelx@./

# Reload after changes
/plugin reload dovelx

# Invoke a skill directly
/dovelx-<skill-name>

# List registered skills
/plugin list
```

### Cursor

The repository includes `.cursor-plugin/plugin.json`. For local development, symlink the repo into `~/.cursor/plugins/local/`:

```bash
# macOS / Linux
ln -snf "$PWD" ~/.cursor/plugins/local/dovelx-skill

# Windows (PowerShell)
cmd /c mklink /J "$env:USERPROFILE\.cursor\plugins\local\dovelx-skill" "$PWD"
```

After symlinking, restart Cursor or run **Developer: Reload Window**. Skills appear in the Agent chat via `/dovelx-<skill-name>` — the directory name must match the `name` field in SKILL.md frontmatter, or Cursor will not discover them.

> **Note:** `.cursor/` is in `.gitignore` — local Cursor project rules in `.cursor/rules/` are not committed. For project-wide guidance checked into the repo, use CLAUDE.md (Claude Code) or .github/copilot-instructions.md (Copilot).

## Release Process

1. Bump **all four** version fields to the same value:
   - `.claude-plugin/plugin.json` → `version`
   - `.claude-plugin/marketplace.json` → `metadata.version`
   - `.cursor-plugin/plugin.json` → `version`
   - `.cursor-plugin/marketplace.json` → `metadata.version`
2. Add an entry to `CHANGELOG.md`.
3. Push to `main`, then tag: `git tag v<version> && git push origin v<version>`.
4. GitHub Actions `release.yml` creates the Release automatically.

## Architecture

### Skills (`skills/`)

Each skill is a directory containing `SKILL.md` (required), `examples/input.md`, `examples/output.md`, and optional `templates/`. Currently 12 skills:

**Atomic skills** (single Agent): `dovelx-requirements`, `dovelx-tech-design`, `dovelx-code-review`, `dovelx-requirement-review`, `dovelx-restruct-reviewer`, `dovelx-bug-resolver`, `dovelx-qa-team`, `dovelx-ask`, `dovelx-init`.

**Orchestration skills** (spawn sub-agents with editorial gate after each phase): `dovelx-review-team` (3 parallel agents), `dovelx-dev-team` (4 sequential agents), `dovelx-all-stack` (9 phases, up to 9 agents).

SKILL.md frontmatter:
```yaml
---
name: dovelx-<skill-name>   # must match the directory name exactly
description: <one-line trigger description>
origin: dovelx
---
```

The `name` field must match the directory name — this is a hard Cursor requirement enforced by CI.

### Agents (`agents/`)

13 Markdown files with YAML frontmatter (`name`, `description`, `origin: dovelx`, optional `tools: [...]`). Agents fall into two categories:

- **Manifest-declared** (10 agents, listed in both `plugin.json` manifests): Sub-agent roles referenced by orchestration skills (review-team, dev-team, all-stack). Includes spec-reviewer, code-reviewer, code-standards-reviewer, security-performance-reviewer, requirements-analyst, tech-designer, design-reviewer, challenge-reviewer, ask-searcher, ask-synthesizer.
- **Runtime-referenced** (3 agents, loaded by skills at runtime, not in manifests): `qa-api-tester`, `qa-security-tester`, `qa-performance-e2e-tester` — used exclusively by the `dovelx-qa-team` skill.

### Plugin Manifests

`.claude-plugin/` and `.cursor-plugin/` each contain `plugin.json` (runtime config, skills path `./skills/`, agent list) and `marketplace.json` (publishing metadata). Both sets must stay version-synchronized.

### Document Output Convention

All skill outputs are written to `doc/<function-name>/` in the **user's workspace** (the directory where Claude Code or Cursor is running, not this repo). File naming: `<phase>-<YYYY-MM-DD>-v<N>.md`. All output documents are in **Chinese**.

### Key Rules

- New skill: create `skills/<name>/SKILL.md` + `examples/`. No manifest change needed — both plugin.json files scan `./skills/` automatically. See `CONTRIBUTING.md` for the full procedure.
- Skill `name` must start with `dovelx-`.
- Never remove existing SKILL.md fields; only add or improve.
- All four version fields must be identical or CI fails. See `CONTRIBUTING.md` → "发版流程" for details.
- When modifying a skill, update its `examples/` and add a CHANGELOG entry.
- Agent files referenced in `plugin.json` must exist on disk — the CI `validate.yml` job checks this.

## Commit Convention

Follow Conventional Commits: `feat`, `fix`, `docs`, `refactor`, `chore`.

## Browse

Use the `/browse` skill from gstack for all web browsing. Never use `mcp__claude-in-chrome__*` tools directly.
