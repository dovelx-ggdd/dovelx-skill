# 示例输出：开发团队编排流程

---

## 编排启动

已识别需求：**用户登录功能**
启动四阶段流水线：

```
需求分析  →  技术设计  →  开发实现  →  代码审查
```

---

## 阶段一：需求分析（dovelx-requirements）

**澄清问题：**
1. 是否需要「记住我」（7天免登录）？
2. 密码错误几次后锁定账号？
3. 是否需要「忘记密码」功能？
4. 登录失败是否需要区分「邮箱不存在」和「密码错误」？（安全建议：统一提示）

**假设用户确认后，输出 PRD 至：**
`.claude/doc/auth/prd-2026-04-13-v1.md`

---

## 阶段二：技术设计（dovelx-tech-design）

**关键设计决策：**
- 认证方案：NextAuth.js Credentials Provider
- 密码存储：bcrypt（salt rounds=12）
- Session：JWT，有效期 24h
- 安全措施：登录失败 5 次锁定 15 分钟

**输出技术设计文档至：**
`.claude/doc/auth/design-2026-04-13-v2.md`

**等待用户确认后进入开发阶段...**

---

## 阶段三：开发实现

正在实现以下文件：
- `app/(auth)/login/page.tsx` — 登录页面
- `app/api/auth/[...nextauth]/route.ts` — NextAuth 配置
- `lib/auth.ts` — 认证工具函数
- `lib/db/users.ts` — 用户数据访问层

**实现完成，触发代码审查...**

---

## 阶段四：代码审查（dovelx-code-review）

**审查结论：** 有条件通过（2 个 HIGH 问题需修复）

**发现问题：**
1. [HIGH] 登录失败提示区分了「邮箱不存在」和「密码错误」，存在用户枚举风险
2. [HIGH] 缺少 CSRF 保护配置

**已修复上述问题，最终审查通过。**

**审查报告保存至：**
`.claude/doc/auth/code-review-2026-04-13-v1.md`

---

## 流水线完成

登录功能全流程开发完毕，所有阶段文档已归档至 `.claude/doc/auth/`。
