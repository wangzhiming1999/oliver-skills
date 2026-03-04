# 在 oliver-skill 根目录执行，为 ClawHub 打包 6 个 skills
# 用法: .\scripts\pack-skills-for-clawhub.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root
$skills = @(
  "bug-investigation",
  "component-api-design",
  "design-to-code",
  "modified-code-review",
  "refactor-safely",
  "frontend-performance"
)
foreach ($s in $skills) {
  $src = Join-Path "skills" $s
  $dest = Join-Path $root "$s.zip"
  if (Test-Path $dest) { Remove-Item $dest -Force }
  Compress-Archive -Path (Join-Path $src "*") -DestinationPath $dest -Force
  Write-Host "Created $s.zip"
}
Write-Host "Done. If ClawHub accepts .zip upload each; else use WSL/Git Bash: bash scripts/pack-skills-for-clawhub.sh for .tar.gz"
