
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

$session = New-CBTestSession

Describe 'New-CBGroup' {
    $group = New-CBGroup -Session $session -Name 'CBAutomation.New-CBGroup.1' -Type 'Organization'
    It ('should return the group') {
        $group | Should -Not -BeNullOrEmpty
        ($group | Measure-Object).Count | Should -Be 1
        $group.name | Should -Be 'CBAutomation.New-CBGroup.1'
        $group.type | Should -Be 'Organization'
    }

    It ('should create the group') {
        $newGroup = Get-CBGroup -Session $session -ID $group.id
        $newGroup | Should -Not -BeNullOrEmpty
    }

    ThenCBObjectHasType -ForGroup $group
}