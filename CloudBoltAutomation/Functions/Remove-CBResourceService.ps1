
function Remove-CBResourceService
{
    <#
    .SYNOPSIS
    Removes a service resource from CloudBolt.

    .DESCRIPTION
    The `Remove-CBResourceService` function removes a service resource from CloudBolt. Pass the session to the targeted CloudBolt instance to the `Session` parameter (use `New-CBSession` to create a session). Pass the ID of the service to the `ID` parameter. You can also pipe the ID to this function, or pipe an object with an ID property.

    .EXAMPLE
    Remove-CBResourceService -Session $session -ID 54
    
    Demonstrates how to remove a service resource using its ID.
    
    .EXAMPLE
    Get-CBResourceService -Session $session -ID 65 | Remove-CBResourceService -Session $session    

    Demonstrates how you can pipe service resource objects to `Remove-CBResourceService`.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session to the CloudBolt instance to use.
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

        Invoke-CBRestMethod -Session $Session -Method Delete -ResourcePath ('resources/service/{0}/' -f $ID)
    }
}
