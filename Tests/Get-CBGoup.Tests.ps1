
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

$session = New-CBTestSession

Describe 'Get-CBGroup.when getting all groups' {
    $group = Get-CBGroup -Session $session
    It ('should return all groups') {
        $group | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-CBGroup.when getting a specific group' {
    $group = Get-CBGroup -Session $session -ID 1
    It ('should return group') {
        $group.id | Should -Be 1
        $group.name | Should -Be 'Unassigned'
    }
}
