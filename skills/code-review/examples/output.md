# 示例输出：代码审查报告

**文档路径：** `.claude/doc/task-management/code-review-2026-04-13-v1.md`

---

# 代码审查报告

**审查对象：** `app/api/tasks/route.ts` — 任务创建 API
**审查日期：** 2026-04-13
**结论：** ⛔ 阻止合并（发现 CRITICAL 级安全漏洞）

---

## 问题清单

### [CRITICAL] SQL 注入漏洞

**位置：** 第 6-9 行

**问题：** 使用字符串拼接构造 SQL 查询，所有参数直接插入 SQL 语句，存在严重的 SQL 注入风险。攻击者可通过构造恶意 `title` 字段（如 `'; DROP TABLE tasks;--`）破坏数据库。

**修复方案：**
```typescript
// 使用参数化查询
const task = await db.query(
  `INSERT INTO tasks (user_id, title, priority, due_date)
   VALUES ($1, $2, $3, $4)
   RETURNING *`,
  [body.userId, body.title, body.priority, body.dueDate]
)
```

---

### [HIGH] 缺少身份认证

**位置：** 整个函数

**问题：** API 未验证调用方身份，任何人都可以以任意 `userId` 创建任务，导致越权写入。

**修复方案：**
```typescript
import { getServerSession } from 'next-auth'
import { authOptions } from '@/lib/auth'

export async function POST(req: Request) {
  const session = await getServerSession(authOptions)
  if (!session?.user?.id) {
    return Response.json({ error: '未授权' }, { status: 401 })
  }
  // 使用 session.user.id 而非 body.userId
}
```

---

### [HIGH] 无输入验证

**位置：** 第 4 行

**问题：** `body` 未经验证直接使用，缺少必填字段校验和类型校验。`title` 为空或超长、`priority` 为非法值时数据库会报错，未返回用户友好的错误信息。

**修复方案：** 使用 Zod 进行 Schema 验证：
```typescript
import { z } from 'zod'

const CreateTaskSchema = z.object({
  title: z.string().min(1).max(100),
  priority: z.enum(['1', '2', '3']).optional().default('2'),
  dueDate: z.string().date().optional(),
})
```

---

### [MEDIUM] 错误未处理

**位置：** 整个函数

**问题：** 数据库操作无 try/catch，异常时直接抛出 500 错误且暴露数据库内部信息。

**修复方案：** 包裹 try/catch，返回统一错误格式。

---

## 总结

| 级别 | 数量 |
|------|------|
| CRITICAL | 1 |
| HIGH | 2 |
| MEDIUM | 1 |
| LOW | 0 |

必须修复 CRITICAL 和 HIGH 问题后方可合并。
