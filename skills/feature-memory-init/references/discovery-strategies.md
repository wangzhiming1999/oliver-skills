# Feature Discovery Strategies

按项目类型识别功能模块边界的策略指南。

## 项目类型检测

通过配置文件判断项目类型：

| 检测文件 | 项目类型 |
|---------|---------|
| `pyproject.toml` / `setup.py` / `requirements.txt` | Python |
| `package.json` + `next.config.*` | Next.js |
| `package.json` + `vite.config.*` / `vue.config.*` | Vue/Vite |
| `package.json` + `src/App.tsx` / `src/App.jsx` | React SPA |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pom.xml` / `build.gradle` | Java/Kotlin |
| `Gemfile` + `config/routes.rb` | Ruby on Rails |
| `pnpm-workspace.yaml` / `lerna.json` / `turbo.json` | Monorepo |

当多个配置文件同时存在时，优先检测 Monorepo 标识。

---

## Python / FastAPI 项目

### 发现策略

1. 检查 `src/*/`、`app/*/`、`modules/*/` 下的子目录
2. 每个包含以下信号文件的目录视为一个 feature：
   - `router.py` / `endpoints.py` / `views.py`（路由入口）
   - `service.py` / `services.py`（业务逻辑）
   - `models.py` / `schemas.py`（数据模型）
   - `__init__.py` + 至少 2 个以上 `.py` 文件
3. 如果项目使用 FastAPI，额外检查 `APIRouter` 的注册

### 排除目录
`common/`、`utils/`、`core/`、`config/`、`middlewares/`、`migrations/`、`alembic/`、`tests/`

### 示例映射
```
app/
├── auth/          → feature: auth
├── payment/       → feature: payment
├── notification/  → feature: notification
├── common/        → 排除（基础设施）
└── core/          → 排除（框架配置）
```

---

## React / Vue / 前端 SPA 项目

### 发现策略

1. 优先检查显式 feature 目录：
   - `src/features/*/`
   - `src/modules/*/`
   - `src/domains/*/`
2. 如无显式分组，按页面/路由分析：
   - `src/pages/*/` 或 `src/views/*/`
   - 每个页面目录 + 其关联的 components、hooks、stores 视为一个 feature
3. 组件库分析：
   - `src/components/` 下按领域子目录分组
   - 通用组件（Button、Modal、Layout）排除

### 排除目录
`src/components/ui/`、`src/components/common/`、`src/lib/`、`src/utils/`、`src/hooks/`（通用）、`src/styles/`、`src/assets/`

### 关联聚合
将分散的同名模块聚合：
- `src/pages/auth/` + `src/stores/authStore.ts` + `src/hooks/useAuth.ts` → feature: auth

---

## Next.js 项目

### 发现策略

1. **App Router**（`app/` 目录）：
   - `app/(group)/*/` 下的路由组视为 feature 边界
   - 每个有 `page.tsx` + `layout.tsx` 的路由段为候选
   - API routes `app/api/*/` 与对应前端页面合并为同一 feature
2. **Pages Router**（`pages/` 目录）：
   - `pages/*/` 下的每个子目录为候选
   - `pages/api/*/` 与对应前端页面合并

### 排除
`app/layout.tsx`（根布局）、`app/globals.css`、`middleware.ts`

---

## Go 项目

### 发现策略

1. 检查 `internal/*/`：每个子目录为一个 feature
2. 检查 `pkg/*/`：共享库，通常不作为独立 feature（除非有明确领域逻辑）
3. 检查 `cmd/*/`：入口点，与 internal 下同名模块合并
4. 如项目使用 `handler/` + `service/` + `repository/` 分层：
   - 按领域名聚合同名的 handler + service + repository

### 排除
`vendor/`、`tools/`、`scripts/`、`docs/`

---

## Monorepo 项目

### 发现策略

1. 读取 workspace 配置（`pnpm-workspace.yaml`、`package.json.workspaces`、`turbo.json`）
2. 每个 workspace package 视为一个 feature：
   - `packages/*/`
   - `apps/*/`
   - `services/*/`
3. 共享包（`packages/shared/`、`packages/ui/`、`packages/config/`）标记为"基础设施"，置信度降低

---

## Ruby on Rails 项目

### 发现策略

1. 按 MVC 聚合：将 `app/models/user.rb` + `app/controllers/users_controller.rb` + `app/views/users/` 视为 feature: users
2. 检查 `app/services/*/` 或 `app/domains/*/`
3. 分析 `config/routes.rb` 中的 namespace/scope 作为 feature 边界

### 排除
`app/mailers/`（通用）、`app/jobs/`（通用）、`lib/`、`config/`

---

## Java / Spring Boot 项目

### 发现策略

1. 检查 `src/main/java/**/*Controller.java` 所在的包
2. 每个包含 Controller + Service + Repository 的包视为一个 feature
3. 分析 `@RequestMapping` 路径作为 feature 边界

### 排除
`config/`、`common/`、`util/`、`exception/`、`interceptor/`

---

## 通用发现规则

当以上类型均不匹配时，使用通用策略：

1. 列出 `src/` 下所有子目录（深度 1-2 层）
2. 对每个目录计算"feature 信号分数"：
   - 包含 3+ 文件：+1
   - 文件名包含领域术语（非 util/helper/common）：+1
   - 有独立的测试目录或测试文件：+1
   - 被其他目录导入：+1
3. 分数 >= 2 的目录视为候选 feature

---

## 全局排除规则

以下目录/文件在所有项目类型中始终排除：

```
node_modules/    __pycache__/     .git/            dist/
build/           .next/           .nuxt/           target/
vendor/          venv/            .venv/           env/
.idea/           .vscode/         .DS_Store        *.lock
coverage/        .pytest_cache/   __tests__/       test/
tests/           spec/            e2e/             cypress/
docs/            documentation/   scripts/         tools/
.github/         .gitlab/         .circleci/       docker/
```

**注意**：`tests/` 排除是指不作为独立 feature，但测试文件应映射回其对应的 feature 作为核心文件的一部分。

---

## 置信度评估

| 置信度 | 条件 |
|--------|------|
| **高** | 独立目录 + 有路由/入口 + 有业务逻辑文件 + 有数据模型 |
| **中** | 独立目录 + 有业务逻辑 但缺少部分信号 |
| **低** | 文件分散 / 需要语义聚合 / 可能是基础设施 |

置信度为"低"的候选 feature 应特别标注，等待用户确认。
