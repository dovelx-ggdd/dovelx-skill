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

- Git
- 调试 **Claude Code**：需安装 [Claude Code](https://claude.ai/code) CLI
- 调试 **Cursor**：需安装 [Cursor](https://cursor.com)，并按官方文档加载本地插件或仓库

**本地安装插件（用于调试）：**

```bash
# 克隆仓库
git clone https://github.com/dovelx-ggdd/dovelx-skill.git
cd dovelx-skill

# Claude Code：从本地路径安装（开发模式）
/plugin install dovelx@./
```

**Cursor（本地插件目录）：** 与终端用户相同——将本仓库根目录通过**符号链接**放入 `~/.cursor/plugins/local/dovelx-skill`（Windows 可用 `mklink /J`，详见仓库 [`README.md`](README.md)「Cursor（本地插件目录）」），然后 **Reload Window**。详见 [Cursor Plugins](https://cursor.com/docs/plugins)。

清单与 Agent 路径的自动化校验：

```bash
chmod +x scripts/smoke-check-manifests.sh
bash scripts/smoke-check-manifests.sh
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

`.claude-plugin/plugin.json` 与 `.cursor-plugin/plugin.json` 均已配置扫描 `./skills/`；新增技能目录后通常无需改清单（若在 Cursor / Claude 中未被拾取，再核对清单路径）。

---

## 修改已有技能

- **保持向后兼容**：不要删除已有字段，只新增或完善
- **更新示例**：若行为变更，同步更新 `examples/output.md`
- **版本号**：修改技能后需同步递增 **四套** 版本字段——`.claude-plugin/plugin.json`、`.claude-plugin/marketplace.json` 的 `metadata.version`、`.cursor-plugin/plugin.json`、`.cursor-plugin/marketplace.json` 的 `metadata.version`（须保持一致）
- **CHANGELOG**：在 `CHANGELOG.md` 中记录变更内容

---

## 调试技能

**Claude Code：**

```bash
# 重新加载插件（修改后需要）
/plugin reload dovelx

# 直接调用技能测试
/dovelx-<skill-name>

# 查看已注册技能列表
/plugin list
```

**Cursor：** 在 Agent 输入 **`/`**，搜索 `dovelx-<skill-name>`（与 `SKILL.md` 中 `name` 一致）；修改插件内容后按 Cursor 文档重新加载插件。建议在装载插件后确认编排技能所依赖的子 Agent 是否按预期出现（`agents/*.md` 中若有 Claude 专有 frontmatter 字段，应以 Cursor 内实测为准）。

### Cursor / 清单冒烟（推荐发 PR 前）

```bash
chmod +x scripts/smoke-check-manifests.sh
bash scripts/smoke-check-manifests.sh
bash scripts/validate-skills.sh
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

1. 同步更新以下位置的 **`version` / `metadata.version`**（须完全一致）：
   - `.claude-plugin/plugin.json`
   - `.claude-plugin/marketplace.json` → `metadata.version`
   - `.cursor-plugin/plugin.json`
   - `.cursor-plugin/marketplace.json` → `metadata.version`
2. 在 `CHANGELOG.md` 顶部添加新版本条目
3. 提交并推送到 `main` 分支
4. 创建 Git tag（与 `plugin.json` 中的版本一致，带 `v` 前缀）：

```bash
git tag v1.3.0
git push origin v1.3.0
```

5. GitHub Actions 会自动创建 Release 并生成 Release Notes  
6. **Cursor**：用户使用 **`README.md` 中的本地插件目录**（`~/.cursor/plugins/local` + 符号链接）即可安装任意 tag / main；若要上架应用商店，再在 [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish) 提交仓库 URL（以 Cursor 官方流程为准）

---

## 行为准则

- 所有技能输出文档统一使用**中文**
- 保持技能描述（`description`）的精准性——Claude 依赖它来决定是否激活
- 示例要真实，不要用占位符
