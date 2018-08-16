
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

$session = New-CBTestSession

Describe 'Remove-CBGroup.when piping group object' {
    $group = GivenCBGroup -Exists
    $group | Remove-CBGroup -Session $session
    It ('should remove group') {
        Get-CBGroup -Session $session -ID $group.id -ErrorAction Ignore | Should -BeNullOrEmpty
    }
}

Describe 'Remove-CBGroup.when piping multiple objects' {
    $group = GivenCBGroup -Exists -Count 5
    $group | Remove-CBGroup -Session $session
    It ('should remove groups') {
        foreach( $item in $group )
        {
            Get-CBGroup -Session $session -ID $item.id -ErrorAction Ignore | Should -BeNullOrEmpty
        }
    }
}

Describe 'Remove-CBGroup.when piping group ID' {
    $group = GivenCBGroup -Exists
    $group.id | Remove-CBGroup -Session $session
    It ('should remove group') {
        Get-CBGroup -Session $session -ID $group.id -ErrorAction Ignore | Should -BeNullOrEmpty
    }
}

Describe 'Remove-CBGroup.when using WhatIf' {
    $group = GivenCBGroup -Exists
    Remove-CBGroup -Session $session -ID $group.id -WhatIf
    It ('should not remove group') {
        Get-CBGroup -Session $session -ID $group.id | Should -Not -BeNullOrEmpty
    }
}

Describe 'Remove-CBGroup.when group does not exist' {
    $Global:Error.Clear()
    Remove-CBGroup -Session $session -ID ([int]::MaxValue) -ErrorAction SilentlyContinue
    It ('should write an error') {
        $Global:Error[0] | Should -Match 'Not found'
    }
}

Describe 'Remove-CBGroup.when group does not exist and ignoring errors' {
    $Global:Error.Clear()
    Remove-CBGroup -Session $session -ID ([int]::MaxValue) -ErrorAction Ignore
    It ('should write no error') {
        $Global:Error.Count | Should -Be 1
    }
}