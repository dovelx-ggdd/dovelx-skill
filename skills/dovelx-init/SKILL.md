---
name: dovelx-init
description: 初始化当前工作区项目：扫描仓库结构与关键清单文件，生成根目录 PROJECT.md 作为项目画像与快速导航；并可选配置 Cursor Rules（.cursor/rules）与 Hooks，使每次打开项目时 Agent 优先依据 PROJECT.md 分析。当用户说 /dovelx-init、"初始化项目"、"生成 PROJECT.md"、"项目画像" 时激活。
origin: dovelx
disable-model-invocation: true
---

# dovelx-init — 项目初始化与 PROJECT.md

> **输出语言**：与用户交互、写入 `PROJECT.md` 与规则说明时使用**中文**；代码与命令示例保持仓库原有语言。

## 目标

1. 在**当前工作区根目录**生成或更新 `PROJECT.md`，集中描述项目 identity、栈、目录、命令、约定，便于每次打开仓库时快速建立上下文。
2. 指导将 `PROJECT.md` **接入 Cursor**：通过 **Project Rules**（推荐）或 **Hooks**（可选）让 Agent 默认遵循该文档。

## 何时执行

- 用户首次打开陌生仓库、或项目结构经历大改后需要刷新「项目说明书」。
- 用户明确要求初始化、生成 `PROJECT.md`、或与 Cursor 规则/钩子联动。

## Phase 1 — 发现（只读）

在写文件前，**必须**基于仓库实际情况收集信息（工具可用时用 `Glob` / `Read` / `Grep`，否则用终端）：

| 关注点 | 典型来源 |
|--------|----------|
| 名称与用途 | `README*`、`package.json` name/description、`pyproject.toml`、服务名 |
| 技术栈 | `package.json`、`pnpm-lock.yaml`、`requirements.txt`、`go.mod`、`Cargo.toml`、`Dockerfile`、`*.csproj` |
| 入口与脚本 | `package.json` scripts、`Makefile`、`Taskfile`、`justfile`、`docker-compose*.yml` |
| 源码布局 | `src/`、`apps/`、`packages/`、`lib/`、`cmd/`、`internal/` |
| 测试与 CI | `vitest`、`jest`、`pytest`、`go test`、`/.github/workflows/*` |
| 配置与环境 | `.env.example`、`config/`、`appsettings*` |
| 既有 AI 约定 | `.cursor/rules/`、`AGENTS.md`、`CONTRIBUTING.md` |

若信息缺失，在 `PROJECT.md` 对应节目标注 **「待补充」**，不要编造依赖或命令。

## Phase 2 — 生成 `PROJECT.md`

- **路径**：仓库根目录 `PROJECT.md`（与 `README.md` 并存；`README` 面向人，`PROJECT.md` 面向 Agent 与协作者快速对齐上下文）。
- **若已存在**：先读取现有内容，**合并更新**（保留仍有效的段落，更新变更部分），并在文末更新 **「文档更新记录」** 一行当日摘要。

### 必须包含的章节结构

按下列顺序输出（无数据则写「暂无 / 待补充」）：

```markdown
# <项目名>

## 一句话摘要
<本仓库解决什么问题 / 面向谁>

## 技术栈
- 语言 / 运行时：
- 框架与核心库：
- 包管理与锁文件：
- 数据库 / 消息队列 / 外部服务（若有）：

## 仓库地图
（高信号目录与职责，列表即可，不必穷举 node_modules）

## 运行与开发
- 安装依赖：
- 本地启动：
- 构建：
- 测试：
- Lint / 类型检查（若有）：

## 配置与环境变量
- 必需变量（来源 `.env.example` 等）：
- 多环境说明（dev/staging/prod）：

## 架构与关键模块
（入口文件、分层、重要模块名与职责）

## 测试与质量
- 测试命令与目录：
- CI 要点（若可识别）：

## 约定
（代码风格、分支、提交、与本仓库相关的特殊规则；可引用 `.cursor/rules` 已有内容）

## 相关文档
- README / docs 链接（相对路径）

## 给 Agent 的提示
- 修改代码前应阅读的目录或文件：
- 禁止或高风险操作（若有）：

---
文档更新记录：YYYY-MM-DD — <本次变更简述>
```

## Phase 3 — 接入 Cursor（默认应做）

用户希望「每次打开项目能快速分析」→ **优先使用 Project Rules**，无需强依赖 Hooks。

### 3.1 推荐：创建或更新 Rule

在 `.cursor/rules/` 下新建或合并一个规则文件，例如 `project-context.mdc`：

```markdown
---
description: 项目画像与上下文入口；分析或修改本仓库前优先遵循根目录 PROJECT.md
alwaysApply: true
---

# 项目上下文

- 本仓库的结构、命令、约定与模块说明以**根目录 `PROJECT.md`** 为准。
- 在开始实现、重构或排查问题前，先阅读 `PROJECT.md` 中与当前任务相关的章节，并保持文档与代码变更同步（重大结构或命令变化时更新 `PROJECT.md`）。
- `README.md` 侧重人类快速上手；`PROJECT.md` 侧重全景与 Agent/协作者对齐。
```

- 若仓库已有 `alwaysApply: true` 的全局规则，**避免重复冗长**：可将上述要点合并进现有全局规则的一条列表，或保留独立文件但控制总行数（参考 create-rule：单条规则宜精炼）。

### 3.2 可选：Hooks

仅在用户明确要求使用 Hooks、或需在 **session 开始** 强制提醒时使用。

- **位置**：项目级 `.cursor/hooks.json` + `.cursor/hooks/*`。
- **常见事件**：`sessionStart`（会话开始注入「先读 PROJECT.md」类提示）或 `beforeSubmitPrompt`（策略类校验）。
- **实现要点**：遵循 Cursor hooks 的 JSON schema 与 stdin/stdout 协议；失败策略（fail open/closed）需与用户确认。

具体格式与事件列表以 **create-hook** 技能为准；本技能不强制生成 Hook 文件。

## Phase 4 — 收尾

1. 向用户说明：`PROJECT.md` 路径、Rule 文件路径（若创建）、以及「以后结构变了如何刷新」（重新执行本技能或手动编辑 `PROJECT.md`）。
2. 若项目无 `.gitignore` 或团队希望忽略本地规则：说明 `PROJECT.md` 与 `.cursor/rules` 是否应提交（默认建议**提交**，以便团队与 Agent 一致）。

## 注意事项

- **不要**把密钥、token、真实连接串写入 `PROJECT.md`。
- **不要**把整棵文件树逐文件列出；保持高信号、可维护。
- 与 `dovelx-ask` 等技能协作时：`PROJECT.md` 可作为问答与检索的优先静态索引之一。

## 附加资源

- Cursor Rule 文件格式与 `alwaysApply` / `globs`：见 **create-rule** 技能。
- Hooks 事件与 `hooks.json`：见 **create-hook** 技能。
