
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

        [Parameter(ParameterSetName='CloudBolt.Management.Automation.Environment')]
        [Switch]
        $Environment,

        [Parameter(ParameterSetName='CloudBolt.Management.Automation.Order')]
        [Switch]
        $Order,

        [Parameter(ParameterSetName='CloudBolt.Management.Automation.Job')]
        [Switch]
        $Job,

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