## 技术方案

### 架构设计

```
TaskService ──→ PointAwardService ──→ PointRepository (PostgreSQL)
                PointRedeemService ──→ GiftInventoryService
                PointQueryService
```

### 数据库 Schema

```sql
CREATE TABLE point_accounts (
  user_id    BIGINT PRIMARY KEY,
  balance    INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE point_logs (
  id          BIGSERIAL PRIMARY KEY,
  user_id     BIGINT NOT NULL,
  delta       INT NOT NULL,
  source_type VARCHAR(32) NOT NULL,
  source_id   VARCHAR(64) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (source_type, source_id)
);
```

### API 契约

`POST /api/points/award` → `{ user_id, task_id, points }`
`POST /api/points/redeem` → `{ user_id, gift_id, idempotency_key }`
`GET  /api/points/balance?user_id=`

### 技术决策

- 幂等性：`point_logs(source_type, source_id)` 唯一约束，数据库层保证
- 并发安全：行锁 + 余额校验原子执行 `UPDATE ... WHERE balance >= ?`
