function Remove-CBGroup
{
    <#
    .SYNOPSIS
    Removes a group from CloudBolt.

    .DESCRIPTION
    The `Remove-CBGroup` function removes a group from CloudBolt. Pass the session to the targeted CloudBolt instance to the `Session` parameter (use `New-CBSession` to create a session). Pass the ID of the group to the `ID` parameter. You can also pipe the ID to this function, or pipe an object with an ID property.

    .EXAMPLE
    Remove-CBGroup -Session $session -ID 54
    
    Demonstrates how to remove a group using its ID.
    
    .EXAMPLE
    Get-CBGroup -Session $session -ID 65 | Remove-CBGroup -Session $session    

    Demonstrates how you can pipe group objects to `Remove-CBGroup`.

    .EXAMPLE
    Remove-CBGroup -Session $session -ID 49 -WhatIf

    Demonstrates that the `Remove-CBGroup` function supports the `-WhatIf` switch.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [int]
        # The ID of the group to remove.
        $ID
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        Invoke-CBRestMethod -Session $Session -Method Delete -ResourcePath ('groups/{0}/' -f $ID)
    }
}