请审查以下积分发放服务代码：

```python
class PointService:
    def award_points(self, user_id, task_id, points):
        user = db.query(f"SELECT * FROM users WHERE id = {user_id}")
        if not user:
            return False
        db.execute(f"UPDATE users SET points = points + {points} WHERE id = {user_id}")
        db.execute(f"INSERT INTO point_logs VALUES ({user_id}, {task_id}, {points}, NOW())")
        return True
```
