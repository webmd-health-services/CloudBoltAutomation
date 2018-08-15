
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

function ThenHasType
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