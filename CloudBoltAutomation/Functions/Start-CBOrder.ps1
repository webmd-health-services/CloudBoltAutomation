function Start-CBOrder 
{
    <#
    .SYNOPSIS
    

    .DESCRIPTION
    

    .EXAMPLE
    

    
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [object]
        # The session to the CloudBolt instance to connect to and use.
        $Session,

        [Parameter(Mandatory)]
        [int]
        # The group ID making the order.
        $GroupID,

        [Parameter(Mandatory)]
        [int]
        # The blueprint ID to order.
        $BlueprintID,

        [hashtable]
        # Any build item parameters. The keys should be the names of the items (without the `build-item` prefix). The values should be a hashtable of name/value pairs to send to that action/item. 
        $BuildItemParameter,

        [string]
        # A name for the order.
        $Name,

        [string]
        # The resource name used by the blueprint, if any.
        $ResourceName,

        [hashtable]
        # The resource parameter for the blueprint's resource, if any.
        $ResourceParameter
    )

    Set-StrictMode -Version 'Latest'
    Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $blueprintArgs = @{}
    foreach( $buildItemName in $BuildItemParameter.Keys )
    {
        $argName = 'build-item-{0}' -f $buildItemName
        $argValue = [pscustomobject]@{
                                        parameters = [pscustomobject]$BuildItemParameter[$buildItemName]
                                    }
        $blueprintArgs[$argName] = $argValue
    }

    $order = [pscustomobject]@{
                                'name' = $Name;
                                'group' = ('/api/v2/groups/{0}' -f $GroupID);
                                'items' = [pscustomobject]@{
                                    'deploy-items' = @(
                                        [pscustomobject]@{
                                            'blueprint' = ('/api/v2/blueprints/{0}' -f $BlueprintID)
                                            'blueprint-items-arguments' = [pscustomobject]$blueprintArgs
                                            'resource-name' = $ResourceName;
                                            'resource-parameters' = [pscustomobject]$ResourceParameter;
                                        }
                                    )
                                };
                                'submit-now' = $true;
                            } | ConvertTo-Json -Depth 100

    $order = Invoke-CBRestMethod -Session $Session -Method Post -ResourcePath 'orders/' -Body $order |
                Add-CBTypeName -Order -PassThru

    $submitInfo = $order._links.actions | 
                        Where-Object { $_ | Get-Member 'submit' } | 
                        Select-Object -ExpandProperty 'submit'
    
    Write-Verbose -Message $submitInfo.title
    if( $submitInfo.href -notmatch '(\borders/.*)' )
    {
        Write-Error -Message ('Unable to find order submit URI from "{0}".' -f $submitInfo.href)
        return
    }

    $submitUri = $Matches[1]
    if( -not $submitUri.EndsWith('/') )
    {
        $submitUri = '{0}/' -f $submitUri
    }

    Invoke-CBRestMethod -Session $Session -Method Post -ResourcePath $submitUri |
        Add-CBTypeName -Order -PassThru
}