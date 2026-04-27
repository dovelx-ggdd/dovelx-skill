# 示例输入

用户描述：

> 我的任务列表页面有个 bug，点击「标记完成」按钮后，任务状态在界面上没有变化，需要刷新页面才能看到更新。
> 后端 API 是正常的（直接调用 API 返回 200），但前端没有更新。
>
> 相关代码：
> ```typescript
> // TaskCard.tsx
> const handleComplete = async (taskId: string) => {
>   await fetch(`/api/tasks/${taskId}`, {
>     method: 'PATCH',
>     body: JSON.stringify({ status: 2 }),
>   })
> }
> ```
