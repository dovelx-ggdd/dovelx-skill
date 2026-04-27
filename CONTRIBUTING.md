# 贡献指南

感谢你对 `dovelx-skill` 的关注！本文档说明如何参与贡献。

---

## 目录

- [开发环境](#开发环境)
- [新增技能](#新增技能)
- [修改已有技能](#修改已有技能)
- [调试技能](#调试技能)
- [提交规范](#提交规范)
- [发版流程](#发版流程)

---

## 开发环境

**前置要求：**

- [Claude Code](https://claude.ai/code) CLI 已安装
- Git

**本地安装插件（用于调试）：**

```bash
# 克隆仓库
git clone https://github.com/WangZhenLx/dovelx-skill.git
cd dovelx-skill

# 从本地路径安装（开发模式）
/plugin install dovelx@./
```

---

## 新增技能

### 1. 创建目录和 SKILL.md

```bash
mkdir skills/<skill-name>
touch skills/<skill-name>/SKILL.md
```

### 2. SKILL.md 必填字段

```markdown
---
name: dovelx-<skill-name>
description: <一句话描述，用于 skill 发现和匹配>
origin: dovelx
---

# 技能标题

## 角色定位
...

## 何时激活
...

## 工作流
...

## 输出文档
...
```

**字段说明：**

| 字段 | 要求 |
|------|------|
| `name` | 必须以 `dovelx-` 开头 |
| `description` | 清晰描述触发场景，Claude 依据此字段匹配技能 |
| `origin` | 固定填 `dovelx` |

### 3. 添加示例

```bash
mkdir skills/<skill-name>/examples
touch skills/<skill-name>/examples/input.md
touch skills/<skill-name>/examples/output.md
```

- `input.md`：真实的用户输入示例
- `output.md`：期望的技能输出结果（中文）

### 4. 验证

```bash
bash scripts/validate-skills.sh
```

确保无错误后再提交 PR。

### 5. 无需注册

`plugin.json` 已配置自动扫描 `skills/` 目录，新增目录后无需手动注册。

---

## 修改已有技能

- **保持向后兼容**：不要删除已有字段，只新增或完善
- **更新示例**：若行为变更，同步更新 `examples/output.md`
- **版本号**：修改技能后需在 `plugin.json` 和 `marketplace.json` 中递增版本号
- **CHANGELOG**：在 `CHANGELOG.md` 中记录变更内容

---

## 调试技能

```bash
# 重新加载插件（修改后需要）
/plugin reload dovelx

# 直接调用技能测试
/dovelx-<skill-name>

# 查看已注册技能列表
/plugin list
```

---

## 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/) 格式：

```
<type>: <description>
```

| type | 适用场景 |
|------|----------|
| `feat` | 新增技能或新功能 |
| `fix` | 修复技能逻辑错误 |
| `docs` | 仅文档变更 |
| `refactor` | 重构技能内容（不影响行为） |
| `chore` | 版本号更新、CI 配置等 |

**示例：**

```
feat: add restruct-reviewer skill for refactoring code review
fix: update requirements skill doc filename from design to prd
docs: add examples for all skills
```

---

## 发版流程

1. 更新 `plugin.json` 和 `marketplace.json` 中的 `version` 字段
2. 在 `CHANGELOG.md` 顶部添加新版本条目
3. 提交并推送到 `main` 分支
4. 创建 Git tag：

```bash
git tag v1.0.7
git push origin v1.0.7
```

5. GitHub Actions 会自动创建 Release 并生成 Release Notes

---

## 行为准则

- 所有技能输出文档统一使用**中文**
- 保持技能描述（`description`）的精准性——Claude 依赖它来决定是否激活
- 示例要真实，不要用占位符
