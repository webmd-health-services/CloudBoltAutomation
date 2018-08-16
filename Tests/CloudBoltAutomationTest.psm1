
function GivenCBGroup
{
    param(
        [int]
        $Count = 1,

        [Switch]
        $Exists
    )

    $session = New-CBTestSession

    for( $num = 1; $num -le $Count; ++$num )
    {
        New-CBGroup -Session $session -Name ('CBAutomation.Group.{0}' -f [Guid]::NewGuid()) -Type 'Organization'
    }
}

function New-CBTestSession
{
    param(
        $Domain
    )

    $baseUri = 'http://127.0.0.1:8080/'
    $credential = New-Object -TypeName 'pscredential' -ArgumentList @('admin',(ConvertTo-SecureString -String 'admin' -AsPlainText -Force))

    $domainParam = @{ }
    if( $Domain )
    {
        $domainParam['Domain'] = $Domain
    }

    return New-CBSession -Uri $baseUri -Credential $credential @domainParam
}

function ThenCBObjectHasType
{
    param(
        [Parameter(Mandatory,Position=0)]
        [object]
        $InputObject,

        [Parameter(Mandatory,ParameterSetName='CloudBolt.Management.Automation.Group')]
        [Switch]
        $ForGroup
    )

    It ('should have the right type') {
        $InputObject.psobject.TypeNames.Contains($PSCmdlet.ParameterSetName) | Should -BeTrue
    }
}