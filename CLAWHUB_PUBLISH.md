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

会得到 6 个压缩包，再逐个在 ClawHub 后台上传。

---

## 四、在 ClawHub 后台提交

1. 登录 ClawHub → **Dashboard** → **Publish New Skill**
2. 上传对应 skill 的压缩包（如 `bug-investigation.tar.gz`）
3. 填写表单：元数据（可从 clawhub.json 带出）、截图、可选视频 URL、category 与 tags、权限说明
4. 点击 **Submit for Review**

审核一般 2–5 个工作日。若被拒，按反馈修改后更新版本号、补 CHANGELOG，再重新打包提交。

---

## 五、6 个 Skill 一览

| 目录名               | 中文名           | category   |
|-----------------------|------------------|------------|
| bug-investigation     | Bug 排查         | development |
| component-api-design  | 组件与 API 设计  | development |
| design-to-code        | 还原设计图       | development |
| modified-code-review  | 修改代码评审     | development |
| refactor-safely       | 安全重构         | development |
| frontend-performance | 前端性能优化     | development |

---

## 六、审核与更新

- **权限**：只申请必要权限，说明写清用途。
- **版本**：更新时改 `clawhub.json` 的 `version`，并维护 `CHANGELOG.md`，再重新打包提交。

完成以上步骤后，在 GitHub 建好 **oliver-skill** 仓库并推送本目录，即可按本文在 ClawHub 上架。
