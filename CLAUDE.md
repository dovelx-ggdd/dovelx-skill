# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

`dovelx-skill` is a **declarative plugin package** (no compiled code) that delivers software-engineering workflow skills for Claude Code and Cursor. Skills are Markdown files with YAML frontmatter; agents are Markdown files that describe sub-agent roles. There is no runtime build step.

## Validation Commands

```bash
# Validate all SKILL.md frontmatter and directory-name alignment
bash scripts/validate-skills.sh

# Validate plugin.json/marketplace.json JSON syntax, agent paths, and version consistency
bash scripts/smoke-check-manifests.sh
```

Run both before opening a PR. CI runs them automatically on push.

## Debugging Skills in Claude Code

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

## Release Process

1. Bump **all four** version fields to the same value:
   - `.claude-plugin/plugin.json` → `version`
   - `.claude-plugin/marketplace.json` → `metadata.version`
   - `.cursor-plugin/plugin.json` → `version`
   - `.cursor-plugin/marketplace.json` → `metadata.version`
2. Add an entry to `CHANGELOG.md`.
3. Push to `main`, then tag: `git tag v<version> && git push origin v<version>`.
4. GitHub Actions creates the Release automatically.

## Architecture

### Skills (`skills/`)

Each skill is a directory containing `SKILL.md` (required), `examples/input.md`, `examples/output.md`, and optional `templates/`.

SKILL.md frontmatter:
```yaml
---
name: dovelx-<skill-name>   # must match the directory name exactly
description: <one-line trigger description>
origin: dovelx
---
```

The `name` field must match the directory name — this is a hard Cursor requirement enforced by CI.

**Atomic skills** (single Agent): `dovelx-requirements`, `dovelx-tech-design`, `dovelx-code-review`, `dovelx-requirement-review`, `dovelx-restruct-reviewer`, `dovelx-bug-resolver`, `dovelx-qa-team`, `dovelx-ask`, `dovelx-init`.

**Orchestration skills** (spawn sub-agents with editorial gate after each phase): `dovelx-review-team` (3 parallel agents), `dovelx-dev-team` (4 sequential agents), `dovelx-all-stack` (9 phases, up to 9 agents).

### Agents (`agents/`)

Each file is a Markdown sub-agent definition with YAML frontmatter (`name`, `description`, `origin: dovelx`, optional `tools: [...]`). Orchestration skills reference these by path in plugin.json.

### Plugin Manifests

`.claude-plugin/` and `.cursor-plugin/` each contain `plugin.json` (runtime config, skills path `./skills/`, agent list) and `marketplace.json` (publishing metadata). Both sets must stay version-synchronized.

### Document Output Convention

All skill outputs are written to `doc/<function-name>/` in the **user's workspace** (not this repo). File naming: `<phase>-<YYYY-MM-DD>-v<N>.md`. All output documents are in **Chinese**.

## gstack

Use the `/browse` skill from gstack for **all web browsing**. Never use `mcp__claude-in-chrome__*` tools directly.

Available gstack skills:
`/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/design-consultation`, `/design-shotgun`, `/design-html`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, `/benchmark`, `/browse`, `/connect-chrome`, `/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/setup-deploy`, `/setup-gbrain`, `/retro`, `/investigate`, `/document-release`, `/codex`, `/cso`, `/autoplan`, `/plan-devex-review`, `/devex-review`, `/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`, `/learn`

## Commit Convention

Follow Conventional Commits: `feat`, `fix`, `docs`, `refactor`, `chore`.

## Key Rules

- New skill: create `skills/<name>/SKILL.md` + `examples/`. No manifest change needed — plugin.json scans `./skills/` automatically.
- Skill `name` must start with `dovelx-`.
- Never remove existing SKILL.md fields; only add or improve.
- All four version fields must be identical or CI fails.
