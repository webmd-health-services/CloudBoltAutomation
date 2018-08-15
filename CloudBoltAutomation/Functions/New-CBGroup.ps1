
function New-CBGroup
{
    <#
    .SYNOPSIS
    Creates a new group in CloudBolt.

    .DESCRIPTION
    The `New-CBGroup` function creates a new group in CloudBolt.

    .EXAMPLE
    

    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session for/connection to CloudBolt. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory)]
        [string]
        # The group's type.
        $Name,

        [Parameter(Mandatory)]
        [string]
        # The group's type.
        $Type
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $group = [pscustomobject]@{
                                    name = $Name;
                                    type = $Type
                                }
    Invoke-CBRestMethod -Session $Session -Method Post -ResourcePath 'groups/' -Body ($group | ConvertTo-Json) |
        Add-CBTypeName -Group -PassThru
}