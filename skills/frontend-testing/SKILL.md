---
name: frontend-testing
description: Designs and writes frontend tests: unit, component, integration, E2E; test structure, mocking, and coverage. Use when 前端测试, 单元测试, 组件测试, E2E, Jest, Vitest, Testing Library, or writing tests.
---

# 前端测试（Frontend Testing）

帮助设计测试策略、编写单元/组件/集成/E2E 测试，以及 mock、断言与覆盖率考量。

## 触发场景

- 用户说「写测试」「单元测试」「组件测试」「E2E」「Jest」「Vitest」「Testing Library」
- 需求「提高覆盖率」「回归不放心」「改完怕坏」
- 已有测试框架，需要补用例或重构测试

## 测试分层与选型

| 类型 | 适用 | 常用工具 | 关注点 |
|------|------|----------|--------|
| 单元 | 纯函数、工具、hooks | Jest / Vitest | 输入输出、边界、副作用 |
| 组件 | 组件渲染与交互 | React Testing Library / Vue Test Utils | 用户行为、可访问性、状态 |
| 集成 | 多模块/请求/路由 | Jest+MSW / Vitest+MSW | 流程、接口 mock、错误态 |
| E2E | 关键用户路径 | Playwright / Cypress | 真实浏览器、稳定选择器、环境 |

## 执行流程

### 1. 明确测试目标

- 测什么：单文件/组件/流程/整页
- 现有栈：Jest / Vitest / RTL / Playwright 等
- 约束：CI 时间、覆盖率要求、是否允许 E2E

### 2. 设计用例

- **正向**：主流程、常见输入
- **边界**：空值、长文本、权限/角色
- **异常**：接口失败、超时、无权限
- **交互**：点击、输入、提交、取消

### 3. Mock 策略

| 对象 | 做法 |
|------|------|
| 接口 | MSW（推荐）/ axios-mock-adapter / jest.mock |
| 路由 | MemoryRouter / createMemoryHistory 或 mock useNavigate |
| 时间 | jest.useFakeTimers / vi.setSystemTime |
| 环境 | process.env / vi.stubEnv |

### 4. 写法与断言

- 组件：以「用户行为」为主（找按钮、点击、查文案），少依赖实现细节（state/class）
- 异步：waitFor / findBy* / 断言前确保请求完成
- 可访问性：优先用 getByRole、getByLabelText，兼顾 a11y

### 5. 覆盖率与维护

- 优先覆盖核心逻辑与易错路径，不盲目追 100%
- 避免过度 snapshot；关键结构可小范围 snapshot
- 测试命名：描述「谁在什么条件下得到什么结果」

## 输出模板

```markdown
## 测试方案 / 用例说明

### 范围与工具
- 被测对象：…
- 框架：Jest / Vitest / RTL / Playwright / …

### 用例列表
| 场景 | 类型 | 要点 |
|------|------|------|
| … | 单元/组件/集成/E2E | … |

### Mock 与环境
- 接口：MSW handlers / …
- 路由/时间：…

### 示例代码（可选）
- 关键 1–2 个用例的代码片段
```

## 项目相关

- React：RTL + Jest/Vitest；hooks 用 renderHook；路由用 MemoryRouter
- Vue：Vue Test Utils + Jest/Vitest；Composition API 同 renderHook 思路
- Next.js：可测 App Router 页面用 testing-library；API 用 MSW 或 node mock
- E2E：Playwright 优先（多浏览器、稳定）；选择器优先 role > text > testid
