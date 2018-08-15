
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

Describe 'New-CBSession' {
    $session = New-CBTestSession
    It ('should return a session object') {
        $session | Should -BeOfType ([PSCustomObject])
        $session | Get-Member -Name 'Token' | Should -Not -BeNullOrEmpty
        $session | Get-Member -Name 'Uri' | Should -Not -BeNullOrEmpty
    }

    It ('should set CloudBolt URI in session') {
        ([uri]$session.Uri).PathAndQuery | Should -Be ('/api/v2/')
    }
}

Describe 'New-CBSession.when authenticating against a domain' {
    Mock -CommandName 'Invoke-RestMethod' -ModuleName 'CloudBoltAutomation' -MockWith { [pscustomobject]@{ token = 'fizzbuzz' } }
    New-CBTestSession -Domain 'fubarsnafu'
    It ('should pass domain to token API') {
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -ModuleName 'CloudBoltAutomation' -Times 1 -ParameterFilter { ($Body | ConvertFrom-Json).domain -eq 'fubarsnafu' }
    }
}