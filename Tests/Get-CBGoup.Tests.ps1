
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

$session = New-CBTestSession

Describe 'Get-CBGroup.when getting all groups' {
    $group = Get-CBGroup -Session $session
    if( ($group | Measure-Object).Count -le 1 )
    {
        for( $num = 1; $num++; $num -le 2 )
        {
            New-CBGroup -Session $session -Name ('CBAutomation.Get-CBGroup.{0}' -f $num) -Type 'Organization'
        }
        $group = Get-CBGroup -Session $session
    }

    It ('should return all groups') {
        $group | Should -Not -BeNullOrEmpty
        ($group | Measure-Object).Count | Should -BeGreaterThan 1
    }
    
    foreach( $item in $group )
    {
        ThenHasType -ForGroup $item
    }
}

Describe 'Get-CBGroup.when getting a specific group' {
    $group = Get-CBGroup -Session $session -ID 1
    It ('should return the group') {
        $group.id | Should -Be 1
        $group.name | Should -Be 'Unassigned'
        $group | Should -HaveCount 1
    }
    ThenHasType -ForGroup $group
}
