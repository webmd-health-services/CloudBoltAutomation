
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\CloudBoltAutomation' -Resolve) -Force
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'CloudBoltAutomationTest.psm1' -Resolve) -Force
