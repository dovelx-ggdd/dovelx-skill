我对积分服务做了重构，原来是一个 500 行的 PointService 类，现在拆成了：
- `PointAwardService` — 负责积分发放
- `PointRedeemService` — 负责积分兑换
- `PointQueryService` — 负责积分查询
- `PointRepository` — 数据访问层

请审查重构质量。
