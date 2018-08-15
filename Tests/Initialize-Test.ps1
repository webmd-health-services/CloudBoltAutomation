
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\CloudBoltAutomation' -Resolve) -Force

$global:CBBaseUri = 'http://127.0.0.1:8080/'
$global:CBCredential = New-Object -TypeName 'pscredential' -ArgumentList @('admin',(ConvertTo-SecureString -String 'admin' -AsPlainText -Force))
