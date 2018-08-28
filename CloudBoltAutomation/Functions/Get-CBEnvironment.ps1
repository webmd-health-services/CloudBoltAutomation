 
function Get-CBEnvironment
{
    <#
    .SYNOPSIS
    Gets environments from CloudBolt.

    .DESCRIPTION
    The `Get-CBEnvironment` function gets environments from CloudBolt. Pass the session for the target CloudBolt instance to the `Session` parameter (use `New-CBSession` to create a session). All environments are returned. CloudBolt pages result sets, and the `Get-CBEnvironment` function makes one request per page of results. You can control how many environments to include in each page with the `PageSize` parameter. The default is CloudBolt's default page size. When getting all environments, CloudBolt only returns the environment's name and ID.

    `Get-CBEnvironment` can also return a specific environment. Pass its ID to the `ID` parameter. You can also pipe environment objects (any object with an `ID` property) or IDs to `Get-CBEnvironment`. When getting a specific environment, CloudBolt returns all information about an environment.

    .EXAMPLE
    Get-CBEnvironment -Session $session

    Demonstrates how to get all environments from CloudBolt. When getting all environments, CloudBolt only returns each environment's ID and name.

    .EXAMPLE
    Get-CBEnvironment -Session $session -PageSize ([int16]::MaxValue)

    Demonstrates how to increase the number of results per page/request to the CloudBolt API. The larger the number, the greater the strain on CloudBolt but the fewer requests will be made.

    .EXAMPLE
    Get-CBEnvironment -Session $session -ID 1

    Demonstrates how to get a specific environment from CloudBolt.

    .EXAMPLE
    $environments | Get-CBEnvironment -Session $session

    Demonstrates that you can pipe environment objects to `Get-CBEnvironment`. Each object must have an `ID` property.

    .EXAMPLE
    @( 1, 2, 3) | Get-CBEnvironment -Session $session

    Demonstrates that you can pipe IDS to `Get-CBEnvironment`.
    #>
    [CmdletBinding(DefaultParameterSetName='All')]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory,ParameterSetName='ById',ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [int]
        # The ID of the environment to get.
        $ID,

        [Parameter(ParameterSetName='All')]
        [int]
        # The page size. CloudBolt pages all lists of objects. The `Get-CBEnvironment` function will make an HTTP request for every page of results so that all environments get returned. The default page size is 10.
        $PageSize
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        & {
            if( $PSCmdlet.ParameterSetName -eq 'ById' )
            {
                Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath ('environments/{0}/' -f $ID)
            }
            else
            {
                Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath 'environments/' -IsPaged -PageSize $PageSize
            }
        } | Add-CBTypeName -Environment -PassThru
    }
}