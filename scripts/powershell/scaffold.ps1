<#
Creates the full project folder structure defined in CLAUDE.md.
Safe to re-run — only creates folders/files that don't already exist.
#>

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$folders = @(
    "design",
    "assets\source\components",
    "assets\dark",
    "assets\light",
    "assets\colorful",
    "theme-files\base",
    "theme-files\dark",
    "theme-files\light",
    "theme-files\colorful",
    "scripts\gimp",
    "scripts\python",
    "scripts\powershell",
    "wallpapers\dark",
    "wallpapers\light",
    "wallpapers\colorful",
    "cursors",
    "sounds",
    "docs\screenshots",
    "release"
)

foreach ($folder in $folders) {
    $path = Join-Path $root $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Created: $folder"
    } else {
        Write-Host "Exists:  $folder"
    }
}

# .gitkeep in every otherwise-empty folder so git tracks the structure
foreach ($folder in $folders) {
    $path = Join-Path $root $folder
    $hasFiles = Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue
    if (-not $hasFiles) {
        New-Item -ItemType File -Path (Join-Path $path ".gitkeep") -Force | Out-Null
    }
}

Write-Host "`nScaffold complete."
