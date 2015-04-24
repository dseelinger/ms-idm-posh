cd C:\git\ms-idm-posh\IdmPowerShell

Import-Module Pester -Force
Import-Module -Name .\IdmPowerShell -Force -Verbose


Describe "Get-IdmServer" {
    It "T001_PS It can get the server location" {
        Get-IdmServer | Should Be "http://localhost:25316"
    }
}
 
Describe “Search-IdmByFilter" {
    It "T001_It_can_search_for_all_ObjectTypeDescription_resources_without_specifying_select_or_sort" {
        $result = Search-IdmByFilter -Filter /ObjectTypeDescription 
        $result.Count -ge 40 | Should Be $true
    }
}