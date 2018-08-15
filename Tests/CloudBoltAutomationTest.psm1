
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
