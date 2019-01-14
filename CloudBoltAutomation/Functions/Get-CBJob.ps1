function Get-CBJob
{
    <#
    .SYNOPSIS
    Gets a job from CloudBolt.

    .DESCRIPTION
    The `Get-CBJob` function gets a job from CloudBolt. Pass a session to the target CloudBolt instance to the `Session` parameter (use `New-CBSession` to get a session object) and the ID of the job to the `ID` parameter.

    .EXAMPLE
    GEt-CBJob -Session $session -ID 54

    Demonstrates how to get a specific job usng its ID.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session/connecton to the CloudBolt instance to use. Use `New-CBSession` to create a session object.
        $Session,

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ById')]
        [int]
        # The job's ID.
        $ID,

        [Parameter(Mandatory,ParameterSetName='ByOrder')]
        [int]
        # The order ID that created the job.
        $OrderID,

        [Switch]
        # Also get any sub-jobs in each job.
        $Recurse
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $jobIDInHrefRegex = '\b(\d+)/?$'

        & {
                if( $ID )
                {
                    Invoke-CBRestMethod -Session $Session -Method Get -ResourcePath ('jobs/{0}/' -f $ID) 
                }
                elseif( $OrderID )
                {
                    $order = Get-CBOrder -Session $Session -ID $OrderID
                    $order._links.jobs | 
                        Select-Object -ExpandProperty 'href' |
                        Where-Object { $_ -match $jobIDInHrefRegex } |
                        ForEach-Object { $Matches[1] } |
                        Get-CBJob -Session $Session
                }
        }  |
        ForEach-Object {
            $_
            if( $Recurse )
            {
                $_._links.subjobs |
                    Select-Object -ExpandProperty 'href' |
                    Where-Object { $_ -match $jobIDInHrefRegex } |
                    ForEach-Object { $Matches[1] } |
                    Get-CBJob -Session $Session -Recurse
            }
        } | 
        Add-CBTypeName -Job -PassThru
    }
}