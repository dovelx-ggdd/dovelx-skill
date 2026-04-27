# 示例输入

请审查以下任务创建 API 的实现代码：

```typescript
// app/api/tasks/route.ts
import { db } from '@/lib/db'

export async function POST(req: Request) {
  const body = await req.json()

  const task = await db.query(
    `INSERT INTO tasks (user_id, title, priority, due_date)
     VALUES ('${body.userId}', '${body.title}', ${body.priority}, '${body.dueDate}')
     RETURNING *`
  )

  return Response.json(task.rows[0])
}
```
