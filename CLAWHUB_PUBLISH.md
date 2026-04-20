# 将 Skills 上架 ClawHub 指南

ClawHub (https://clawhub.ai) 是 OpenClaw 的官方技能市场。本仓库 **oliver-skill** 已抽离为独立项目，所有 skill 的 `clawhub.json` 已指向 `wangzhiming1999/oliver-skill`。

---

## 一、上架前准备

### 1. 仓库与元数据

- 在 GitHub 新建仓库 **oliver-skill**，将本目录推送到 `https://github.com/wangzhiming1999/oliver-skill`
- 各 skill 的 `clawhub.json` 已填写 `support_url`、`homepage` 为上述地址，无需再改

### 2. 准备截图（每个 skill 建议 3–5 张）

在对应 skill 目录下创建 `screenshots` 文件夹，放入截图：

- 分辨率：1920×1080 或 1280×720
- 格式：PNG
- 内容建议：主使用场景、配置/设置、示例输出等

例如：

```
skills/bug-investigation/screenshots/
  hero.png
  report-example.png
```

### 3. 可选：演示视频

- 时长 30–90 秒，展示真实使用过程
- 上传到 YouTube 或 Vimeo 后，在 ClawHub 提交时填写视频 URL

---

## 二、注册 ClawHub 开发者账号

1. 打开 **https://clawhub.ai**
2. 点击 **Sign Up** 或 **Publish a Skill**
3. 选择 **Developer Account**
4. 完善资料：显示名、简介、GitHub（建议填写为 wangzhiming1999）
5. 完成邮箱验证

---

## 三、打包并提交单个 Skill

每个 skill 需要**单独打包、单独提交**。在 **oliver-skill 项目根目录**执行。

### 方式 A：手动打包

**Git Bash / WSL / macOS / Linux：**

```bash
cd /path/to/oliver-skill
tar -czf bug-investigation.tar.gz -C skills bug-investigation
```

打包后目录内应包含：`SKILL.md`、`clawhub.json`、`README.md`、`screenshots/`（若有）。

### 方式 B：批量打包脚本

在 **oliver-skill** 根目录执行：

- **Git Bash / WSL**：`bash scripts/pack-skills-for-clawhub.sh`
- **PowerShell**：`.\scripts\pack-skills-for-clawhub.ps1`（生成 zip；若 ClawHub 仅支持 tar.gz 请用上面 shell 脚本）

会得到 11 个压缩包，再逐个在 ClawHub 后台上传。

---

## 四、在 ClawHub 后台提交

1. 登录 ClawHub → **Dashboard** → **Publish New Skill**
2. 上传对应 skill 的压缩包（如 `bug-investigation.tar.gz`）
3. 填写表单：元数据（可从 clawhub.json 带出）、截图、可选视频 URL、category 与 tags、权限说明
4. 点击 **Submit for Review**

审核一般 2–5 个工作日。若被拒，按反馈修改后更新版本号、补 CHANGELOG，再重新打包提交。

---

## 五、Skill 一览（11 个）

| 目录名               | 中文名           | category   |
|-----------------------|------------------|------------|
| bug-investigation     | Bug 排查         | development |
| component-api-design  | 组件与 API 设计  | development |
| design-to-code        | 还原设计图       | development |
| modified-code-review  | 修改代码评审     | development |
| refactor-safely       | 安全重构         | development |
| frontend-performance | 前端性能优化     | development |
| accessibility         | 无障碍 / a11y    | development |
| frontend-testing      | 前端测试         | development |
| forms-and-validation  | 表单与校验       | development |
| responsive-layout     | 响应式与布局     | development |
| api-and-data          | 接口与数据层     | development |

---

## 六、审核与更新

- **权限**：只申请必要权限，说明写清用途。
- **版本**：更新时改 `clawhub.json` 的 `version`，并维护 `CHANGELOG.md`，再重新打包提交。

完成以上步骤后，在 GitHub 建好 **oliver-skill** 仓库并推送本目录，即可按本文在 ClawHub 上架。

---

## 七、常见失败与处理（实战版）

### 1) Slug 冲突（`Slug is already taken`）

报错示例：

```text
Slug is already taken. Choose a different slug.
```

处理方式：

- 说明该 slug 已被他人占用（全局唯一）
- 发布时指定新 slug（建议加项目前缀）

示例命令：

```bash
clawhub publish "D:/felo/oliver-skill/skills/accessibility" \
  --slug "oliver-accessibility" \
  --version 1.0.0 \
  --changelog "Publish from oliver-skill repository"
```

命名建议：

- `oliver-<skill-name>`
- `wzm-<skill-name>`

避免与通用词重名（例如 `accessibility`、`testing`、`search`）。

### 2) 新技能限流（`max 5 new skills per hour`）

报错示例：

```text
Rate limit: max 5 new skills per hour. Please wait before publishing more.
```

处理方式：

- 等待 1 小时窗口恢复后重试
- 优先先发“更新版本”的 skill，再发“全新 skill”

重试示例：

```bash
clawhub publish "D:/felo/oliver-skill/skills/react-advanced" \
  --version 1.0.0 \
  --changelog "Publish from oliver-skill repository"
```

### 3) 版本已存在（`Version already exists`）

报错示例：

```text
Version already exists
```

处理方式：

- 递增版本号后重发（建议 patch +1）

示例：

- `1.0.0` 已存在 -> 改为 `1.0.1`
- `1.0.1` 已存在 -> 改为 `1.0.2`

发布示例：

```bash
clawhub publish "D:/felo/oliver-skill/skills/bug-investigation" \
  --version 1.0.1 \
  --changelog "Publish from oliver-skill repository"
```

### 4) 推荐发布顺序（降低失败率）

1. 先发已有 skill 的新版本（不占“新技能配额”）
2. 再发新技能（每小时最多 5 个）
3. 若遇冲突，先改 slug 再发

### 5) 发布前快速检查

```bash
clawhub whoami
clawhub publish --help
```

确保：

- 已登录正确账号
- 每个 skill 目录有 `SKILL.md` + `clawhub.json`（推荐再加 `README.md`）
- `clawhub.json` 的 `version` 是有效 semver（如 `1.0.0`）
