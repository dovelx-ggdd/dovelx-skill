# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude Code skill plugin package** (`dovelx`) — a collection of AI-powered skills for professional software development workflows. It has no build system, no dependencies, and no tests. All content is Markdown-based skill definitions interpreted by the Claude Code runtime.

- **Plugin manifest:** `.claude-plugin/plugin.json`
- **Skills:** `skills/` — each subdirectory contains a `SKILL.md` defining one skill
- **Agents:** `agents/` — each `.md` file defines a subagent invoked by orchestration skills
- **Validation:** `scripts/validate-skills.sh` — validates both `skills/` and `agents/`

## Skill Architecture

Eleven skills are provided, organized in two layers:

**Atomic skills** (single-purpose, directly invocable):
| Skill | Directory | Slash Command | Role |
|-------|-----------|---------------|------|
| 需求分析师 | `skills/requirements/` | `/dovelx-requirements` | Requirements gathering → PRD |
| 技术设计师 | `skills/tech-design/` | `/dovelx-tech-design` | Architecture & API/DB design |
| 代码审查员 | `skills/code-review/` | `/dovelx-code-review` | Multi-dimensional code review |
| 需求文档审查 | `skills/requirement-review/` | `/dovelx-requirement-review` | PRD review across 5 dimensions |
| 代码重构审查 | `skills/restruct-reviewer/` | `/dovelx-restruct-reviewer` | Refactor quality review |
| Bug 诊断修复 | `skills/bug-resolver/` | `/dovelx-bug-resolver` | Systematic bug diagnosis & fix |
| API 测试团队 | `skills/qa-team/` | `/dovelx-qa-team` | 3 并行 Agent：综合/安全/性能+E2E 测试 |

**Orchestration skills** (coordinate multiple agents/phases):
| Skill | Directory | Slash Command | Role |
|-------|-----------|---------------|------|
| 专业审查团队 | `skills/review-team/` | `/dovelx-review-team` | 3 parallel agents: spec/standards/security |
| 开发团队编排 | `skills/dev-team/` | `/dovelx-dev-team` | 4-phase pipeline: requirements → design → dev → review |
| 端到端全栈工作流 | `skills/all-stack/` | `/dovelx-all-stack` | 9-phase workflow with user gate controls |

## Agent Directory

Eleven subagents in `agents/` are dispatched by orchestration skills:

| Agent file | Dispatched by | Role |
|------------|--------------|------|
| `requirements-analyst.md` | `dev-team` | Executes requirements analysis phase |
| `tech-designer.md` | `dev-team` | Executes technical design phase |
| `code-reviewer.md` | `dev-team`, `all-stack` | Executes code review phase |
| `spec-reviewer.md` | `review-team` | Reviews requirements/design completeness |
| `code-standards-reviewer.md` | `review-team` | Reviews code conventions |
| `security-performance-reviewer.md` | `review-team` | Reviews security and performance |
| `challenge-reviewer.md` | `all-stack` Phase 4/5 | Adversarial design challenge review |
| `design-reviewer.md` | `all-stack` Phase 7 | Design document review |
| `qa-api-tester.md` | `qa-team` Agent A | 功能/连通/逻辑/幂等性/边界值测试 |
| `qa-security-tester.md` | `qa-team` Agent B | 认证测试、安全测试（OWASP API Top 10） |
| `qa-performance-e2e-tester.md` | `qa-team` Agent C | 压力测试（k6/wrk/ab）+ 页面 E2E 测试 |

## Validation

```bash
bash scripts/validate-skills.sh
```

Checks every `SKILL.md` and agent `.md` for required frontmatter fields, correct naming conventions, and presence of `examples/` directories. Run this before bumping the version.

## SKILL.md Frontmatter Requirements

Every `skills/<name>/SKILL.md` must have:
```yaml
---
name: dovelx-<name>        # MUST start with "dovelx-"
description: <non-empty>
origin: dovelx             # recommended
---
```

Every `agents/<name>.md` must have:
```yaml
---
name: <name>
description: <non-empty>
origin: dovelx             # recommended
---
```

## Document Output Convention

All generated documentation must be saved to `.claude/doc/` following the global CLAUDE.md convention:

```
.claude/doc/<功能名>/
├── prd-<YYYY-MM-DD>-v1.md           # PRD (requirements phase)
├── design-<YYYY-MM-DD>-v1.md        # Technical design (design phase)
└── code-review-<YYYY-MM-DD>-v1.md   # Review report (review phase)
```

All document content must be written in Chinese.

## Adding or Modifying Skills

- Add a new subdirectory under `skills/` with a `SKILL.md` — auto-discovered, no registration needed
- Add a new `.md` file under `agents/` — auto-discovered, no registration needed
- Run `bash scripts/validate-skills.sh` to verify before committing
- The `skills/all-stack/` skill has multiple phase template files (e.g. `phase1-brief-template.md`) alongside `SKILL.md` and `workflow-detail.md`

## Plugin Registration

To publish a new version:
1. Update `version` in `.claude-plugin/plugin.json`
2. Component paths in `plugin.json` **must** start with `./` (relative to the plugin root, not relative to `plugin.json` itself — `../` paths fail schema validation)

## Installation (for end users)

```
/plugin marketplace add WangZhenLx/dovelx-skill
/plugin install dovelx@dovelx-skill
```

Multi-agent skills (`review-team`, `dev-team`, `all-stack`, `qa-team`) require:
```json
{ "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
```
in `~/.claude/settings.json`.
