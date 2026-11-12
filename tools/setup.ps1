$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$toolRoot = Join-Path $projectRoot '.tools'
New-Item -ItemType Directory -Path $toolRoot -Force | Out-Null

if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
    throw 'This setup script targets Windows x64. Install Rojo 7.7.1 and StyLua 2.6.0 for your architecture manually.'
}

$releases = @(
    @{ Name = 'rojo'; Url = 'https://github.com/rojo-rbx/rojo/releases/download/v7.7.1/rojo-7.7.1-windows-x86_64.zip' },
    @{ Name = 'stylua'; Url = 'https://github.com/JohnnyMorganz/StyLua/releases/download/v2.6.0/stylua-windows-x86_64.zip' }
)

foreach ($release in $releases) {
    $archive = Join-Path $toolRoot ($release.Name + '.zip')
    $destination = Join-Path $toolRoot $release.Name
    Write-Host ('Installing pinned ' + $release.Name + ' from its official GitHub release...')
    Invoke-WebRequest -Uri $release.Url -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $destination -Force
}

Write-Host 'Tools installed locally. Run tools/check.ps1 to validate and build.'
