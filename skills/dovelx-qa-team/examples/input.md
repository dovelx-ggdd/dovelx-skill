请对以下接口进行全面测试：

- `POST /api/points/award` — 发放积分（需 Bearer Token）
- `GET  /api/points/balance?user_id=` — 查询余额
- `POST /api/points/redeem` — 积分兑换礼品

测试环境：https://staging.example.com
认证：Bearer Token
