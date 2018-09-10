
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

$session = New-CBTestSession

# If this test fails, please manually add two environments: CBAutomation1 and CBAutomation2. The CloudBolt API fails when I try to create new environments.
Describe 'Get-CBEnvironment.when getting all environments' {
    $environment = Get-CBEnvironment -Session $session
    It ('should return environments') {
        $environment | Should -Not -BeNullOrEmpty
        $environment | Should -HaveCount 3
    }
    $environment | ThenCBObjectHasType -ForEnvironment
}

Describe 'Get-CBEnvironment.when getting a specific environment' {
    $environment = Get-CBEnvironment -Session $session -ID 1
    It ('should return the environment') {
        $environment | Should -Not -BeNullOrEmpty
        $environment.name | Should -Be 'Unassigned'
    }
    $environment | ThenCBObjectHasType -ForEnvironment
}

Describe 'Get-CBEnvironment.when piping an environment object' {
    $environment = Get-CBEnvironment -Session $session | Get-CBEnvironment -Session $session
    It ('should return the environments') {
        $environment | Should -Not -BeNullOrEmpty
        $environment | Should -HaveCount 3
    }
    $environment | ThenCBObjectHasType -ForEnvironment
}

Describe 'Get-CBEnvironment.when piping IDs' {
    $environment = Get-CBEnvironment -Session $session | Select-Object -ExpandProperty 'ID' | Get-CBEnvironment -Session $session
    It ('should return the environments') {
        $environment | Should -Not -BeNullOrEmpty
        $environment | Should -HaveCount 3
    }
    $environment | ThenCBObjectHasType -ForEnvironment
}