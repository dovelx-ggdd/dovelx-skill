# 示例输出：技术设计文档

**文档路径：** `.claude/doc/task-management/design-2026-04-13-v2.md`

---

# 任务管理功能 技术设计文档

**版本：** v1.0
**日期：** 2026-04-13

---

## 一、架构设计

### 技术栈
- **前端：** Next.js 14 (App Router) + TypeScript + Tailwind CSS
- **拖拽：** @dnd-kit/core
- **后端：** Next.js API Routes
- **数据库：** PostgreSQL 15
- **ORM：** Prisma

### 模块划分

```
src/
├── app/
│   ├── (auth)/          # 认证相关页面
│   └── board/           # 看板页面
├── components/
│   ├── board/           # 看板组件（列、卡片、拖拽）
│   └── task/            # 任务表单、详情
├── lib/
│   ├── db.ts            # Prisma 客户端
│   └── auth.ts          # 认证工具
└── app/api/
    └── tasks/           # 任务 API 路由
```

---

## 二、数据库 Schema

```sql
-- 任务表
CREATE TABLE tasks (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title       VARCHAR(100) NOT NULL,
  description TEXT,
  priority    SMALLINT NOT NULL DEFAULT 2,  -- 1=高, 2=中, 3=低
  status      SMALLINT NOT NULL DEFAULT 0,  -- 0=待办, 1=进行中, 2=已完成
  due_date    DATE,
  completed_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tasks_user_status ON tasks(user_id, status);
CREATE INDEX idx_tasks_due_date ON tasks(user_id, due_date) WHERE due_date IS NOT NULL;
```

---

## 三、API 设计

### 获取任务列表
```
GET /api/tasks?status=0&priority=1
```
响应：
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "完成技术设计文档",
      "priority": 1,
      "status": 0,
      "dueDate": "2026-04-15",
      "createdAt": "2026-04-13T10:00:00Z"
    }
  ],
  "meta": { "total": 42 }
}
```

### 创建任务
```
POST /api/tasks
Body: { title, description?, priority?, dueDate? }
```

### 更新任务
```
PATCH /api/tasks/:id
Body: { title?, status?, priority?, dueDate? }
```

### 删除任务
```
DELETE /api/tasks/:id
```

---

## 四、关键技术决策

| 决策 | 选择 | 原因 |
|------|------|------|
| 拖拽库 | @dnd-kit | 轻量、无障碍支持好，react-beautiful-dnd 已停更 |
| 状态管理 | React Server Components + SWR | 看板数据读多写少，SWR 缓存效果好 |
| 任务 ID | UUID | 防止 ID 枚举攻击，安全性更高 |
| 软删除 | 不采用 | 任务管理场景无需审计，直接删除简化逻辑 |

---

## 五、技术风险

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|----------|
| 拖拽在移动端体验差 | 中 | 低 | 本期仅支持桌面端，移动端后续迭代 |
| 500 条任务时看板渲染性能 | 低 | 中 | 虚拟列表 + 状态分页加载 |
