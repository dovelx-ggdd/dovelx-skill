# dovelx-skill

## 一句话摘要

面向 Claude Code 与 Cursor 的 **Agent Skills / 插件** 仓库，将需求、设计、审查、Bug、QA、全栈工作流与知识问答等能力封装为可调用的技能与子 Agent，供独立开发者与小团队工程化驱动软件生命周期。

## 技术栈

- 语言 / 运行时：仓库主体为 **Markdown**（技能与 Agent 定义）；校验与 CI 使用 **Bash**（`scripts/*.sh`）。
- 框架与核心库：无应用运行时；交付形态为 **Claude Code** / **Cursor** 插件清单（`.claude-plugin/`、`.cursor-plugin/`）及约定目录下的技能文件。
- 包管理与锁文件：无（非 Node/Python 应用仓库）。
- 数据库 / 消息队列 / 外部服务（若有）：无。

## 仓库地图

- `skills/` — 各技能的 `SKILL.md`、模板与 `examples/`（Cursor 要求子目录名与 frontmatter `name` 一致）。
- `doc/` — 技能运行时在**工作区根目录**下生成产物的约定根路径（如 `doc/<功能名>/`），具体见各 `SKILL.md`；目录可由使用者首次生成时创建。
- `agents/` — 编排/子 Agent 的 Markdown 定义（由 `.cursor-plugin/plugin.json` 的 `agents` 数组引用）。
- `.claude-plugin/` — Claude Code 插件与 marketplace 元数据（`plugin.json`、`marketplace.json`）。
- `.cursor-plugin/` — Cursor 插件与 marketplace 元数据。
- `scripts/` — `validate-skills.sh`（技能格式校验）、`smoke-check-manifests.sh`（清单冒烟）。
- `.github/workflows/` — PR/推送时校验技能与插件字段；`v*.*.*` tag 触发 Release。
- `README.md` — 面向使用者的安装与技能一览。
- `CONTRIBUTING.md` — 贡献流程、技能约定、发版步骤。

## 运行与开发

- 安装依赖：无包管理器依赖；贡献者需 **Git**；本地调试 Claude/Cursor 见 `README.md` / `CONTRIBUTING.md`。
- 本地启动：不适用（非可启动服务）。
- 构建：无。
- 测试 / 校验（推荐发 PR 前在类 Unix 环境或 Git Bash 执行）：
  ```bash
  chmod +x scripts/smoke-check-manifests.sh scripts/validate-skills.sh
  bash scripts/smoke-check-manifests.sh
  bash scripts/validate-skills.sh
  ```
- Lint / 类型检查（若有）：无独立 linter；格式与字段约定由 `validate-skills.sh` 与 CI 中的 `jq` 检查承担。

## 配置与环境变量

- 必需变量（来源 `.env.example` 等）：无；插件使用者需在各自环境中配置 Claude/Cursor 与 API（详见 `README.md`，勿将密钥写入本仓库文档）。
- 多环境说明（dev/staging/prod）：不适用本仓库形态。

## 架构与关键模块

- **技能发现**：每个技能为 `skills/<name>/SKILL.md`，YAML frontmatter 含 `name`（`dovelx-*`）、`description`、`origin`（推荐 `dovelx`）。
- **Cursor 插件入口**：`.cursor-plugin/plugin.json` 声明 `skills`（扫描 `./skills/`）、`agents`（指向 `agents/*.md` 具体文件）。
- **Claude 插件入口**：`.claude-plugin/plugin.json` 声明技能根路径等。
- **版本与发版**：四套清单中的 `version` / `metadata.version` 须与彼此及发版 tag 一致（见 `CONTRIBUTING.md`「发版流程」）。

当前技能目录（与 `name` 对齐）：`dovelx-all-stack`、`dovelx-ask`、`dovelx-bug-resolver`、`dovelx-code-review`、`dovelx-dev-team`、`dovelx-init`、`dovelx-qa-team`、`dovelx-requirement-review`、`dovelx-requirements`、`dovelx-review-team`、`dovelx-restruct-reviewer`、`dovelx-tech-design`。

## 测试与质量

- 测试命令与目录：`bash scripts/validate-skills.sh`；可选 `bash scripts/smoke-check-manifests.sh`。
- CI 要点（若可识别）：
  - `validate.yml`：变更触及 `skills/**`、插件或 `scripts/**` 时运行技能校验、Claude/Cursor `plugin.json` / `marketplace.json` 必填字段与 agent 路径存在性、四套版本号一致。
  - `release.yml`：推送 `v*.*.*` tag 时校验版本与 tag、从 `CHANGELOG.md` 摘要说明显创建 GitHub Release。

## 约定

- 技能生成的 Markdown 等文档默认写入**当前工作区根目录**下的 `doc/`（子路径见各技能，例如 `doc/<功能名>/`、`doc/requirement-review/`），不再使用 `.claude/doc/`。
- 技能产出文档默认 **中文**（见 `CONTRIBUTING.md`）。
- **Conventional Commits** 提交说明（`feat` / `fix` / `docs` 等）。
- 修改技能行为时同步 **examples**、**CHANGELOG**，并按 CONTRIBUTING 递增 **四套版本号**。
- 根目录 `.gitignore` 包含 `.cursor/`：本机 Cursor 项目规则若放在 `.cursor/rules/`，默认 **不会** 随 Git 提交；`PROJECT.md` 在仓库根目录，建议提交以统一上下文。

## 相关文档

- [README.md](README.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [CHANGELOG.md](CHANGELOG.md)
- [LICENSE](LICENSE)

## 给 Agent 的提示

- 修改代码前应阅读的目录或文件：与本次变更相关的 `skills/<skill>/SKILL.md`、`CONTRIBUTING.md`（新增/改技能时）、`.cursor-plugin/plugin.json` 与 `.claude-plugin/plugin.json`（注册 agent 或改清单时）。
- 禁止或高风险操作（若有）：勿在文档中写入真实密钥；改技能时勿破坏 frontmatter 必填项或与目录名不一致的 `name`（Cursor 加载要求）；发版相关改动须四面版本一致。

---
文档更新记录：2026-05-07 — 约定技能产出根路径为工作区 `doc/`，并补充仓库地图说明。
文档更新记录：2026-05-06 — 初始化 PROJECT.md（dovelx-init），概述仓库结构、命令、CI 与技能列表。
