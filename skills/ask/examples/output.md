**回答**

积分兑换逻辑在 `src/services/point_redeem_service.py` 中实现，核心入口为 `PointRedeemService.redeem()`（第 42 行）。

幂等性通过数据库唯一约束保证：`redeem_orders(order_id)` 字段有 `UNIQUE` 约束（见 `migrations/0023_add_redeem_orders.sql` 第 8 行），业务层捕获 `UniqueViolation` 异常并返回已处理状态。

**来源引用**
- 💻 `src/services/point_redeem_service.py:42` — `def redeem(self, user_id, gift_id, order_id)`
- 🗄️ `migrations/0023_add_redeem_orders.sql:8` — `UNIQUE(order_id)`
- 📄 `docs/points-design.md:67` — 幂等方案设计说明

**可继续追问**
- 兑换失败时积分如何回滚？
- `order_id` 由哪一层生成？
