#Requires -Version 5.1
<#
.SYNOPSIS
Creates (if needed) and opens today's daily note in 00_Inbox.
#>

$ErrorActionPreference = 'Stop'
$scriptsDir = $PSScriptRoot
$sistemaDir = Split-Path -Parent $scriptsDir
$root = Split-Path -Parent $sistemaDir
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$today = Get-Date -Format 'yyyy-MM-dd'
$folder = '00_Inbox'
$name = $today
$target = Join-Path $root ($folder + '\' + $name + '.md')

if (-not (Test-Path -LiteralPath $target)) {
    $body = @(
        '---'
        'tipo: diaria'
        'estado: borrador'
        'stack: []'
        "fecha: $today"
        "actualizado: $today"
        'tags: [diario]'
        '---'
        ''
        "# $today - Diario"
        ''
        '## Enfoque del dia'
        ''
        '- [ ] '
        ''
        '## Capturas rapidas'
        ''
        '- '
        ''
        '## Tareas'
        ''
        '- [ ] '
        ''
        '## Notas tocadas hoy'
        ''
        '- [[Inicio]]'
        ''
        '## Aprendizajes'
        ''
        '- '
        ''
        '## Cierre'
        ''
        '- '
        ''
    ) -join "`n"
    [System.IO.File]::WriteAllText($target, $body, $utf8NoBom)
    Write-Host "Creada: $folder\$name.md" -ForegroundColor Green
}

$vault = [uri]::EscapeDataString((Split-Path -Leaf $root))
$fileParam = [uri]::EscapeDataString($folder) + '/' + [uri]::EscapeDataString($name)
Start-Process "obsidian://open?vault=$vault&file=$fileParam"
