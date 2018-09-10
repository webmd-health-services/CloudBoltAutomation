
function Get-CBGroup
{
    <#
    .SYNOPSIS
    Gets CloudBolt groups.

    .DESCRIPTION
    The `Get-CBGroup` function gets all groups from a CloudBolt instance. To get a specific group, pass its ID to the `ID` parameter.

    By default, CloudBolt pages the list of groups. This function automatically handles the paging for you and returns all group. You can control how big each page is with the `PageSize` parameter. `Get-CBGroup` will make as many HTTP requests as there are pages (i.e. it will return all groups).

    .EXAMPLE
    Get-CBGroup -Session $session

    Demonstrates how to get all groups from CloudBolt.

    .EXAMPLE
    Get-CBGroup -Session $session -PageSize ([int16]::MaxValue)

    Demonstrates how to increase the number of results per request to the CloudBolt API. The larger the number, the greater the strain on CloudBolt but the fewer HTTP requests will be made.

    .EXAMPLE
    Get-CBGroup -Session $session -ID 1

    Demonstrates how to get a specific group from CloudBolt.
    #>
    [CmdletBinding(DefaultParameterSetName='AllGroups')]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory,ParameterSetName='SpecificGroup',ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [int]
        # The ID of the group to get.
        $ID,

        [Parameter(ParameterSetName='AllGroups')]
        [int]
        # The page size. CloudBolt pages all lists of objects. The `Get-CBEnvironment` function will make an HTTP request for every page of results so that all environments get returned. The default page size is 10.
        $PageSize = $defaultPageSize
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    & {
        if( $PSCmdlet.ParameterSetName -eq 'AllGroups' )
        {
            Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath 'groups/' -IsPaged -PageSize $PageSize
        }
        else
        {
            Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath ('groups/{0}/' -f $ID)
        }
    } | Add-CBTypeName -Group -PassThru
}