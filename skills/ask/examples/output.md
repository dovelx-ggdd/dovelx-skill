# 示例输出：dovelx-ask 会话

---

## 会话启动

```
💬 dovelx-ask 已启动

已发现以下可搜索来源：
  📄 文档     — 12 个文件（docs/, *.md 等）
  🧠 知识库   — 5 个文件（.claude/doc/ 等）
  💻 代码库   — 87 个文件（src/, lib/ 等）
  🗄️  结构化数据 — 8 个文件（*.json, *schema* 等）

直接输入问题开始查询。
特殊命令：!sources（查看来源）、!add <路径>（添加来源）、!clear（清空上下文）
输入 exit 或 退出 结束会话。
```

---

## 第 1 轮：用户认证实现

**用户：** 项目里用户认证是怎么实现的？支持哪些登录方式？

**回答**

项目使用 **NextAuth.js** 实现用户认证，支持以下三种登录方式：
1. **邮箱 + 密码**（Credentials Provider）
2. **GitHub OAuth**
3. **Google OAuth**

认证配置集中在 `src/lib/auth.ts`，会话使用 JWT 策略管理，Token 存储在 HTTP-only Cookie 中。

**置信度**：高

**来源引用**
- 💻 `src/lib/auth.ts:12-45` — NextAuth 配置，定义了三个 Provider 及 JWT 回调
- 📄 `docs/authentication.md:8-32` — 认证方案说明文档，描述了登录流程
- 💻 `src/app/api/auth/[...nextauth]/route.ts:1-8` — NextAuth API 路由入口

**可继续追问**
- JWT token 的过期时间是多少？可以在哪里配置？
- GitHub OAuth 的 ClientID 和 Secret 在哪里设置？
- 如何限制某些页面只有登录用户才能访问？

---

## 第 2 轮：JWT 配置（追问）

**用户：** JWT token 的过期时间是多少？可以在哪里配置？

**回答**

当前 JWT token **过期时间为 7 天**（`maxAge: 60 * 60 * 24 * 7`）。

可在以下位置修改：

```typescript
// src/lib/auth.ts, 第 38 行
export const authOptions: NextAuthOptions = {
  session: {
    strategy: "jwt",
    maxAge: 60 * 60 * 24 * 7, // 7 天，单位：秒
  },
  // ...
}
```

也可通过环境变量 `NEXTAUTH_SESSION_MAX_AGE` 覆盖（单位秒），需在 `.env` 或部署平台配置。

**置信度**：高

**来源引用**
- 💻 `src/lib/auth.ts:36-42` — session 配置块，含 maxAge 定义
- 📄 `docs/authentication.md:45` — 说明了可用环境变量列表

**可继续追问**
- 用户登出时如何使 token 失效？
- 如何实现"记住我"功能（延长 token 有效期）？

---

## 第 3 轮：数据库用户表

**用户：** 数据库里有用户表吗？有哪些字段？

**回答**

数据库中有 `users` 表，共 8 个字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | `uuid` | 主键，自动生成 |
| `email` | `varchar(255)` | 唯一，用于登录 |
| `name` | `varchar(100)` | 显示名称，可为空 |
| `password_hash` | `text` | bcrypt 加密密码，OAuth 用户为空 |
| `provider` | `varchar(50)` | 登录方式：credentials/github/google |
| `provider_id` | `varchar(255)` | OAuth 来源 ID，可为空 |
| `created_at` | `timestamp` | 创建时间 |
| `updated_at` | `timestamp` | 最后更新时间 |

**置信度**：高

**来源引用**
- 🗄️ `prisma/schema.prisma:24-45` — User model 完整定义
- 🗄️ `migrations/001_create_users.sql:1-28` — 建表语句，含索引定义

**可继续追问**
- users 表和 sessions 表是什么关系？
- 如何查询某个用户的所有登录记录？
- 密码重置功能有对应的表结构吗？
