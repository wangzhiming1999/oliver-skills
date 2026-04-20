---
name: feature-memory-init
description: |
  批量初始化项目的 Feature Memory，一键生成所有功能模块的 .features/ 记忆文件。

  触发条件：
  (1) 用户说"初始化所有 feature memory"或"批量生成 feature memory"
  (2) 用户说"分析项目并创建功能记忆"或"一键生成功能记忆"
  (3) 用户要求一次性为整个项目建立 .features/ 目录
  (4) 用户提到 "feature-memory-init"

  核心价值：将需要逐个手动触发 feature-memory 的工作批量完成，快速为项目建立完整的知识库。
---

# Feature Memory Init

批量为项目生成所有 Feature Memory——一键从零建立完整项目知识库。

## 前置条件

- 目标项目为代码项目（有源码目录）

## 工作流

严格按照以下 4 个阶段顺序执行。每个阶段完成后向用户汇报进展。

---

### 阶段 1：项目扫描与功能发现

#### 步骤 1.1：识别项目类型

检查项目根目录下的配置文件，判断项目类型：

```
pyproject.toml / setup.py       → Python
package.json + next.config.*    → Next.js
package.json + vue/vite config  → Vue
package.json + src/App.tsx      → React SPA
go.mod                          → Go
Cargo.toml                      → Rust
pom.xml / build.gradle          → Java/Spring
Gemfile + config/routes.rb      → Rails
pnpm-workspace.yaml / turbo.json → Monorepo
```

使用 Glob 检查这些文件是否存在。如无法判断，询问用户。

#### 步骤 1.2：扫描源码结构

根据项目类型，使用 Glob 扫描源码目录。参考 [discovery-strategies.md](references/discovery-strategies.md) 中对应项目类型的策略。

核心原则：
- 每个有独立业务逻辑的目录/模块视为一个 feature 候选
- 基础设施目录（utils、common、config）排除
- 排除 node_modules、__pycache__、.git、dist、build、migrations、tests 等非源码目录

#### 步骤 1.3：检查已有 .features/

```bash
ls .features/
```

如已存在 `.features/` 目录：
- 读取已有的 feature 名列表
- 标记已存在的 feature 为"已存在"（可选更新）
- 新发现的 feature 标记为"新建"

#### 步骤 1.4：构建候选列表

为每个候选 feature 整理：
- **模块名**：kebab-case 格式
- **负责范围**：一句话描述
- **核心路径**：主要源码目录/文件
- **置信度**：高/中/低（参考 discovery-strategies.md 的置信度评估规则）
- **状态**：新建 / 已存在 / 已存在(需更新)

---

### 阶段 2：用户确认

将发现结果以表格形式展示给用户：

```markdown
## 发现的功能模块（共 X 个）

| # | 模块名 | 负责范围 | 核心路径 | 置信度 | 状态 |
|---|--------|---------|---------|--------|------|
| 1 | auth   | 用户认证 | src/auth/ | 高 | 新建 |
| 2 | ...    | ...     | ...      | ... | ... |

### 排除的目录
- `src/common/` — 共享工具
- `src/config/` — 配置文件
```

使用 AskUserQuestion 询问用户：

1. 是否需要**删除**某些误判的 feature？
2. 是否需要**添加**遗漏的 feature？
3. 是否需要**重命名**或**调整范围**？
4. 对于"已存在"的 feature，是否要**重新生成**覆盖？

等待用户确认最终列表后，再进入阶段 3。

---

### 阶段 3：逐一生成 Feature Memory

对用户确认的每个 feature，按顺序执行以下步骤。**每完成一个 feature，输出一行进度**（如 `[3/8] ✅ payment 已完成`）。

#### 步骤 3.1：创建目录结构

```bash
mkdir -p .features/[feature-name]/decisions
mkdir -p .features/[feature-name]/changelog
mkdir -p .features/[feature-name]/docs
```

#### 步骤 3.2：读取和分析源代码

1. 使用 Glob 列出 feature 核心路径下的所有源码文件
2. 按优先级读取文件（上限 10-15 个文件，避免上下文溢出）：
   - **P0**（必读）：入口文件（router/endpoints/views）、主 service 文件
   - **P1**（应读）：数据模型（models/schemas）、配置文件
   - **P2**（可读）：工具函数、中间件、测试文件
3. 分析代码，提取：
   - 架构模式（分层结构、设计模式）
   - 核心依赖（导入的外部库和内部模块）
   - 被依赖关系（哪些其他模块 import 了本模块）
   - 潜在注意事项（TODO/FIXME 注释、复杂逻辑、异常处理模式）
   - 可能的调试入口（常见问题和排查路径）

#### 步骤 3.3：填充 MEMORY.md

按照以下模板结构填充内容：

```markdown
# [Feature Name]

> 负责范围：[从代码分析中得出的范围描述]
> 最后更新：[当天日期 YYYY-MM-DD]

## 当前状态
[2-3 句话，基于代码分析总结当前架构和实现状态]

## 核心文件
[实际的文件树，带简要说明]

## 依赖关系
- **依赖**：[从 import 分析得出]
- **被依赖**：[从反向引用分析得出]

## 最近重要事项
- [当天日期]: 初始化 Feature Memory（由 feature-memory-init 批量生成）

## Gotchas（开发必读）
⚠️ 以下是开发此 feature 时必须注意的事项：
[从 TODO/FIXME、复杂逻辑、特殊配置中提取]

## 调试入口
[基于代码结构推断的常见问题排查路径]

## 索引
- 设计决策：`decisions/`
- 变更历史：`changelog/`
- 相关文档：`docs/`
```

**填充原则**：
- 只写代码分析能确认的事实，不编造业务上下文
- Gotchas 部分宁缺毋滥，只记录从代码中能明确看出的注意事项
- 如果某个部分信息不足，写 `[待补充]` 而非编造内容

#### 步骤 3.4：创建初始决策记录（可选）

如果从代码中能识别出明显的架构决策（如认证方式选择、ORM 选型、缓存策略），按以下格式创建记录：

```markdown
# 决策：[决策标题]

> 日期：YYYY-MM-DD
> 状态：已决定

## 背景
[为什么需要做这个决策]

## 决策
[做了什么选择]

## 理由
[为什么选这个而不是其他]

## 后果
[这个决策带来的影响]
```

决策记录文件名格式：`decisions/YYYY-MM-[topic].md`

**注意**：只在有充分代码证据时才创建决策记录。大多数 feature 初始化时不会有决策记录，这是正常的。

#### 步骤 3.5：输出进度

每个 feature 完成后输出：
```
[N/Total] ✅ [feature-name] 已完成 (MEMORY.md + X 条决策记录)
```

---

### 阶段 4：汇总报告

所有 feature 生成完毕后，输出完成报告：

```markdown
## Feature Memory Init — 完成报告

> 项目: [项目名称]
> 生成时间: YYYY-MM-DD
> 功能模块数: X

| 模块 | 状态 | MEMORY.md | 决策记录 | 备注 |
|------|------|-----------|----------|------|
| auth | ✅ 已生成 | 已填充 | 1 条 | |
| payment | ✅ 已生成 | 已填充 | 0 条 | |
| ... | ... | ... | ... | ... |

### 后续建议
1. **审阅**：逐一检查每个 MEMORY.md，补充 AI 无法从代码推断的业务上下文
2. **补充 Gotchas**：添加团队口口相传的"坑"和注意事项
3. **日常维护**：在日常开发中使用 `feature-memory` 技能持续更新
4. **决策记录**：未来的重要架构决策请记录在对应 feature 的 `decisions/` 目录
```

参考 [example-feature-list.md](references/example-feature-list.md) 了解完整的输出示例。

---

## 特殊场景处理

### 大项目（>15 个 feature）

如发现超过 15 个 feature，在阶段 2 中建议用户分批处理：
- 让用户标记优先级（高/中/低）
- 先处理高优先级 feature
- 后续可再次运行处理剩余 feature

### 已有部分 .features/ 的项目

- 默认跳过已存在的 feature（不覆盖）
- 用户可在阶段 2 选择"重新生成"来覆盖特定 feature
- 覆盖前备份原有 MEMORY.md 内容

### 无法判断项目类型

- 询问用户项目类型和源码目录位置
- 使用通用发现规则（参考 discovery-strategies.md "通用发现规则"部分）

### 微服务/多仓库项目

- 每个服务视为一个独立 feature
- 如在 monorepo 中，按 workspace 包划分
- 如用户指定只处理某个子项目，限定扫描范围
