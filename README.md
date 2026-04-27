# dovelx-skill

> 将 AI 融入开发流程的每一个环节——从需求到上线，每一步都有迹可循。

`dovelx-skill` 是一套为 [Claude Code](https://claude.ai/code) 设计的专业技能包，将需求分析、技术设计、代码审查与全栈工作流封装为可直接调用的 AI 角色，帮助独立开发者和小型团队以工程化的方式驱动 AI 完成完整的软件开发生命周期。

---

## 技能一览

| 技能             | 命令                    | 职责                                                       |
|------------------|-------------------------|------------------------------------------------------------|
| 需求分析师       | `/dovelx-requirements`  | 澄清业务目标，拆解用户故事，输出结构化 PRD                |
| 技术设计师       | `/dovelx-tech-design`   | 设计架构方案、API 契约、数据库 Schema，记录技术决策       |
| 代码审查员       | `/dovelx-code-review`   | 多维度审查代码质量、安全性、性能与架构合规性              |
| 专业审查团队     | `/dovelx-review-team`                 | 三个并行 Agent 协作，覆盖需求完整性、代码规范与安全性能   |
| 开发团队编排     | `/dovelx-dev-team`      | 四阶段流水线：需求 → 技术设计 → 开发实现 → 代码审查       |
| 端到端全栈工作流 | `/dovelx-all-stack`     | 九阶段全流程，内置挑战审查与逐阶用户授权门控机制          |

---

## 核心特性

**全流程文档化**：每个阶段的产物均以标准模板落地为 Markdown 文档，保存至 `.claude/doc/<功能名>/`，决策过程完整可追溯。

**用户授权门控**：每一步生成文档后，必须经用户审阅确认方可推进。若提出修改意见，系统自动分析影响范围，按需回退至对应阶段修正后重新确认。

**多 Agent 并行审查**：专业审查团队技能将需求/设计、代码规范、安全性能三个维度拆分至独立 Agent 并行执行，消除单一视角的遗漏。

**渐进式介入**：可从任意阶段单独激活，也可一键启动完整流程，适配不同规模的任务场景。

---

## 安装前提

本技能包的**审查团队**与**开发团队编排**功能会派发多个并行 Agent，需要确保以下环境变量已正确配置：

本技能包的**审查团队**与**开发团队编排**功能依赖 Claude Code 的多 Agent 并行能力，安装前需完成以下两项配置。

### 1. 启用 Agent Team 功能

在 `~/.claude/settings.json` 的 `env` 字段中添加：

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

或在终端中临时启用：

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### 2. 配置 Claude API 密钥

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

> **Windows 用户** 使用 PowerShell：
> ```powershell
> $env:CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1"
> $env:ANTHROPIC_API_KEY = "sk-ant-..."
> ```

**未完成以上配置时，并行 Agent 功能将无法启动。** 单独调用 `/dovelx-requirements`、`/dovelx-tech-design`、`/dovelx-code-review` 不受影响。

---

## 安装

在 Claude Code 中执行：

```
/plugin marketplace add WangZhenLx/dovelx-skill
/plugin install dovelx@dovelx-skill
```

---

## 快速开始

描述你的需求，或直接调用对应命令：

```
# 完整流程（推荐）
/dovelx-all-stack

# 按需单独使用
/dovelx-requirements   ← 只做需求分析
/dovelx-tech-design    ← 只做技术设计
/dovelx-code-review    ← 只做代码审查
/dovelx-dev-team       ← 四阶段开发编排
/dovelx-review-team    ← 多维度多agent并行审查
```

所有输出文档统一使用中文撰写。

---

## 许可证

MIT © 2026 [WangZhenLx](https://github.com/WangZhenLx)
