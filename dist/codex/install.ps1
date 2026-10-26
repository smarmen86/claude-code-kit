# Codex CLI installer (Windows) — Klugman IT KIT
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Resolve-Path (Join-Path $ScriptDir "..\..")
$Target = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }

Write-Host "Installing KIT for Codex CLI -> $Target" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Target "agents"), (Join-Path $Target "skills") | Out-Null

Write-Host "[1/4] 276 subagents..." -ForegroundColor Yellow
Copy-Item (Join-Path $ScriptDir "agents\*.toml") (Join-Path $Target "agents") -Force

Write-Host "[2/4] 114 skills..." -ForegroundColor Yellow
$Skills = Join-Path $RepoRoot "skills"
if (Test-Path $Skills) { Copy-Item (Join-Path $Skills "*") (Join-Path $Target "skills") -Recurse -Force }

Write-Host "[3/4] AGENTS.md..." -ForegroundColor Yellow
$AgentsMd = Join-Path $Target "AGENTS.md"
if (Test-Path $AgentsMd) { Copy-Item (Join-Path $ScriptDir "AGENTS.md") (Join-Path $Target "AGENTS.override.md") -Force }
else { Copy-Item (Join-Path $ScriptDir "AGENTS.md") $AgentsMd -Force }

Write-Host "[4/4] config.toml..." -ForegroundColor Yellow
$Cfg = Join-Path $Target "config.toml"
if (-not (Test-Path $Cfg)) { Copy-Item (Join-Path $ScriptDir "config.toml") $Cfg -Force }
else { Write-Host "      exists — merge config.toml by hand." -ForegroundColor Gray }

Write-Host "Done." -ForegroundColor Cyan
