# dovelx-skill

> 将 AI 融入开发流程的每一个环节——从需求到上线，每一步都有迹可循。

`dovelx-skill` 是一套专业技能包，面向 [Claude Code](https://claude.ai/code) 与 [Cursor](https://cursor.com) Agent Skills / 插件市场，将需求分析、技术设计、代码审查与全栈工作流封装为可调用的 AI 角色，帮助独立开发者和小型团队以工程化方式驱动完整的软件开发生命周期。

---

## 技能一览

**原子技能**（单独调用）：

| 技能 | 命令 | 职责 |
|------|------|------|
| 需求分析师 | `/dovelx-requirements` | 澄清业务目标，拆解用户故事，输出结构化 PRD |
| 技术设计师 | `/dovelx-tech-design` | 设计架构方案、API 契约、数据库 Schema，记录技术决策 |
| 代码审查员 | `/dovelx-code-review` | 多维度审查代码质量、安全性、性能与架构合规性 |
| 需求文档审查 | `/dovelx-requirement-review` | 从五个维度审查 PRD 的完整性与合理性 |
| 代码重构审查 | `/dovelx-restruct-reviewer` | 审查重构质量，确保行为不变 |
| Bug 诊断修复 | `/dovelx-bug-resolver` | 系统化 Bug 诊断与修复 |
| API 测试团队 | `/dovelx-qa-team` | 3 个并行 Agent：功能测试、安全测试（OWASP）、压力测试 + E2E |
| 知识问答 | `/dovelx-ask` | 自然语言检索项目文档、代码库、数据库结构 |

**编排技能**（多 Agent 协作）：

| 技能 | 命令 | 职责 |
|------|------|------|
| 专业审查团队 | `/dovelx-review-team` | 三个并行 Agent 覆盖需求完整性、代码规范与安全性能 |
| 开发团队编排 | `/dovelx-dev-team` | 四阶段流水线：需求 → 技术设计 → 开发实现 → 代码审查 |
| 端到端全栈工作流 | `/dovelx-all-stack` | 九阶段全流程，内置挑战审查与逐阶用户授权门控机制 |

---

## 核心特性

**全流程文档化**：每个阶段的产物均以标准模板落地为 Markdown 文档，保存至 `.claude/doc/<功能名>/`，决策过程完整可追溯。

**用户授权门控**：每一步生成文档后，必须经用户审阅确认方可推进。若提出修改意见，系统自动分析影响范围，按需回退至对应阶段修正后重新确认。

**多 Agent 并行审查**：专业审查团队技能将需求/设计、代码规范、安全性能三个维度拆分至独立 Agent 并行执行，消除单一视角的遗漏。

**渐进式介入**：可从任意阶段单独激活，也可一键启动完整流程，适配不同规模的任务场景。

---

## 安装前提

**审查团队**、**开发团队编排**、**全栈工作流**、**API 测试团队**与**知识问答**技能会派发多个并行 Agent 或子 Agent，不同产品的配置如下。

### Claude Code：启用 Agent Team

在 `~/.claude/settings.json` 的 `env` 字段中添加：

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

> **Windows 用户** 使用 PowerShell：
> ```powershell
> $env:CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1"
> $env:ANTHROPIC_API_KEY = "sk-ant-..."
> ```

**未完成以上配置时，Claude Code 侧并行 Agent 团队将无法启动。** 单独调用 `/dovelx-requirements`、`/dovelx-tech-design`、`/dovelx-code-review` 等原子技能不受影响。

### Cursor：多 Agent / Subagents

Cursor **不使用** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`。编排类技能依赖 Cursor 对 Subagents 与并行任务的支持；若行为与预期不符，请在 Cursor Agent 中针对对应技能做一次实测。

> **Remote Rule (GitHub)**（设置 → Rules → 添加远程规则）仅适合导入远程规则类内容，**不等价于**安装完整插件（skills、agents、manifest 等打包能力请以 Cursor 插件为准）。

---

## 安装

### Claude Code

在终端或 Claude Code 中执行：

```
/plugin marketplace add DoveXiaZi/dovelx-skill
/plugin install dovelx@dovelx-skill
```

### Cursor（本地插件目录，推荐）

仓库根目录已包含 [`.cursor-plugin/plugin.json`](.cursor-plugin/plugin.json)。Cursor 会从用户配置目录下的 **`plugins/local`** 加载本地插件；官方亦推荐用**符号链接**指向插件仓库以便更新后无需复制文件（参见 [Cursor Plugins — Test plugins locally](https://cursor.com/docs/plugins)）。

1. **克隆本仓库**到本机任意路径，记为 `<REPO_ROOT>`（须为包含 `.cursor-plugin/` 的仓库根目录）。
2. **放入本地插件目录**（二选一）：
   - **符号链接（推荐）**：仓库仍在原路径，`git pull` 后重启或重载窗口即可用新版本。
     - **macOS / Linux**
       ```bash
       mkdir -p ~/.cursor/plugins/local
       ln -snf "<REPO_ROOT>" ~/.cursor/plugins/local/dovelx-skill
       ```
     - **Windows**（目录联接 `mklink /J`，通常不需管理员提升；请将 `<REPO_ROOT>` 改为你的绝对路径，例如 `E:\work-space\dovelx-skill`）
       ```powershell
       $local = Join-Path $env:USERPROFILE ".cursor\plugins\local"
       New-Item -ItemType Directory -Force -Path $local | Out-Null
       cmd /c mklink /J "$local\dovelx-skill" "<REPO_ROOT>"
       ```
       若提示「文件已存在」，请先删除 `%USERPROFILE%\.cursor\plugins\local\dovelx-skill` 再执行联接命令。
   - **复制**：将整个仓库文件夹复制到 `%USERPROFILE%\.cursor\plugins\local\dovelx-skill`（更新需重新复制）。
3. **重启 Cursor**，或在命令面板执行 **Developer: Reload Window**，使插件生效。
4. 打开任意工作区，在 **Agent** 对话中输入 **`/`**，搜索 **`dovelx-…`**（与各 `SKILL.md` 中 `name` 一致）即可唤起技能。

**可选**：若日后已在 [Cursor Marketplace](https://cursor.com/marketplace) 上架，也可在应用内搜索 **dovelx** 安装；未上架时以上本地目录方式即可完整使用 skills 与 agents。

---

## 快速开始

描述你的需求，或在 Claude Code 中直接调用对应命令（Cursor 用户可用 **`/`** 搜索同名技能）：

```
# 完整流程（推荐）
/dovelx-all-stack

# 按需单独使用
/dovelx-requirements   ← 只做需求分析
/dovelx-tech-design    ← 只做技术设计
/dovelx-code-review    ← 只做代码审查
/dovelx-dev-team       ← 四阶段开发编排
/dovelx-review-team    ← 多维度多 Agent 并行审查
/dovelx-qa-team        ← API 接口与安全压力测试
/dovelx-ask            ← 对话式知识问答
```

所有输出文档统一使用中文撰写。

---

## 许可证

MIT © 2026 [DoveXiaZi](https://github.com/DoveXiaZi)
