积分兑换接口出现 Bug：并发调用兑换接口时，偶发积分被重复扣减，但礼品只发了一份。

错误日志：
```
[WARN] Points deducted twice for user_id=1042, order_id=REQ-889
```

技术栈：Python + PostgreSQL
