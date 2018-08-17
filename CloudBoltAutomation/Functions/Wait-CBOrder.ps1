function Wait-CBorder
{
    <#
    .SYNOPSIS
    Waits for a CloudBolt order to complete.
    
    .DESCRIPTION
    The `Wait-CBOrder` function waits for a CloudBolt order to complete. Pass the session to the target CloudBolt instance to the `Session` parameter (use `New-CBSession` to create a session object). Pass the ID of the order to the `ID` parameter. You can also pipe order objects or IDs to `Wait-CBOrder`.

    By default, will wait for two minutes for the job to complete, checking the status every second. 
    

    .EXAMPLE
    

    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session to the CloudBolt instance to connect to and use.
        $Session,

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ById')]
        [int]
        # The job's ID.
        $ID,

        [timespan]
        # The total amount of time to wait for the order to complete. The default value is 100 seconds. If the order doesn't complete, the function returns nothing.
        $Timeout = [timespan]'00:01:40',

        [timespan]
        # The amount of time to wait between checking the order's status. The default is one second.
        $RetryInterval = [timespan]'00:00:01'
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $endAt = (Get-Date) + $Timeout

        if( $Timeout -eq [TimeSpan]::Zero )
        {
            $endAt = [DateTime]::MaxValue
        }

        $order = $null

        while( $true )
        {
            $order = Get-CBOrder -Session $Session -ID $ID
            if( $order.status -in @( 'SUCCESS', 'FAILURE' ) )
            {
                break
            }

            if( (Get-Date) -gt $endAt )
            {
                Write-Verbose -Message ('Order "{0}" ({1}) hasn''t completed in {2} seconds.' -f $order.name,$order.id,$Timeout.TotalSeconds)
                return
            }

            Write-Verbose ('Status of order "{0}" ({1}) is "{2}". Sleeping {3} seconds.' -f $order.name,$order.id,$order.status,$RetryInterval.Seconds)
            Start-Sleep -Seconds $RetryInterval.TotalSeconds
        }

        return $order
    }
}