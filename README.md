# ms-idm-posh
Microsoft Identity Manager PowerShell interface

Requires an instance of the IdmApi (Identity Manager REST API)

Copy IdmPowerShell.psm1 to your "Documents\WindowsPowerShell\Modules\IdmPowerShell" folder

Then:
Import-Module IdmPowerShell

The first command of any IdmPowerShell script must be:

Set-IdmApiLocation "http://myApiServer/api"

...so that it knows where to find the REST server.


If you want to run the integration tests, then you'll need the Pester module, https://github.com/pester/Pester

Click "Download ZIP" and then run:

Unblock-File -Path "$env:UserProfile\Downloads\Pester-master.zip"

Copy the contents of the ZIP file (contents of the folder containing /bin /Examples, etc.) to your "Documents\WindowsPowerShell\Modules\Pester" folder

Run:
Import-Module Pester

CD to your "Documents\WindowsPowerShell\Modules\IdmPowerShell\Tests" and run:
Invoke-Pester