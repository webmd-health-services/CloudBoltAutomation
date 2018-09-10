

function New-CBSession
{
    <#
    .SYNOPSIS
    Creates a connection to CloudBolt instance.

    .DESCRIPTION
    The `New-CBSession` function creates a connection to a CloudBolt instance. Pass the URI to the instance to the `Uri` parameter. Pass the credentials to use to authenticate to the `Credential` parameter. 

    The function generates a token for further access to the CloudBolt API using the credentials by making a request to the `/api/v2/api-token-auth` endpoint.

    If your instance of CloudBolt authenticates against a domain, pass the domain to the `Domain` parameter.

    .EXAMPLE
    New-CBSession -Uri 'https://cloudbolt.example.com' -Credential $me

    Demonstrates how to connect to an instance of CloudBolt. In this case, the connection is to the instance at `https://cloudbolt.example.com` using the credentials in the `$me` variable.

    .EXAMPLE
    New-CBSession -Uri 'https://cloudbolt.example.com' -Credential $me -Domain 'CB'

    Demonstrates how to connect to an instance of CloudBolt and the credential is in a specific domain. In this case, the credential is in the `CB` domain.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [uri]
        # The URI to the CloudBolt instance to connect to.
        $Uri,

        [Parameter(Mandatory)]
        [pscredential]
        # The credentials to use.
        $Credential,

        [string]
        # The domain to use.
        $Domain
    )

    Set-StrictMode -Version 'Latest'

    $apiUri = New-Object -TypeName 'Uri' -ArgumentList @($Uri,'/api/v2/')

    $tokenUri = New-Object -TypeName 'Uri' -ArgumentList @($apiUri,'api-token-auth/')
    $body = @{
                                username = $Credential.UserName;
                                password = $Credential.GetNetworkCredential().Password
        }
    if( $Domain )
    {
        $body['domain'] = $Domain
    }

    $body = ConvertTo-Json -InputObject $body
    $result = Invoke-RestMethod -Method Post -Uri $tokenUri -UseBasicParsing -Body $body -ContentType 'application/json'
    return [pscustomobject]@{ Token = $result.token; Uri = $apiUri }
}