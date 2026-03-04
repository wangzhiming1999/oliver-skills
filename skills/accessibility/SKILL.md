---
name: accessibility
description: Improves web accessibility (a11y): semantic HTML, ARIA, keyboard navigation, focus management, and screen reader support. Use when 无障碍, 可访问性, a11y, 键盘导航, 屏幕阅读器, WCAG, or making UI accessible.
---

# 无障碍与可访问性（Accessibility / a11y）

帮助前端实现符合 WCAG 理念的无障碍：语义化、ARIA、键盘与焦点、屏幕阅读器支持。

## 触发场景

- 用户说「无障碍」「可访问性」「a11y」「键盘导航」「读屏适配」「WCAG」
- 需求里提到「残障用户」「视障」「仅用键盘操作」「焦点顺序」
- 设计/产品要求通过 a11y 审计或合规

## 分析维度

### 1. 语义与结构

| 要点 | 做法 |
|------|------|
| 语义化 HTML | 用 `<main>` `<nav>` `<article>` `<button>` 等，避免 div 包一切 |
| 标题层级 | 单页内 h1 一个，h2–h6 不跳级 |
| 列表与表格 | `<ul>`/`<ol>`、`<table>` 配 `<th scope>`，不用 div 仿表格 |

### 2. 键盘与焦点

| 要点 | 做法 |
|------|------|
| 可聚焦 | 交互元素可被 Tab 聚焦；自定义控件需 `tabIndex={0}` 或 `-1`（程序控制时） |
| 焦点顺序 | DOM 顺序即 Tab 顺序；模态打开时焦点 trap、关闭回原焦点 |
| 可见焦点 | 不用 `outline: none` 且无替代；提供 `:focus-visible` 样式 |
| 键盘操作 | 支持 Enter/Space 激活、Esc 关闭、方向键操作列表/菜单 |

### 3. ARIA 与名称

| 场景 | 做法 |
|------|------|
| 名称 | 按钮/链接有可读文本或 `aria-label`/`aria-labelledby` |
| 状态 | 展开/选中/禁用等用 `aria-expanded` `aria-selected` `aria-disabled` |
| 角色 | 非语义组件用 `role` 匹配行为（如 `role="button"` `role="dialog"`） |
| 动态区域 | 重要更新用 `aria-live`（polite/assertive） |

### 4. 视觉与对比

| 要点 | 做法 |
|------|------|
| 对比度 | 文本与背景至少 4.5:1（大字 3:1）；不单靠颜色区分信息 |
| 焦点/状态 | 除颜色外有形状、图标或文字区分 |
| 缩放 | 支持 200% 缩放不破坏布局（rem、弹性布局） |

## 执行流程

### 1. 明确范围与标准

- 目标：某页面/组件/流程 或 全站
- 参考：WCAG 2.1 AA 为常见基线；若有合规要求注明等级

### 2. 逐项检查并记录

- 语义与结构：是否有误用/缺失
- 键盘：Tab 顺序、焦点 trap、Esc/Enter 等
- 读屏：用 NVDA/VoiceOver 或 axe DevTools 扫描
- 对比度与状态：颜色+非颜色区分

### 3. 给出修改建议

- 具体到文件/组件和属性
- 优先「用对 HTML」再补 ARIA
- 标注优先级：阻塞（无法使用）> 重要（体验差）> 建议（增强）

### 4. 验证方式

- axe DevTools、Lighthouse Accessibility、WAVE
- 真实键盘操作 + 至少一种屏幕阅读器

## 输出模板

```markdown
## 无障碍检查与改进报告

### 范围与标准
- 范围：…
- 参考：WCAG 2.1 AA / 自定义

### 问题列表（按优先级）
| 位置/组件 | 问题 | 建议修改 | 优先级 |
|-----------|------|----------|--------|
| … | … | … | 高/中/低 |

### 修改要点汇总
- 语义：…
- 键盘/焦点：…
- ARIA/名称：…
- 视觉/对比：…

### 验证建议
- 工具：axe / Lighthouse / WAVE
- 手动：键盘全流程 + 读屏测试
```

## 项目相关

- React：焦点用 `useRef` + `focus()`，陷阱用 `focus-trap-react` 或自实现
- Vue：`@keydown`、`ref` 聚焦；可配合 `vue-a11y` 类库
- 组件库：优先用已带 a11y 的（如 Radix、Headless UI），再按需覆盖样式
