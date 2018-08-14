# CloudBoltAutomation
A PowerShell module for interacting with the CloudBolt API.

# Development

## Getting Started

1. Install [Vagrant](https://varantup.com).
2. Install [VirtualBox](https://www.virtualbox.org/).
3. From an administrative PowerShell prompt, run `.\init.ps1`. This will get a local CloudBolt VM running. You'll be able to access the CloudBolt UI at http://127.0.0.1:8080. 

## Configuring CloudBolt

CloudBolt will be inaccessible until you add a license and run through the setup wizard.

1. Go to http://127.0.0.1:8080.
2. Enter the license from the CloudBoltLicense.txt file.
3. Login with credentials admin/admin.
4. Complete the setup wizard. Choose "IPMI" as the technology for your first resource handler.
