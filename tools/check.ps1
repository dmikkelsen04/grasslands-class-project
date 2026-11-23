$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$stylua = Join-Path $projectRoot '.tools/stylua/stylua.exe'
$rojo = Join-Path $projectRoot '.tools/rojo/rojo.exe'

if (!(Test-Path -LiteralPath $stylua) -or !(Test-Path -LiteralPath $rojo)) {
    throw 'Missing tools. Run tools/setup.ps1 first.'
}

Push-Location $projectRoot
try {
    & $stylua --check src tools tests
    if ($LASTEXITCODE -ne 0) { throw 'Luau format/syntax check failed.' }
    New-Item -ItemType Directory -Path 'build' -Force | Out-Null
    & $rojo build default.project.json --output build/grasslands.rbxlx
    if ($LASTEXITCODE -ne 0) { throw 'Rojo build failed.' }
    Write-Host 'Build and format passed. Open build/grasslands.rbxlx in Roblox Studio.'
} finally {
    Pop-Location
}
