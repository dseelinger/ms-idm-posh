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

    It "T002_It_can_search_and_return_specific_attributes" {
        $result = Search-IdmByFilter -Filter /ObjectTypeDescription -Select "DisplayName,Name"
        $result[0].DisplayName | Should Be "Activity Information Configuration"
        $result[0].Attributes[3].Values[0] | Should Be "ActivityInformationConfiguration"
    }

    It "T003_It_can_search_and_return_all_attributes_with_Select_STAR" {
        $result = Search-IdmByFilter -Filter /BindingDescription -Select "*"
        $result[0].Attributes.Count | Should Be 10
    }
}