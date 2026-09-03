<#
Applies a theme variant on the running test VM for quick iteration, without
touching the VM's UI by hand.

The VM's shared folder ("win11-theme", see CLAUDE.md's VM_SHARED) already
points straight at this repo, so there's nothing to copy — the guest sees
theme-files/ live as soon as a file is saved on the host. This script's job
is just to trigger Windows into applying the .theme file inside the guest,
via VBoxManage guestcontrol (no RDP/console click-through needed).

Requires:
  - The VM is running
  - VirtualBox Guest Additions are installed in the guest (needed for
    guestcontrol to execute anything)
  - The shared folder is mounted in the guest — with -automount that's
    typically \\vboxsvr\win11-theme, but confirm the actual mapped path
    once Windows is installed (This PC will show it as a network drive)

Run:
  .\apply-theme.ps1 -Variant dark
#>

param(
    [Parameter(Mandatory)]
    [ValidateSet("dark", "light", "colorful")]
    [string]$Variant,

    [string]$VmName = "MyTheme-Win11-Test",
    [string]$GuestUser = "ThemeDev",
    [string]$GuestPassword = "ChangeMe!2026",
    [string]$GuestSharePath = "\\vboxsvr\win11-theme"
)

$ErrorActionPreference = "Stop"
$VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

$themeFileName = "MyTheme_$([char]::ToUpper($Variant[0]) + $Variant.Substring(1)).theme"
$guestThemePath = "$GuestSharePath\theme-files\$Variant\$themeFileName"

Write-Host "Applying $Variant variant via $guestThemePath ..."

# Asking Explorer to "open" the .theme file runs it through the OS's
# registered handler (themecpl.dll) — the same thing a double-click does.
& $VBoxManage guestcontrol $VmName run `
    --username $GuestUser --password $GuestPassword `
    --exe "C:\Windows\explorer.exe" `
    -- explorer.exe $guestThemePath

Write-Host "Sent. Check the VM's display — Windows applies themes near-instantly, but the taskbar may flash once."
