---
name: forms-and-validation
description: Designs form structure, validation rules, error handling, and accessible form UX. Use when 表单, 校验, 提交, 受控组件, form validation, 错误提示, or form UX.
---

# 表单与校验（Forms and Validation）

帮助设计表单结构、校验规则、错误提示与无障碍表单体验。

## 触发场景

- 用户说「表单」「校验」「提交」「受控组件」「form validation」「错误提示」
- 需求：多字段、联动、异步校验、防重复提交、无障碍

## 分析维度

### 1. 表单结构

| 要点 | 做法 |
|------|------|
| 受控 vs 非受控 | 需校验/联动用受控；简单场景可用非受控 + ref |
| 状态集中 | 单表单用 useState 或 useReducer；复杂用 React Hook Form / Formik / 自管理 |
| 字段命名 | name 与后端一致，便于序列化与错误映射 |

### 2. 校验时机与规则

| 时机 | 适用 |
|------|------|
| 失焦 (blur) | 单字段格式（邮箱、手机、长度） |
| 输入中 (change) | 实时格式提示，避免提交才报错 |
| 提交时 | 必填、跨字段、异步校验（如用户名是否存在） |

| 规则 | 实现 |
|------|------|
| 必填、长度、格式 | 正则或 Zod/Yup/ajv 等 schema |
| 跨字段 | 如「密码与确认一致」「起止日期」在 submit 或 schema 里校验 |
| 异步 | 防抖后调接口，结果写回字段错误状态 |

### 3. 错误展示与无障碍

| 要点 | 做法 |
|------|------|
| 错误位置 | 字段下方或旁侧，与字段 id 关联 |
| 关联 | `aria-describedby` 指向错误文案的 id；`aria-invalid="true"` 当有误 |
| 提交失败 | 列表汇总 + 滚动到首个错误字段并 focus |
| 读屏 | 错误文案在 DOM 中且与控件关联，便于读屏朗读 |

### 4. 提交与防重复

| 要点 | 做法 |
|------|------|
| 防重复提交 | 提交中禁用按钮或 loading 态，避免多次触达接口 |
| 成功/失败 | 成功跳转或提示；失败保留填写内容并展示错误 |
| 重置 | 明确「清空」与「重置为初始值」语义 |

## 执行流程

### 1. 明确表单范围

- 字段列表、必填/选填、格式与业务规则
- 是否有异步校验、联动（如省市区）、文件上传

### 2. 选型与结构

- 是否用 React Hook Form / Formik / 原生
- 校验用 Zod / Yup / 自定义函数

### 3. 设计校验规则与时机

- 每字段：必填、格式、长度、异步（若有）
- 提交时：跨字段 + 最终兜底

### 4. 错误与 a11y

- 错误 state 与展示位置
- aria-describedby、aria-invalid、焦点与滚动

## 输出模板

```markdown
## 表单与校验方案

### 表单范围
- 字段：…（必填/选填、格式）
- 特殊：异步校验 / 联动 / 文件

### 结构与选型
- 状态：受控 + React Hook Form / Formik / 自管理
- 校验：Zod / Yup / 自定义

### 校验规则（按字段）
| 字段 | 时机 | 规则 |
|------|------|------|
| … | blur/change/submit | … |

### 错误与无障碍
- 展示方式：…
- aria / 焦点 / 汇总：…
```

## 项目相关

- React：受控 + useState 或 React Hook Form + Zod；错误用 setError / 字段级 error
- Vue：v-model + 计算/校验；可配合 VeeValidate 或自写
- 无障碍：每个 input 配 label（for/id）；错误用 aria-describedby 指向同一 id
