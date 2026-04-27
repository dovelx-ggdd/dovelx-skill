# 示例输出：Bug 诊断报告

---

## 信息收集

**已知事实：**
- 后端 API 返回 200，数据库已更新
- 前端界面不更新，刷新后正常
- `handleComplete` 函数调用了 PATCH 接口

**缺失信息（提问用户确认）：**
1. 任务列表数据如何获取？（SWR / React Query / useState 本地状态？）
2. `handleComplete` 调用后有没有触发数据重新获取？

---

## 根因分析

**假设：** `handleComplete` 完成 API 调用后，**没有通知前端状态层刷新数据**，界面仍显示旧状态。

**验证：** 代码中 `await fetch(...)` 后没有任何触发 re-render 的逻辑，假设成立。

---

## 修复方案

### 方案一：SWR（推荐）

```typescript
import useSWR from 'swr'

// 在列表组件中
const { data: tasks, mutate } = useSWR('/api/tasks', fetcher)

// 在 TaskCard 中
const handleComplete = async (taskId: string) => {
  await fetch(`/api/tasks/${taskId}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ status: 2 }),
  })
  // 通知 SWR 重新获取数据
  mutate()
}
```

### 方案二：乐观更新（更流畅的用户体验）

```typescript
const handleComplete = async (taskId: string) => {
  // 先乐观地更新本地状态
  mutate(
    tasks?.map(t => t.id === taskId ? { ...t, status: 2 } : t),
    false  // 不立即重新验证
  )

  try {
    await fetch(`/api/tasks/${taskId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: 2 }),
    })
    mutate()  // 成功后同步服务端数据
  } catch {
    mutate()  // 失败时回滚
  }
}
```

---

## 附带发现

`fetch` 调用缺少 `Content-Type: application/json` 请求头，部分服务器可能无法正确解析 body，建议同步修复。

---

## 验证步骤

1. 应用修复
2. 点击「标记完成」
3. 确认界面立即更新，无需刷新
4. 刷新后确认状态持久化正常
