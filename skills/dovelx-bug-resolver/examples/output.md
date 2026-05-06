## Bug 诊断报告

### 根因

兑换流程缺少幂等保护，并发请求同时通过余额校验后均执行扣减：

```
请求 A: SELECT balance=100 → 校验通过 → UPDATE balance=50  ✅
请求 B: SELECT balance=100 → 校验通过 → UPDATE balance=50  ❌ 重复扣减
```

PostgreSQL 默认读已提交隔离级别，两个并发 SELECT 均读到旧值。

### 修复方案（推荐）

```sql
-- redeem_orders 加唯一约束
ALTER TABLE redeem_orders ADD CONSTRAINT uq_order UNIQUE (order_id);
```

```python
try:
    db.execute("INSERT INTO redeem_orders ...")
    db.execute("UPDATE point_accounts SET balance = balance - %s WHERE user_id = %s AND balance >= %s")
except UniqueViolation:
    return {"status": "already_processed"}
```

### 验证步骤

用并发测试工具向同一 `order_id` 发送 10 个并发请求，确认只有 1 次扣减成功，其余返回 `already_processed`。
