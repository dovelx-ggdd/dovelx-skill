# 变更记录

本文件记录所有版本的重要变更，遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/) 规范。

---

## [1.0.9] - 2026-04-13

### 修复
- `plugin.json`：移除 `agents` 字段 — 该字段不被插件 schema 接受，导致安装时 `agents: Invalid input` 验证错误。Agents 由技能在运行时通过 Agent 工具直接引用，无需在 manifest 中声明

---

## [1.0.8] - 2026-04-13

### 修复
- `plugin.json`：`skills` 与 `agents` 路径由 `../skills` / `../agents` 修正为 `./skills` / `./agents`，符合插件 schema 路径规范（路径必须以 `./` 开头，不可使用 `../` 跨出插件根目录）

### 改进
- `CLAUDE.md`：更新技能总览（10 个技能），补充 `agents/` 目录说明、验证命令、frontmatter 规范及 `plugin.json` 路径规则

---

## [1.0.7] - 2026-04-13

### 新增
- `agents/` 目录：新增 8 个专属执行 Agent，将编排逻辑与执行细节分离
  - `spec-reviewer` — 需求与设计审查（由 `review-team` 派发）
  - `code-standards-reviewer` — 代码规范审查（由 `review-team` 派发）
  - `security-performance-reviewer` — 安全与性能审查（由 `review-team` 派发）
  - `requirements-analyst` — 需求分析执行（由 `dev-team` 派发）
  - `tech-designer` — 技术设计执行（由 `dev-team` 派发）
  - `code-reviewer` — 代码审查执行（由 `dev-team` / `all-stack` 复用）
  - `challenge-reviewer` — 挑战性评审（由 `all-stack` Phase 4/5 派发）
  - `design-reviewer` — 设计文档审查（由 `all-stack` Phase 7 派发）
- `plugin.json`：新增 `agents` 字段声明 `agents/` 目录
- 所有技能新增 `examples/input.md` + `examples/output.md` 示例文件
- `CHANGELOG.md`、`CONTRIBUTING.md`：完善开源文档
- `.github/workflows/`：新增 CI 验证（格式校验 + 版本一致性）和自动发版 workflow
- `scripts/validate-skills.sh`：扩展支持同时验证 `skills/` 和 `agents/` 目录

### 改进
- `review-team` 技能：移除内联 Agent 审查清单，改为引用 `agents/` 配置文件，技能更聚焦于编排流程
- `dev-team` 技能：各阶段明确标注对应 Agent 配置文件路径
- `all-stack` 技能：Phase 4/5/7/9 改为引用专属 Agent，减少重复定义

---

## [1.0.6] - 2026-04-13

### 修复
- `requirements` 技能：输出文档文件名由 `design-*.md` 更正为 `prd-*.md`，与文档命名规范对齐
- 所有技能重命名为 `dovelx-` 前缀，避免与其他插件命名冲突

---

## [1.0.5] - 2026-04-08

### 新增
- `restruct-reviewer` 技能：代码重构审查员，支持重构前后对比审查，覆盖功能等价性、设计合理性、性能影响五个维度

---

## [1.0.4] - 2026-04-08

### 新增
- `requirement-review` 技能：需求文档审查员，从完整性、明确性、一致性、可测试性、可行性五维度审核 PRD

### 改进
- 优化文档输出路径逻辑：先判断目录是否存在，不重复创建

---

## [1.0.3] - 2026-04-07

### 新增
- `bug-resolver` 技能：系统化 Bug 诊断与修复专家，强调先收集信息再定位根因
- `qa-tester` 技能：QA 测试专家，支持派发 2~3 个并行测试 Agent

### 改进
- `all-stack` 技能新增对抗性评审阶段（Phase 4），引入挑战者视角

---

## [1.0.2] - 2026-04-07

### 新增
- `all-stack` 技能：端到端九阶段全栈工作流，内置用户授权门控机制
- `dev-team` 技能：四阶段开发团队编排（需求 → 技术设计 → 实现 → 审查）

---

## [1.0.1] - 2026-04-07

### 新增
- `review-team` 技能：三个并行审查 Agent，覆盖需求/规范/安全性能三维度

### 改进
- 所有技能文档输出统一到 `.claude/doc/<功能名>/` 目录

---

## [1.0.0] - 2026-04-07

### 新增
- `requirements` 技能：需求分析师，澄清需求、拆解用户故事、输出 PRD
- `tech-design` 技能：技术设计师，输出架构方案、API 设计、数据库 Schema
- `code-review` 技能：代码审查员，多维度审查并按严重等级分类输出报告
- 插件基础配置：`plugin.json`、`marketplace.json`、`CLAUDE.md`
