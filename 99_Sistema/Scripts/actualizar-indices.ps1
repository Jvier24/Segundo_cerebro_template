#Requires -Version 5.1
<#
.SYNOPSIS
Rebuilds every automatic index block in the vault from note frontmatter.

.EXPECTED MARKERS
<!-- INDICE:teoria -->
...generated content...
<!-- /INDICE:teoria -->
#>

$ErrorActionPreference = 'Stop'
$scriptsDir = $PSScriptRoot
$sistemaDir = Split-Path -Parent $scriptsDir
$root = Split-Path -Parent $sistemaDir
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Get-Frontmatter {
    param([string]$Text)

    $fm = @{}
    $lines = $Text -split "`r?`n"
    if ($lines.Count -eq 0 -or $lines[0].Trim() -ne '---') { return $fm }

    for ($i = 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line.Trim() -eq '---') { break }
        if ($line -match '^\s*([A-Za-z0-9_-]+)\s*:\s*(.*)$') {
            $key = $Matches[1].ToLowerInvariant()
            $val = $Matches[2].Trim()
            if ($val.StartsWith('[') -and $val.EndsWith(']')) {
                $val = $val.Substring(1, $val.Length - 2)
            }
            $val = $val.Trim('"', "'")
            $fm[$key] = $val
        }
    }
    return $fm
}

function Get-NoteDate {
    param($Note)
    foreach ($key in @('actualizado', 'creado', 'fecha')) {
        if ($Note.Fm.ContainsKey($key) -and $Note.Fm[$key] -match '^\d{4}-\d{2}-\d{2}') {
            return $Note.Fm[$key]
        }
    }
    return $Note.File.LastWriteTime.ToString('yyyy-MM-dd')
}

function List-Notes {
    param($Items, [string]$Empty)
    $arr = @($Items | Where-Object { $null -ne $_ })
    if ($arr.Count -eq 0) { return "- $Empty" }
    return (($arr | ForEach-Object { "- [[$($_.Name)]]" }) -join "`n")
}

# --- Gather notes -----------------------------------------------------------
$mdFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.md' |
    Where-Object {
        $_.FullName -notmatch '\\\.obsidian\\' -and
        $_.FullName -notmatch '\\99_Sistema\\Templates\\' -and
        $_.FullName -notmatch '\\99_Sistema\\Scripts\\' -and
        $_.FullName -notmatch '\\Plantillas legacy\\'
    }

$notes = foreach ($file in $mdFiles) {
    $text = [System.IO.File]::ReadAllText($file.FullName)
    [pscustomobject]@{
        File = $file
        Name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        Rel  = $file.FullName.Substring($root.Length + 1)
        Text = $text
        Fm   = Get-Frontmatter -Text $text
    }
}

# --- Build index blocks -----------------------------------------------------
$blocks = @{}

$blocks['proyectos'] = List-Notes ($notes | Where-Object {
    $_.Fm['tipo'] -eq 'proyecto' -and $_.Fm['estado'] -ne 'terminado'
}) 'Sin proyectos activos'

$blocks['areas'] = List-Notes ($notes | Where-Object {
    $_.Fm['tipo'] -eq 'area'
}) 'Sin areas activas'

foreach ($type in @('teoria', 'experimento', 'probado')) {
    $items = $notes | Where-Object { $_.Fm['tipo'] -eq $type } |
        Sort-Object { Get-NoteDate $_ } -Descending
    $blocks[$type] = List-Notes $items "Sin notas de $type"
}

$blocks['archivo'] = List-Notes ($notes | Where-Object {
    $_.Rel -like '04_Archivo\*' -and $_.Fm['tipo'] -ne 'indice'
}) 'Vacio por ahora.'

$blocks['inbox'] = List-Notes ($notes | Where-Object {
    $_.Rel -like '00_Inbox\*' -and $_.Fm['tipo'] -ne 'indice'
}) 'Vacio por ahora.'

$recientes = $notes | Where-Object {
    $_.Fm['tipo'] -in @('proyecto', 'teoria', 'experimento', 'probado', 'area', 'diaria')
} | Sort-Object { Get-NoteDate $_ } -Descending | Select-Object -First 12

$recientesArr = @($recientes | Where-Object { $null -ne $_ })
if ($recientesArr.Count -eq 0) {
    $blocks['recientes'] = '- Sin notas todavia'
} else {
    $blocks['recientes'] = (($recientesArr | ForEach-Object {
        "- [[$($_.Name)]] - $($_.Fm['tipo'])"
    }) -join "`n")
}

$areaMap = @{
    'area-inacap'              = 'INACAP'
    'area-dev-stack'           = 'Dev-Stack'
    'area-automatizacion-ia'   = 'Automatizacion-IA'
}
foreach ($key in $areaMap.Keys) {
    $wanted = $areaMap[$key]
    $blocks[$key] = List-Notes ($notes | Where-Object {
        $_.Fm['tipo'] -eq 'teoria' -and $_.Fm['area'] -eq $wanted
    }) 'Sin notas todavia'
}

# --- Replace markers --------------------------------------------------------
$pattern = '(?is)<!--\s*INDICE:(?<key>[A-Za-z0-9-]+)\s*-->(?<body>.*?)<!--\s*/INDICE:\k<key>\s*-->'
$changed = 0

foreach ($note in $notes) {
    $text = $note.Text
    $idxMatches = [regex]::Matches($text, $pattern)
    if ($idxMatches.Count -eq 0) { continue }

    $sb = New-Object System.Text.StringBuilder
    $last = 0
    $hit = $false

    foreach ($m in $idxMatches) {
        $key = $m.Groups['key'].Value.ToLowerInvariant()
        [void]$sb.Append($text.Substring($last, $m.Index - $last))

        if ($blocks.ContainsKey($key)) {
            [void]$sb.Append("<!-- INDICE:$key -->")
            [void]$sb.Append("`n")
            [void]$sb.Append($blocks[$key])
            [void]$sb.Append("`n")
            [void]$sb.Append("<!-- /INDICE:$key -->")
            $hit = $true
        } else {
            [void]$sb.Append($m.Value)
        }
        $last = $m.Index + $m.Length
    }

    [void]$sb.Append($text.Substring($last))

    if ($hit -and $sb.ToString() -ne $text) {
        [System.IO.File]::WriteAllText($note.File.FullName, $sb.ToString(), $utf8NoBom)
        $changed++
    }
}

Write-Host "Indices actualizados en $changed notas." -ForegroundColor Green
