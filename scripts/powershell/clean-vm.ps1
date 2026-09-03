<#
Resets the VM's theme to Windows default, for a clean starting point before
testing a new build (avoids stale visual state from the previous variant
carrying over in a way that masks or fakes a fix).

Run INSIDE the VM (not on the host):
  .\clean-vm.ps1
#>

$ErrorActionPreference = "Stop"

$defaultTheme = "$env:SystemRoot\resources\Themes\aero.theme"
if (-not (Test-Path $defaultTheme)) {
    # Windows 11 ships Windows.theme as the actual default in most builds;
    # aero.theme is the older fallback name. Try both before giving up.
    $defaultTheme = "$env:SystemRoot\resources\Themes\Windows.theme"
}

if (-not (Test-Path $defaultTheme)) {
    throw "Could not find a default theme file under $env:SystemRoot\resources\Themes\ — check the exact filename on this build and pass it explicitly."
}

Write-Host "Resetting to default theme: $defaultTheme"
Start-Process "$env:SystemRoot\explorer.exe" -ArgumentList $defaultTheme
Write-Host "Sent. Windows applies themes near-instantly, but the taskbar may flash once."
