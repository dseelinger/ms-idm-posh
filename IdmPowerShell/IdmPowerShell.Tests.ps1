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

    It "T004_It_can_Search_and_Sort_the_results_by_multiple_attributes_in_Ascending_or_Descending_order" {
        $result = Search-IdmByFilter -Filter /BindingDescription -Select "Name,BoundObjectType,BoundAttributeType" -Sort "BoundObjectType:Ascending,BoundAttributeType:Descending"
        $result[0].Attributes[3].Values[0] | Should Be e1a42ced-6968-457c-b5c8-3f9a573295a6
        $result[1].Attributes[3].Values[0] | Should Be e1a42ced-6968-457c-b5c8-3f9a573295a6
        #...
        $result[18].Attributes[3].Values[0] | Should Be e1a42ced-6968-457c-b5c8-3f9a573295a6
        $result[19].Attributes[3].Values[0] | Should Be e1a42ced-6968-457c-b5c8-3f9a573295a6

        $result[20].Attributes[3].Values[0] | Should Be c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e
    }

    It "T005_It_can_get_a_resource_by_its_ObjectID" {
        $result = Search-IdmByObjectID c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e
        $result.Attributes[0].Values[0] | Should Be c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e
        $result.Attributes[1].Values[0] | Should Be ObjectTypeDescription
    }

    
}