
function Add-CBTypeName
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline=$true)]
        [object]
        $InputObject,

        [Parameter(ParameterSetName='CloudBolt.Management.Automation.Group')]
        [Switch]
        $Group,

        [Switch]
        $PassThru
    )

    process
    {
        Set-StrictMode -Version 'Latest'
        Use-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        if( -not $InputObject.psobject.TypeNames.Contains($PSCmdlet.ParameterSetName) )
        {
            $InputObject.psobject.TypeNames.Insert(0,$PSCmdlet.ParameterSetName)
        }

        if( $PassThru )
        {
            return $InputObject
        }
    }
}