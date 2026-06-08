# ============================================
# Claude Code Agent Kit (KIT) - Windows Installer
# Klugman IT | klugmans.com
# ============================================
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Target = Join-Path $env:USERPROFILE ".claude"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Claude Code Agent Kit (KIT) - Installer"  -ForegroundColor Cyan
Write-Host "  Klugman IT | klugmans.com"                 -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Create target if it doesn't exist
if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}

# --- Agents ---
Write-Host "[1/5] Installing 276 agents..." -ForegroundColor Yellow
$AgentsDir = Join-Path $Target "agents"
if (-not (Test-Path $AgentsDir)) { New-Item -ItemType Directory -Path $AgentsDir -Force | Out-Null }
Copy-Item -Path (Join-Path $ScriptDir "agents\*.md") -Destination $AgentsDir -Force
Write-Host "      Done." -ForegroundColor Green

# --- Skills ---
$SkillsSrc = Join-Path $ScriptDir "skills"
if (Test-Path $SkillsSrc) {
    Write-Host "[2/5] Installing skills..." -ForegroundColor Yellow
    Copy-Item -Path $SkillsSrc -Destination $Target -Recurse -Force
    Write-Host "      Done." -ForegroundColor Green
} else {
    Write-Host "[2/5] No skills directory found, skipping." -ForegroundColor Gray
}

# --- Bin scripts ---
$BinSrc = Join-Path $ScriptDir "bin"
if (Test-Path $BinSrc) {
    Write-Host "[3/5] Installing bin scripts..." -ForegroundColor Yellow
    $BinDir = Join-Path $Target "bin"
    if (-not (Test-Path $BinDir)) { New-Item -ItemType Directory -Path $BinDir -Force | Out-Null }
    Copy-Item -Path (Join-Path $BinSrc "*") -Destination $BinDir -Force
    Write-Host "      Done." -ForegroundColor Green
} else {
    Write-Host "[3/5] No bin directory found, skipping." -ForegroundColor Gray
}

# --- CLAUDE.md ---
$ClaudeMd = Join-Path $Target "CLAUDE.md"
if (Test-Path $ClaudeMd) {
    Write-Host "[4/5] CLAUDE.md already exists - skipping (will not overwrite your config)." -ForegroundColor Gray
    Write-Host "      To use KIT's routing, manually copy:" -ForegroundColor Gray
    Write-Host "      Copy-Item '$ScriptDir\CLAUDE.md' '$ClaudeMd'" -ForegroundColor Gray
} else {
    Write-Host "[4/5] Installing CLAUDE.md (agent routing index)..." -ForegroundColor Yellow
    Copy-Item -Path (Join-Path $ScriptDir "CLAUDE.md") -Destination $ClaudeMd
    Write-Host "      Done." -ForegroundColor Green
}

# --- settings.json ---
$SettingsJson = Join-Path $Target "settings.json"
if (Test-Path $SettingsJson) {
    Write-Host "[5/5] settings.json already exists - skipping (will not overwrite your config)." -ForegroundColor Gray
    Write-Host "      Review $ScriptDir\settings.json for hooks and MCP config to merge manually." -ForegroundColor Gray
} else {
    Write-Host "[5/5] Installing settings.json (hooks, MCPs, permissions)..." -ForegroundColor Yellow
    Copy-Item -Path (Join-Path $ScriptDir "settings.json") -Destination $SettingsJson
    Write-Host "      Done." -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  KIT installed to $Target"                   -ForegroundColor Cyan
Write-Host "  276 agents ready. Start Claude Code and go." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
