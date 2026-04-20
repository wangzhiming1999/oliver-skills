# 在 oliver-skill 根目录执行，自动发现并打包所有可发布 skills
# 用法: .\scripts\pack-skills-for-clawhub.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

$outputDir = Join-Path $root "clawhub-packages"
if (!(Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$skills = Get-ChildItem -Path (Join-Path $root "skills") -Directory |
  Where-Object { Test-Path (Join-Path $_.FullName "clawhub.json") }

if (-not $skills -or $skills.Count -eq 0) {
  Write-Host "No publishable skills found (missing clawhub.json)."
  exit 0
}

foreach ($skill in $skills) {
  $name = $skill.Name
  $dest = Join-Path $outputDir "$name.zip"
  if (Test-Path $dest) { Remove-Item $dest -Force }
  Compress-Archive -Path (Join-Path $skill.FullName "*") -DestinationPath $dest -Force
  Write-Host "Created clawhub-packages/$name.zip"
}
Write-Host "Done. Packaged $($skills.Count) skill(s) into clawhub-packages/."
Write-Host "If ClawHub requires .tar.gz, use WSL/Git Bash: bash scripts/pack-skills-for-clawhub.sh"
