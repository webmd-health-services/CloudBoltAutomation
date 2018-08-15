
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

$session = New-CBTestSession

function GivenGroups
{
    param(
        $Count
    )

    for( $num = 1; $num -lt $Count ; $num++ )
    {
        if( -not (Get-CBGroup -Session $session -ID $num) )
        {
            $name = 'CBAutomation.Get-CBGroup.{0}' -f $num
            New-CBGroup -Session $session -Name $name -Type 'Organization'
        }
    }
}

Describe 'Get-CBGroup.when getting all groups' {
    GivenGroups 2
    $group = Get-CBGroup -Session $session

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

Describe 'Get-CBGroup.when paging results' {
    # Default page size is 10.
    GivenGroups 21

    $groups = Get-CBGroup -Session $session
    It ('should return all the groups') {
        ($groups | Measure-Object).Count | Should -BeGreaterOrEqual 21
    }
}

Describe 'Get-CBGroup.when passing group object via pipline' {
    GivenGroups 1
    $group = Get-CBGroup -Session $session -ID 1 | Get-CBGroup -Session $session
    It ('should return group') {
        $group | Should -Not -BeNullOrEmpty
        $group.id | Should -Be 1
    }
}


Describe 'Get-CBGroup.when passing group ID object via pipline' {
    GivenGroups 1
    $group = 1 | Get-CBGroup -Session $session
    It ('should return group') {
        $group | Should -Not -BeNullOrEmpty
        $group.id | Should -Be 1
    }
}