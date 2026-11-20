#Requires -Version 5.1
<#
.SYNOPSIS
Creates a knowledge note from one of the four official templates.

.EXAMPLE
.\nueva-nota.ps1 -Tipo Experimento -Titulo "Parser con BeautifulSoup" -Proyecto proyecto-ejemplo -Stack "python, requests"
#>

param(
    [string]$Tipo = '',
    [string]$Titulo = '',
    [string]$Proyecto = '',
    [string[]]$Stack = @(),
    [switch]$Abrir,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$scriptsDir = $PSScriptRoot
$sistemaDir = Split-Path -Parent $scriptsDir
$root = Split-Path -Parent $sistemaDir
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function ConvertTo-Slug {
    param([string]$Text)

    $normalized = $Text.Normalize([System.Text.NormalizationForm]::FormD)
    $sb = New-Object System.Text.StringBuilder
    foreach ($ch in $normalized.ToCharArray()) {
        $category = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch)
        if ($category -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($ch)
        }
    }
    $ascii = $sb.ToString()
    $slug = ($ascii.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
    if ([string]::IsNullOrWhiteSpace($slug)) { return 'nota' }
    return $slug
}

$map = [ordered]@{
    'Teoria'      = @{ Template = 'tpl_teoria.md';      Folder = '03_Recursos' }
    'Probado'     = @{ Template = 'tpl_probado.md';     Folder = '03_Recursos' }
    'Experimento' = @{ Template = 'tpl_experimento.md'; Folder = '00_Inbox' }
    'Proyecto'    = @{ Template = 'tpl_proyecto.md';    Folder = '01_Proyectos' }
}

# --- Choose type ------------------------------------------------------------
if (-not $Tipo) {
    Write-Host "Que tipo de conocimiento quieres crear?" -ForegroundColor Cyan
    $keys = @($map.Keys)
    for ($i = 0; $i -lt $keys.Count; $i++) {
        Write-Host "  $($i + 1)) $($keys[$i])"
    }
    $choice = Read-Host "Elige un numero (1-$($keys.Count))"
    $n = 0
    if (-not [int]::TryParse($choice, [ref]$n) -or $n -lt 1 -or $n -gt $keys.Count) {
        Write-Error "Opcion no valida."
        return
    }
    $Tipo = $keys[$n - 1]
}

if (-not $map.Contains($Tipo)) {
    Write-Error "Tipo no valido: $Tipo. Usa: $($map.Keys -join ', ')"
    return
}

# --- Resolve title ----------------------------------------------------------
if (-not $Titulo) { $Titulo = Read-Host "Titulo de la nota" }
if ([string]::IsNullOrWhiteSpace($Titulo)) {
    Write-Error "El titulo no puede estar vacio."
    return
}
$displayTitle = $Titulo.Trim()
$clean = $displayTitle -replace '[<>:"\/\\|?*]', ''
$clean = $clean.Trim().TrimEnd('.')
if ([string]::IsNullOrWhiteSpace($clean)) {
    Write-Error "El titulo no produce un nombre de archivo valido."
    return
}
$slug = ConvertTo-Slug $displayTitle

# --- Resolve folder ---------------------------------------------------------
# Un proyecto vive en 01_Proyectos/<slug>/<slug>.md: la carpeta y la nota
# comparten el mismo nombre, como en proyecto-ejemplo.
$folder = $map[$Tipo].Folder
$fileName = $clean
if ($Tipo -eq 'Proyecto') {
    if (-not [string]::IsNullOrWhiteSpace($Proyecto)) {
        $folder = "01_Proyectos/$Proyecto"
    } else {
        $folder = "01_Proyectos/$slug"
        $fileName = $slug
    }
}
$targetDir = Join-Path $root ($folder -replace '/', [System.IO.Path]::DirectorySeparatorChar)

# --- Fill template ----------------------------------------------------------
$templatePath = Join-Path (Join-Path $sistemaDir 'Templates') $map[$Tipo].Template
if (-not (Test-Path -LiteralPath $templatePath)) {
    Write-Error "No encuentro la plantilla: $templatePath"
    return
}

$text = [System.IO.File]::ReadAllText($templatePath)
$text = $text.Replace('{{title}}', $displayTitle)
$text = $text.Replace('{{date:YYYY-MM-DD}}', (Get-Date -Format 'yyyy-MM-dd'))

if (-not [string]::IsNullOrWhiteSpace($Proyecto)) {
    $text = $text.Replace('proyecto: ""', "proyecto: `"$Proyecto`"")
}
if ($Stack.Count -gt 0) {
    $stackValue = $Stack -join ', '
    $text = $text.Replace('stack: []', "stack: [$stackValue]")
}

# --- Write file -------------------------------------------------------------
if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}
$target = Join-Path $targetDir ($fileName + '.md')

if ((Test-Path -LiteralPath $target) -and -not $Force) {
    Write-Warning "Ya existe: $target"
    Write-Host "Usa -Force para sobrescribirla." -ForegroundColor Yellow
} else {
    [System.IO.File]::WriteAllText($target, $text, $utf8NoBom)
    Write-Host "Creada: $folder/$fileName.md" -ForegroundColor Green
}

# --- Refresh indexes --------------------------------------------------------
$indexScript = Join-Path $scriptsDir 'actualizar-indices.ps1'
if (Test-Path -LiteralPath $indexScript) {
    & $indexScript
}

# --- Open in Obsidian -------------------------------------------------------
if ($Abrir) {
    $vault = [uri]::EscapeDataString((Split-Path -Leaf $root))
    $fileParam = (($folder -split '/' | ForEach-Object {
        [uri]::EscapeDataString($_)
    }) -join '/') + '/' + [uri]::EscapeDataString($fileName)
    Start-Process "obsidian://open?vault=$vault&file=$fileParam"
}
