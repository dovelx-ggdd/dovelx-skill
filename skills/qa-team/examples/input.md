# 示例输入

请对以下 API 进行全维度测试：

- POST /api/auth/register（注册，无需认证）
- POST /api/auth/login（登录，返回 JWT Token）
- GET /api/users/me（获取当前用户，需要 Bearer Token）
- PUT /api/users/me/profile（更新资料，需要 Bearer Token）

基础 URL：http://localhost:3000
认证方式：Bearer Token（登录后获取）
有前端页面：登录页 http://localhost:3000/login，个人资料页 http://localhost:3000/profile
