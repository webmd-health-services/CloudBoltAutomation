
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

Describe 'New-CBSession' {
    $session = New-CBSession -Uri $CBBaseUri -Credential $CBCredential
    It ('should return a session object') {
        $session | Should -BeOfType ([PSCustomObject])
        $session | Get-Member -Name 'Token' | Should -Not -BeNullOrEmpty
        $session | Get-Member -Name 'Uri' | Should -Not -BeNullOrEmpty
    }

    It ('should set CloudBolt URI in session') {
        $session.Uri | Should -Be $CBBaseUri
    }
}

Describe 'New-CBSession.when authenticating against a domain' {
    Mock -CommandName 'Invoke-RestMethod' -ModuleName 'CloudBoltAutomation' -MockWith { [pscustomobject]@{ token = 'fizzbuzz' } }
    New-CBSession -Uri $CBBaseUri -Credential $CBCredential -Domain 'fubarsnafu'
    It ('should pass domain to token API') {
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -ModuleName 'CloudBoltAutomation' -Times 1 -ParameterFilter { ($Body | ConvertFrom-Json).domain -eq 'fubarsnafu' }
    }
}