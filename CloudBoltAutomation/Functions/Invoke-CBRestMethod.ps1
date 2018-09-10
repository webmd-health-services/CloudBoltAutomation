
function Invoke-CBRestMethod
{
    <#
    .SYNOPSIS
    Calls a method in the CloudBolt REST API.

    .DESCRIPTION
    The `Invoke-CBRestMethod` function calls a method in the CloudBolt REST API. Pass a session/connection object to the `Session` parameter (use `New-CBSession` to create a session object), the HTTP method to use to the `Method` parameter, the relative path to the endpoint to the `ResourcePath` parameter (i.e. everything after `api/v2/` in the endpoint's path), and the body of the request (if any) to the `Body` parameter. A result object is returned, which is different for each endpoint.

    Any endpoint that returns a list of objects is paged. Use the `IsPaged` parameter to tell `Invoke-CBRestMethod` that the results are paged and to page through and return all objects. For each page of results, this function will call the API to return that page. You can control how big the page size is with the `PageSize` parameter. The default is `10`. The maximum value is `100`. If you pass a value bigger than `100`, CloudBolt will still only return 100 results per page.

    .EXAMPLE
    Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath ('orders/{0}/' -f $ID) 

    Demonstrates how to use `Invoke-CBRestMethod` to call an endpoint that returns a single object. In this case, a specific order.

    .EXAMPLE
    Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath 'groups/' -IsPaged -PageSize 100

    Demonstrates how to use `Invoke-CBRestMethod` to call a paged/list endpoint. In this case, `Invoke-CBRestMethod` will return all groups in CloudBolt. It will make a request for each page of results so that all groups are returned.
    #>
    [CmdletBinding(DefaultParameterSetName='NonPaged',SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        # The HTTP method to use for the request.
        $Method,

        [Parameter(Mandatory)]
        [string]
        # The relative path to the endpoint to request. This is the part of the URI after `api/v2/`. It usually needs to end with a `/`.
        $ResourcePath,

        [Parameter(ParameterSetName='NonPaged')]
        [string]
        # The body of the request.
        $Body,

        [Parameter(Mandatory,ParameterSetName='Paged')]
        [Switch]
        # Is the API endpoint paged or not? If this switch is `true`, the `Invoke-CBRestMethod` function will treat the results as paged and will make a web request for each page of results and return all objects. Use the `PageSize` function to control how many results to return in each page (i.e. to increase or decrease the number of HTTP requests to make).
        $IsPaged,

        [Parameter(ParameterSetName='Paged')]
        [int]
        # How many results to return in each page. The default is `10`. The maximum value is `100`. If you pass a value greater than `100`, CloudBolt will still only return `100` results per page.
        $PageSize = $defaultPageSize
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    $queryString = & {
                        if( $IsPaged -and $PageSize )
                        {
                            'page_size={0}' -f $PageSize
                        }
                    }

    if( $queryString )
    {
        $queryString = $queryString -join '&'
    }

    $relativeUri = $ResourcePath
    if( $queryString )
    {
        $relativeUri = '{0}?{1}' -f $relativeUri,$queryString
    }
    $uri = New-Object 'Uri' -ArgumentList $Session.Uri,$relativeUri
    $contentType = 'application/json'

    #$DebugPreference = 'Continue'
    $authHeaderValue = 'Bearer {0}' -f $Session.Token
    $headers = @{ 'Authorization' = $authHeaderValue }

    try
    {

        if( $Body )
        {
            $Body | Write-Debug
        }

        if( $Method -eq [Microsoft.PowerShell.Commands.WebRequestMethod]::Get -or $PSCmdlet.ShouldProcess($uri,$Method) )
        {
            if( $PSCmdlet.ParameterSetName -eq 'Paged' )
            {
                while( $true )
                {
                    $result = Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -ContentType $contentType
                    $result | Select-Object -ExpandProperty '_embedded'
                    if( -not ($result._links | Get-Member -Name 'next') )
                    {
                        break
                    }
                    # The URI returned needs to end with a '/' otherwise it fails.
                    $nextPage = $result._links.next.href -replace '\?','/?'
                    if( $PageSize )
                    {
                        $nextPage = '{0}&page_size={1}' -f $nextPage,$PageSize
                    }
                    $uri = New-Object -TypeName 'Uri' -ArgumentList @($uri,$nextPage)
                }
                return
            }

            $bodyParam = @{ }
            if( $Body )
            {
                $bodyParam['Body'] = $Body
            }

            Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -ContentType $contentType @bodyParam |
                Where-Object { $_ }
        }
    }
    catch [Net.WebException]
    {
        Write-Error -ErrorRecord $_ -ErrorAction $ErrorActionPreference
    }
}
