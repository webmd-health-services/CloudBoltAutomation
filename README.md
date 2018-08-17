# CloudBoltAutomation

A PowerShell module for interacting with the CloudBolt API.

# Getting Started

Download CloudBoltAutomation from the PowerShell Gallery:

    Save-Module -Name CloudBoltAutomation -Path .

Import the module:

    Import-Module -Name .\CloudBoltAutomation

Create a session to your CloudBolt instance:

    $session = New-CBSession -Uri 'https://cloudbolt.example.com/' -Credential (Get-Credential $env:USERNAME)

You're now ready to use the other commands in the module. Run

    Get-Command -Module CloudBoltAutomation

to see a list of commands. Run `help COMMAND` for documentation on a specific command.

# System Requirements

Should work across Windows PowerShell and PowerShell Core.

* PowerShell 5.1

# Development

## Getting Started

1. Install [Vagrant](https://varantup.com).
2. Install [VirtualBox](https://www.virtualbox.org/).
3. From an administrative PowerShell prompt, run `.\init.ps1`. This will get a local CloudBolt VM running. You'll be able to access the CloudBolt UI at http://127.0.0.1:8080. 

## Running Tests

We use Pester to write our tests. To install Pester, run:

    .\init.ps1

or

    .\build.ps1 -Initialize

You can then import Pester from the "Modules" directory:

    Import-Module .\Modules\Pester


## Configuring CloudBolt

CloudBolt will be inaccessible until you add a license and run through the setup wizard.

1. Go to http://127.0.0.1:8080.
2. Enter the license from the CloudBoltLicense.txt file.
3. Login with credentials admin/admin.
4. Complete the setup wizard. Choose "IPMI" as the technology for your first resource handler.
