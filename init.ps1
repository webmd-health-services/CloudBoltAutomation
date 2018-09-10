[CmdletBinding()]
param(

)

#Requires -Version 5.1
#Requires -RunAsAdministrator
Set-StrictMode -Version 'Latest'
$ErrorActionPreference = 'Stop'

if( -not (Get-Command -Name 'vagrant' -ErrorAction Ignore) )
{
    Write-Error -Message ('Vagrant isn''t installed. Please download the latest version of Vagrant from https://www.vagrantup.com/.')
    exit 1
}

vagrant up
if( $LASTEXITCODE )
{
    Write-Error -Message ('It looks like `vagrant up` failed. :(  It returned exit code "{0}".' -f $LASTEXITCODE)
    exit 1
}

try 
{
    Invoke-WebRequest -Uri 'http://127.0.0.1:8080'
}
catch 
{
    if( $_.Exception.Response.StatusCode -eq [Net.HttpStatusCode]::Forbidden )
    {
        Write-Warning -Message ('CloudBolt is running but hasn''t been configured yet. Please visit http://127.0.0.1:8080 and configure CloudBolt:
        
 * Here''s the license (from the CloudBoltLicense.txt file):
 
{0}
    
 * Use admin/admin to login.
 * Run through the setup wizard.
 
When asked to create a Resource Handler, use "IPMI".
 
 ' -f (Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath 'CloudBoltLicense.txt') -Raw))
        exit 0
    }
    Write-Error -Message ('Looks like the CloudBolt VM didn''t start or the CloudBolt port isn''t getting forwarded by Vagrant.')
    Write-Error -ErrorRecord $_
    exit 1
}

& (Join-Path -Path $PSScriptRoot -ChildPath 'build.ps1' -Resolve) -Initialize