#Requires -Version 5.1
<#
.SYNOPSIS
Registers a Windows scheduled task that opens the daily note at 08:00.

.DESCRIPTION
Safe to run more than once. To remove it:
    Unregister-ScheduledTask -TaskName "Obsidian - Inbox Diaria" -Confirm:$false
#>

$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot 'diaria.ps1'
$taskName = 'Obsidian - Inbox Diaria'

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Write-Host "La tarea '$taskName' ya existe. Nada que hacer." -ForegroundColor Yellow
    return
}

$action = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script`""

$trigger = New-ScheduledTaskTrigger -Daily -At '08:00'
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description 'Abre la nota diaria de Obsidian cada mañana' | Out-Null

Write-Host "Tarea creada: $taskName (todos los dias a las 08:00)" -ForegroundColor Green
