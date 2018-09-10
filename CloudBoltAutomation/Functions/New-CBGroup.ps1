
function New-CBGroup
{
    <#
    .SYNOPSIS
    Creates a new group in CloudBolt.

    .DESCRIPTION
    The `New-CBGroup` function creates a new group in CloudBolt. Pass a session object to the CloudBolt instance to use to the `Session` parameter (use `New-CBSession` to create a session object). Pass the name of the group to the `Name` parameter. Pass the group's type to the `Type` parameter. An group object will be returned.

    .EXAMPLE
    New-CBGroup -Session $session -Name 'Fubar Snafu' -Type 'Organization'

    Demonstrates how to use `New-CBGroup` to create a new group in CloudBolt.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
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
    Write-Verbose -Message ('Creating group "{0}".' -f $Name)
    Invoke-CBRestMethod -Session $Session -Method Post -ResourcePath 'groups/' -Body ($group | ConvertTo-Json) |
        Add-CBTypeName -Group -PassThru
}