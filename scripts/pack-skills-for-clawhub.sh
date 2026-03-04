#!/bin/bash
# 在 oliver-skill 根目录执行，为 ClawHub 打包 6 个 skills
# 用法: bash scripts/pack-skills-for-clawhub.sh
set -e
cd "$(dirname "$0")/.."
SKILLS="bug-investigation component-api-design design-to-code modified-code-review refactor-safely frontend-performance"
for s in $SKILLS; do
  tar -czf "${s}.tar.gz" -C skills "$s"
  echo "Created ${s}.tar.gz"
done
echo "Done. Upload each .tar.gz to ClawHub → Publish New Skill."
