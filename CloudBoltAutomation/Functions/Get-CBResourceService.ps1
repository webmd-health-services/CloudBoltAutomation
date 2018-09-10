 
function Get-CBResourceService
{
    <#
    .SYNOPSIS
    Gets service resources from CloudBolt.

    .DESCRIPTION
    The `Get-CBResourceService` function gets service resources from CloudBolt. Pass the session for the target CloudBolt instance to the `Session` parameter (use `New-CBSession` to create a session). All service resources are returned. CloudBolt pages result sets, and the `Get-CBResourceService` function makes one request per page of results. You can control how many environments to include in each page with the `PageSize` parameter. The default is 100, CloudBolt's maximum page size. When getting all services, CloudBolt only returns each service's name and ID.

    `Get-CBResourceService` can also return a specific service. Pass its ID to the `ID` parameter. You can also pipe service objects (any object with an `ID` property) or IDs to `Get-CBResourceService`. When getting a specific service, CloudBolt returns all information about the service.

    .EXAMPLE
    Get-CBResourceService -Session $session

    Demonstrates how to get all service resources from CloudBolt. When getting all services, CloudBolt only returns each service's ID and name.

    .EXAMPLE
    Get-CBResourceService -Session $session -PageSize 25

    Demonstrates how to change the number of results per page/request to the CloudBolt API. The larger the number, the greater the strain on CloudBolt but the fewer requests will be made. The default is 100, CloudBolt's maximum allowed page size.

    .EXAMPLE
    Get-CBResourceService -Session $session -ID 1

    Demonstrates how to get a specific service resource from CloudBolt.

    .EXAMPLE
    $environments | Get-CBResourceService -Session $session

    Demonstrates that you can pipe environment objects to `Get-CBResourceService`. Each object must have an `ID` property.

    .EXAMPLE
    @( 1, 2, 3) | Get-CBResourceService -Session $session

    Demonstrates that you can pipe IDS to `Get-CBResourceService`.
    #>
    [CmdletBinding(DefaultParameterSetName='All')]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session to the CloudBolt instance to connect to and use.
        $Session,

        [Parameter(Mandatory,ParameterSetName='ById',ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [int]
        # The ID of the service resource to get.
        $ID,

        [Parameter(ParameterSetName='All')]
        [int]
        # The page size. CloudBolt pages all lists of objects. The `Get-CBResourceService` function will make an HTTP request for every page of results so that all service resources get returned. The default page size is 100, CloudBolt's maximum allowed page size.
        $PageSize = $defaultPageSize
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        & {
            if( $PSCmdlet.ParameterSetName -eq 'ById' )
            {
                Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath ('resources/service/{0}/' -f $ID)
            }
            else
            {
                Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath 'resources/service/' -IsPaged -PageSize $PageSize
            }
        } | Add-CBTypeName -ResourceService -PassThru
    }
}