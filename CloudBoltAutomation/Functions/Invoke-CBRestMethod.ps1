# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function Invoke-CBRestMethod
{
    <#
    .SYNOPSIS
    Calls a method in the CloudBolt REST API.

    .DESCRIPTION
    The `Invoke-CBRestMethod` function calls a method on the Bitbucket Server REST API. You pass it a Connection object (returned from `New-BBServerConnection`), the HTTP method to use, the name of API (via the `ApiName` parametr), the name/path of the resource via the `ResourcePath` parameter, and a hashtable/object/psobject via the `InputObject` parameter representing the data to send in the body of the request. The data is converted to JSON and sent in the body of the request.

    A Bitbucket Server URI has the form `https://example.com/rest/API_NAME/API_VERSION/RESOURCE_PATH`. `API_VERSION` is taken from the connection object passed to the `Connection` parameter. The `API_NAME` path should be passed to the `ApiName` paramter. The `RESOURCE_PATH` path should be passed to the `ResourcePath` parameter. The base URI is taken from the `Uri` property of the connection object passed to the `Connection` parameter.

    .EXAMPLE
    $body | Invoke-BBServerRestMethod -Connection $Connection -Method Post -ApiName 'build-status' -ResourcePath ('commits/{0}' -f $commitID)

    Demonstrates how to call the /build-status API's `/commits/COMMIT_ID` resource. Body is a hashtable that looks like this:

        $body = @{
                    state = 'INPROGRESS';
                    key = 'MY_BUILD_KEY';
                    name = 'MY_BUILD_NAME';
                    url = 'MY_BUILD_URL';
                    description = 'MY_BUILD_DESCRIPTION';
                 }
        
    #>
    [CmdletBinding(DefaultParameterSetName='NonPaged')]
    param(
        [Parameter(Mandatory)]
        [object]
        # The connection to use to invoke the REST method.
        $Session,

        [Parameter(Mandatory)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method,

        [Parameter(Mandatory)]
        [string]
        # The path to the resource to use. If the endpoint URI `http://example.com/rest/build-status/1.0/commits`, the ResourcePath is everything after the API version. In this case, the resource path is `commits`.
        $ResourcePath,

        [Parameter(ParameterSetName='NonPaged')]
        [string]
        $Body,

        [Parameter(Mandatory,ParameterSetName='Paged')]
        [Switch]
        $IsPaged,

        [Parameter(ParameterSetName='Paged')]
        [int]
        $PageSize
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

    $uri = New-Object 'Uri' -ArgumentList $Session.Uri,('{0}?{1}' -f $ResourcePath,$queryString)
    $contentType = 'application/json'

    #$DebugPreference = 'Continue'
    $authHeaderValue = 'Bearer {0}' -f $Session.Token
    $headers = @{ 'Authorization' = $authHeaderValue }

    try
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

        Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -ContentType $contentType @bodyParam

    }
    catch [Net.WebException]
    {
        Write-Error -ErrorRecord $_
    }
}
