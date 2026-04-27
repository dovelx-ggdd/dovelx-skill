# 示例输入

以下是任务列表查询函数的重构，请审查重构质量。

**重构前：**
```typescript
async function getTasks(userId: string, status?: number, priority?: number) {
  let sql = `SELECT * FROM tasks WHERE user_id = '${userId}'`
  if (status !== undefined) sql += ` AND status = ${status}`
  if (priority !== undefined) sql += ` AND priority = ${priority}`
  sql += ' ORDER BY created_at DESC'
  const result = await db.query(sql)
  return result.rows
}
```

**重构后：**
```typescript
interface TaskFilter {
  status?: number
  priority?: number
}

async function getTasks(userId: string, filter: TaskFilter = {}) {
  const conditions: string[] = ['user_id = $1']
  const params: unknown[] = [userId]

  if (filter.status !== undefined) {
    params.push(filter.status)
    conditions.push(`status = $${params.length}`)
  }

  if (filter.priority !== undefined) {
    params.push(filter.priority)
    conditions.push(`priority = $${params.length}`)
  }

  const sql = `SELECT * FROM tasks WHERE ${conditions.join(' AND ')} ORDER BY created_at DESC`
  const result = await db.query(sql, params)
  return result.rows
}
```
