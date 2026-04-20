# 示例：电商后端项目 Feature 发现结果

## 项目信息

- **项目名称**: ecommerce-backend
- **项目类型**: Python / FastAPI
- **检测依据**: `pyproject.toml` + `uvicorn` + `fastapi` 依赖
- **源码根目录**: `src/`

## 发现的功能模块

| # | 模块名 | 负责范围 | 核心路径 | 置信度 | 状态 |
|---|--------|---------|---------|--------|------|
| 1 | auth | 用户认证、JWT、OAuth 登录 | `src/auth/` | 高 | 新建 |
| 2 | catalog | 商品目录 CRUD、分类管理 | `src/catalog/`, `src/products/` | 高 | 新建 |
| 3 | cart | 购物车管理、库存校验 | `src/cart/` | 高 | 新建 |
| 4 | payment | 支付处理、Stripe 集成 | `src/payment/` | 高 | 新建 |
| 5 | order | 订单生命周期管理 | `src/order/` | 高 | 新建 |
| 6 | notification | Email/SMS 通知发送 | `src/notification/` | 中 | 新建 |
| 7 | search | 全文搜索、Elasticsearch | `src/search/` | 中 | 新建 |
| 8 | user-profile | 用户信息、偏好设置 | `src/users/` | 中 | 新建 |

## 排除的目录

| 目录 | 排除原因 |
|------|---------|
| `src/common/` | 共享工具函数，非独立功能模块 |
| `src/core/` | FastAPI 框架配置、中间件 |
| `src/config/` | 环境配置 |
| `migrations/` | Alembic 数据库迁移 |
| `tests/` | 测试文件（映射回各 feature） |

## 生成后的 .features/ 结构预览

```
.features/
├── auth/
│   ├── MEMORY.md
│   ├── decisions/
│   │   └── 2024-01-jwt-vs-session.md
│   ├── changelog/
│   └── docs/
├── catalog/
│   ├── MEMORY.md
│   ├── decisions/
│   ├── changelog/
│   └── docs/
├── cart/
│   ├── MEMORY.md
│   ├── decisions/
│   ├── changelog/
│   └── docs/
├── payment/
│   ├── MEMORY.md
│   ├── decisions/
│   ├── changelog/
│   └── docs/
├── order/
│   ├── MEMORY.md
│   ├── decisions/
│   ├── changelog/
│   └── docs/
├── notification/
│   ├── MEMORY.md
│   ├── decisions/
│   ├── changelog/
│   └── docs/
├── search/
│   ├── MEMORY.md
│   ├── decisions/
│   ├── changelog/
│   └── docs/
└── user-profile/
    ├── MEMORY.md
    ├── decisions/
    ├── changelog/
    └── docs/
```

## 生成的 MEMORY.md 示例（auth 模块）

```markdown
# Auth

> 负责范围：用户认证、登录、Token 管理、权限验证
> 最后更新：2024-12-01

## 当前状态

基于 JWT + HttpOnly Cookie 的认证系统。支持邮箱密码登录和 Google OAuth。
Refresh Token 使用 Redis 存储，采用滑动窗口刷新机制。

## 核心文件

src/auth/
├── router.py        # 认证相关 API endpoints
├── service.py       # 认证业务逻辑（登录、注册、Token 刷新）
├── models.py        # User model、Token schemas
├── dependencies.py  # FastAPI 依赖注入（get_current_user）
└── utils.py         # JWT 编解码、密码哈希

## 依赖关系

- **依赖**：database（用户存储）、redis（Token 管理）、email-service（验证邮件）
- **被依赖**：几乎所有需要认证的模块通过 dependencies.py

## 最近重要事项

- 2024-12-01: 初始化 Feature Memory（由 feature-memory-init 批量生成）

## Gotchas（开发必读）

⚠️ 以下是开发此 feature 时必须注意的事项：

- `dependencies.py` 中的 `get_current_user` 被大量模块依赖，修改签名需全局排查
- 测试环境 Token 过期时间为 5 分钟，生产环境为 24 小时
- OAuth 回调 URL 在 Google Console 和 .env 中都需要配置

## 调试入口

**登录失败排查**
1. 检查 `service.py:authenticate_user()` 的密码验证逻辑
2. 检查 Redis 连接是否正常（Token 存储依赖 Redis）

**Token 刷新失败**
1. 检查 `service.py:refresh_token()` 的 Redis 锁状态
2. 确认 Refresh Token 未过期

## 索引

- 设计决策：`decisions/`
- 变更历史：`changelog/`
- 相关文档：`docs/`
```

## 汇总报告示例

```markdown
## Feature Memory Init -- 完成报告

> 项目: ecommerce-backend
> 生成时间: 2024-12-01
> 功能模块数: 8

| 模块 | 状态 | MEMORY.md | 决策记录 | 备注 |
|------|------|-----------|----------|------|
| auth | ✅ 已生成 | 已填充 | 1 条 | JWT vs Session 决策 |
| catalog | ✅ 已生成 | 已填充 | 0 条 | |
| cart | ✅ 已生成 | 已填充 | 0 条 | |
| payment | ✅ 已生成 | 已填充 | 1 条 | Stripe vs 自建 |
| order | ✅ 已生成 | 已填充 | 0 条 | |
| notification | ✅ 已生成 | 已填充 | 0 条 | |
| search | ✅ 已生成 | 已填充 | 1 条 | ES vs 数据库全文 |
| user-profile | ✅ 已生成 | 已填充 | 0 条 | |

### 后续建议
- 审阅每个 MEMORY.md，补充 AI 无法从代码推断的业务上下文
- 特别关注 Gotchas 部分，补充团队口口相传的"坑"
- 在日常开发中使用 feature-memory 技能持续更新
```
