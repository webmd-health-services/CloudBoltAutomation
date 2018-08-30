
$defaultPageSize = 100

& {
    Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Functions\*.ps1')
} | ForEach-Object { . $_.FullName }