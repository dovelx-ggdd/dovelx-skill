---
name: dovelx-all-stack
description: 端到端全栈开发工作流 — 从需求发现、分析、方案起草、对抗性评审、方案选型，到生成设计文档并完成带自测的编码实现。当用户提出新功能需求或说 /dovelx-all-stack 时激活。
origin: dovelx
---

# Dev Design — 需求到实现全流程工作流

> **输出语言规则**：所有生成的文档（设计文档、审查报告等）**必须使用中文**撰写。

Transform a requirement into a reviewed design and working code through a structured multi-phase process with built-in review checkpoints.

## Workflow Overview

```
Phase 1: Requirement Discovery  →  phase1-brief-<日期>.md
Phase 2: Requirement Analysis   →  phase2-analysis-<日期>.md
Phase 3: Draft Plan             →  phase3-draft-plan-<日期>.md
Phase 4: Challenge Review       →  phase4-challenge-review-<日期>.md
Phase 5: Solution Selection     →  phase5-solution-<日期>.md
Phase 6: Design Document        →  design-<日期>-v1.md
Phase 7: Design Review          →  phase7-design-review-<日期>.md
Phase 8: Implementation         →  phase8-tasks-<日期>.md
Phase 9: Verification           →  phase9-verification-<日期>.md
```

## 文档归档总览

所有文档统一保存至 `.claude/doc/<功能名>/`：

| 阶段 | 文件名 | 模板 | 说明 |
|------|--------|------|------|
| Phase 1 | `phase1-brief-<日期>-v<N>.md` | [phase1-brief-template.md](phase1-brief-template.md) | 需求简报 |
| Phase 2 | `phase2-analysis-<日期>-v<N>.md` | [phase2-analysis-template.md](phase2-analysis-template.md) | 需求分析 |
| Phase 3 | `phase3-draft-plan-<日期>-v<N>.md` | [phase3-draft-plan-template.md](phase3-draft-plan-template.md) | 方案草稿 |
| Phase 4 | `phase4-challenge-review-<日期>-v<N>.md` | [phase4-challenge-review-template.md](phase4-challenge-review-template.md) | 挑战审查报告 |
| Phase 5 | `phase5-solution-<日期>-v<N>.md` | [phase5-solution-template.md](phase5-solution-template.md) | 方案选型记录 |
| Phase 6 | `design-<日期>-v<N>.md` | [design-template.md](design-template.md) | 设计文档 |
| Phase 7 | `phase7-design-review-<日期>-v<N>.md` | [phase7-design-review-template.md](phase7-design-review-template.md) | 设计审查报告 |
| Phase 8 | `phase8-tasks-<日期>-v<N>.md` | [phase8-tasks-template.md](phase8-tasks-template.md) | 实现任务清单 |
| Phase 9 | `phase9-verification-<日期>-v<N>.md` | [phase9-verification-template.md](phase9-verification-template.md) | 验证报告 |

### 文档保存规程（每个 Phase 输出前必须执行）

1. **检查目录**：判断 `.claude/doc/<功能名>/` 是否存在
   - 已存在 → 直接使用，**不重新创建**
   - 不存在 → 创建目录
2. **确定版本号**：查找目标目录下同前缀同日期文件（如 `phase1-brief-<日期>-v*.md`）
   - 已有同类型文件 → 取最大版本号 +1
   - 无同类型文件 → 从 `v1` 开始
3. **保存**：`.claude/doc/<功能名>/<phase前缀>-<YYYY-MM-DD>-v<N>.md`

---

## Phase 1: Requirement Discovery

Collect essential context before any analysis. Use AskQuestion tool when available, otherwise ask conversationally.

**Mandatory questions:**

1. **Goal**: What is the core objective of this requirement?
2. **Scenario**: What user scenarios or workflows does it serve?
3. **Users**: Who are the target users/systems?
4. **Constraints**: Any technical, time, or business constraints?
5. **Acceptance criteria**: How do we know it's done?
6. **Dependencies**: Related existing features, APIs, or data models?

**Output**: 保存需求简报至 `.claude/doc/<功能名>/phase1-brief-<日期>.md`，参见 [phase1-brief-template.md](phase1-brief-template.md)。

**⛔ 用户授权门控**：展示简报摘要，等待用户授权后方可进入 Phase 2。

---

## Phase 2: Requirement Analysis

Based on the discovery output:

1. Restate the requirement in your own words
2. Identify ambiguities, missing details, edge cases
3. Ask 3-5 targeted clarifying questions (use AskQuestion if available)
4. Map the requirement to existing codebase architecture (read existing module structure and key files)
5. Identify affected modules, entities, APIs

**Output**: 保存需求分析至 `.claude/doc/<功能名>/phase2-analysis-<日期>.md`，参见 [phase2-analysis-template.md](phase2-analysis-template.md)。

**⛔ 用户授权门控**：展示分析摘要，等待用户授权后方可进入 Phase 3。

---

## Phase 3: Draft Plan

Create an initial implementation plan:

1. Break the requirement into logical work items
2. For each item, outline: scope, approach, affected files/modules
3. Estimate complexity (Low / Medium / High)
4. Identify risks and unknowns
5. Present the draft plan to the user

**Output**: 保存方案草稿至 `.claude/doc/<功能名>/phase3-draft-plan-<日期>.md`，参见 [phase3-draft-plan-template.md](phase3-draft-plan-template.md)。

**⛔ 用户授权门控**：展示工作项清单，等待用户授权后方可进入 Phase 4。

---

## Phase 4: Challenge Review

派发 `agents/challenge-reviewer.md` 子 Agent 对方案草稿进行压力测试。

**Agent 输入**：Phase 3 方案草稿文档路径 + 项目上下文  
**Agent 职责**（详见 `agents/challenge-reviewer.md`）：
1. **完整性** — 方案是否覆盖所有验收标准？
2. **可行性** — 是否存在技术障碍或不切实际的假设？
3. **一致性** — 是否与现有架构和模式一致？
4. **边界场景** — 哪些边界条件缺失？
5. **替代方案** — 是否存在更简单或健壮的实现方式？

**收到 Agent 结果后，向用户展示**：审查发现 + 2-3 个备选方案对比 + 推荐意见。

**Output**: 保存挑战审查报告至 `.claude/doc/<功能名>/phase4-challenge-review-<日期>.md`，参见 [phase4-challenge-review-template.md](phase4-challenge-review-template.md)。含用户选择结果。

**⛔ 用户授权门控**：展示备选方案对比，等待用户选定方案并授权后方可进入 Phase 5。

---

## Phase 5: Solution Selection

Based on user's choice:

1. 将用户选定的方案与 Phase 4 审查反馈融合，细化方案细节
2. 再次派发 `agents/challenge-reviewer.md` 子 Agent 验证最终方案：
   - 选定方案的可行性
   - 边界条件和错误处理策略
   - API 契约和数据模型影响
   - 性能和安全考量
3. 向用户展示最终验证结果
4. 若发现问题，迭代直至解决

**Output**: 保存方案选型记录至 `.claude/doc/<功能名>/phase5-solution-<日期>.md`，参见 [phase5-solution-template.md](phase5-solution-template.md)。记录选型理由、迭代过程和最终确认。

**⛔ 用户授权门控**：展示可行性验证结论，等待用户授权后方可进入 Phase 6。

---

## Phase 6: Generate Design Document

Create the design document at `.claude/doc/<功能名>/design-<日期>-v1.md`.

Read the template from [design-template.md](design-template.md) for the full structure.

**Key sections:**

1. Overview & objectives
2. Requirement summary (from Phase 1-2)
3. Technical design (architecture, data model, API contracts)
4. Implementation plan (from Phase 3, refined)
5. Risk mitigation
6. Test strategy

**Output**: `.claude/doc/<功能名>/design-<日期>-v1.md`，参见 [design-template.md](design-template.md)。

**⛔ 用户授权门控**：展示设计文档摘要（概述、API、数据模型），等待用户授权后方可进入 Phase 7。

---

## Phase 7: Design Review

派发 `agents/design-reviewer.md` 子 Agent 对设计文档进行完整性审查。

**Agent 输入**：Phase 6 设计文档路径  
**Agent 职责**（详见 `agents/design-reviewer.md`）：完整性、技术准确性、架构一致性、实现可行性

**Review loop:**

1. Agent 发现问题 → 修复设计文档 → 重新派发 Agent 审查（最多 3 轮）
2. 审查通过 → 向用户展示设计文档摘要并请求最终授权

**Output**: 保存设计审查报告至 `.claude/doc/<功能名>/phase7-design-review-<日期>.md`，参见 [phase7-design-review-template.md](phase7-design-review-template.md)。记录每轮审查结果和修复记录。

**⛔ 用户授权门控**：展示审查结论，等待用户最终授权设计文档后方可进入 Phase 8。

---

## Phase 8: Implementation

After user approves the design:

1. 生成任务清单并保存至 `.claude/doc/<功能名>/phase8-tasks-<日期>.md`，参见 [phase8-tasks-template.md](phase8-tasks-template.md)
2. Ask user: "Ready to proceed with implementation?"
3. On confirmation, implement each work item:
   - Follow the project's coding standards (read existing code patterns if no standards file exists)
   - Follow the project's architecture (read existing module structure)
   - 每完成一项任务，更新 `phase8-tasks-<日期>.md` 中对应任务状态为 ✅
4. After all items complete, run a self-review:
   - Check linter errors via Bash (run the project's lint command) or mcp__ide__getDiagnostics
   - Verify code against design document requirements
   - Validate all acceptance criteria are met

**Output**: `.claude/doc/<功能名>/phase8-tasks-<日期>.md`，记录任务完成状态和主要变更文件。

**⛔ 用户授权门控**：展示任务清单，等待用户确认任务范围正确后方可开始编码。

---

## Phase 9: Verification

Final verification before declaring completion:

1. **代码审查**：派发 `agents/code-reviewer.md` 子 Agent 对所有变更文件执行审查
2. **需求回归**：逐一核对 PRD 验收标准与实现的对应关系
3. **规范合规**：确认代码符合项目编码规范和架构模式
4. 向用户展示验证报告

**Output**: 保存验证报告至 `.claude/doc/<功能名>/phase9-verification-<日期>.md`，参见 [phase9-verification-template.md](phase9-verification-template.md)。

**⛔ 用户授权门控**：展示验证报告，等待用户最终授权后方宣告流程完成。

---

## Phase Transition Rules

- **Never skip phases** — each phase builds on the previous
- **Save document before advancing** — each phase's output must be saved before moving to next phase
- **User gate at every phase** — 每个阶段文档生成后，必须获得用户明确授权（"同意" / "OK" / "继续"）才能进入下一阶段
- **Review loops** are mandatory in Phase 4, 5, and 7 — at least one review cycle each
- **Document everything** — all decisions, alternatives considered, and rationale must be traceable

---

## 用户授权门控规则（User Gate）

### 标准授权流程

每个阶段完成后，执行以下固定步骤：

```
1. 保存文档到指定路径
2. 向用户展示文档摘要（核心内容，不超过 10 行）
3. 提示用户：
   「📋 [Phase N] 文档已生成：<文件路径>
    请审阅后回复：
    ✅ 同意 / OK / 继续 → 进入下一阶段
    ✏️  [修改建议]       → 触发变更分析流程」
4. 等待用户明确授权，禁止自动推进
```

### 变更处理流程（Change Request）

当用户提出修改建议时：

**Step 1：影响分析**

```
分析用户反馈，确认变更影响范围：
- 变更内容是否仅影响当前阶段？→ 仅修改当前文档
- 变更是否涉及上游阶段的决策？→ 确定需要回退的最早阶段
```

影响范围判断表：

| 变更类型 | 最早回退至 |
|---------|----------|
| 措辞/格式调整 | 当前阶段 |
| 验收标准变化 | Phase 1 |
| 需求范围调整 | Phase 1-2 |
| 架构/模块变更 | Phase 2-3 |
| 方案选型变更 | Phase 3-5 |
| API/数据模型变更 | Phase 5-6 |
| 设计文档调整 | Phase 6-7 |
| 任务拆解调整 | Phase 8 |

**Step 2：告知用户回退计划**

```
「⚠️  变更影响分析：
 您的修改建议影响到 Phase X（<阶段名>）的决策。
 需要回退并重新执行：Phase X → Phase Y → ... → 当前阶段。

 受影响文档：
 - phase-X-xxx.md（将更新）
 - phase-Y-xxx.md（将重新生成）

 是否确认按此方案回退？
 ✅ 确认回退 / ❌ 取消（仅修改当前文档）」
```

**Step 3：执行回退**

1. 从最早受影响的阶段重新执行
2. 更新所有受影响阶段的文档（旧文档用版本号保留，如 `phase3-draft-plan-<日期>-v2.md`）
3. 每个重做的阶段仍需经过用户授权门控
4. 回到触发变更的阶段，重新生成文档并等待用户授权

**Step 4：循环确认**

```
修改后重新展示文档摘要 → 等待用户授权
→ 用户再次提出修改 → 重复 Step 1-4
→ 用户授权通过 → 继续下一阶段
```

### 授权状态记录

在每份阶段文档末尾追加授权记录：

```markdown
## 授权记录

| 版本 | 日期 | 状态 | 用户反馈 |
|------|------|------|---------|
| v1 | YYYY-MM-DD | ❌ 需修改 | [用户原话] |
| v2 | YYYY-MM-DD | ✅ 已授权 | OK |
```

---

## Additional Resources

- For detailed workflow guidance per phase, see [workflow-detail.md](workflow-detail.md)
