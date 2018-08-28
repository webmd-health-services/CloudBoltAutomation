function Wait-CBorder
{
    <#
    .SYNOPSIS
    Waits for a CloudBolt order to complete.
    
    .DESCRIPTION
    The `Wait-CBOrder` function waits for a CloudBolt order to complete. Pass the session to the target CloudBolt instance to the `Session` parameter (use `New-CBSession` to create a session object). Pass the ID of the order to the `ID` parameter. You can also pipe order objects or IDs to `Wait-CBOrder`.

    By default, will wait 100 seconds for the job to complete, checking the status every second. 
    

    .EXAMPLE
    Start-CBOrder -Session $session -GroupID 4398 -BlueprintID 383 | Wait-CBOrder -Session $session

    Demonstrates how to pipe an object from `Start-CBOrder` to `Wait-CBOrder`, which will wait until the order completes or the wait times out.
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

        [timespan]
        # The total amount of time to wait for the order to complete. The default value is 100 seconds. If the order doesn't complete, the function returns nothing.
        $Timeout = (New-TimeSpan -Seconds 100),

        [timespan]
        # The amount of time to wait between checking the order's status. The default is one second.
        $RetryInterval = (New-TimeSpan -Seconds 1)
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