    
function Get-CBOrder
{
    <#
    .SYNOPSIS
    Gets an order from CloudBolt.

    .DESCRIPTION
    The `Get-CBOrder` function gets an order from CloudBolt. Pass the session to the target CloudBolt instance to the `Session` parameter. Pass the ID of the order to the `ID` parameter. You can also pipe order objects or order IDs to the `Get-CBOrder`. Order objects must have an `ID` property.

    Use the `New-CBSession` function to create a session object.

    .EXAMPLE
    Get-CBOrder -Session $session -ID 54

    Demonstrates how to get a specific order by passing its ID to the `ID` parameter.

    .EXAMPLE
    $order | Get-CBOrder -Session $session

    Demonstrates how to get a specific order by piping an order object to `Get-CBOrder`.

    .EXAMPLE
    65 | Get-CBOrder -Session $session

    Demonstrates how to get a specific order by piping the order's id to `Get-CBOrder`.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [object]
        # The order's ID.
        $ID
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath ('orders/{0}/' -f $ID) |
            Add-CBTypeName -Order -PassThru
    }
}