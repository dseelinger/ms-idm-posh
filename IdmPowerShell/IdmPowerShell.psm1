#region new cmdlets
Function Get-IdmObject
{
    <#
    .SYNOPSIS
    This function will search the supplied identity server and return the results.
    .DESCRIPTION
    This function will search the supplied identity server and return the results.
    .EXAMPLE
    Get-IdmObject -Server localhost -Filter /Person -Properties DisplayName,AccountName    
    .EXAMPLE
    Get-IdmObject -Server localhost -Filter /Person -Properties DisplayName,AccountName -Credential Get-Credential
    .EXAMPLE
    Get-IdmObject -Server localhost -Filter /Person -CountOnly
    .Example
    Get-IdmObject -Server localhost -SchemaOnly -ObjectType Person   
    .PARAMETER Server
    The idm server name to query. Just one.
    .PARAMETER Filter
    The XPATH filter to apply to the search, will search for all by default.
    .PARAMETER Properties
    The properties of the Idmobject that you wish to retrieve, will retrieve all by default.
    .PARAMETER PageSize
    Retrieves only the first x results specified.
    .PARAMETER CountOnly
    Will only retrieve the total count of objects identified in the search criteria. Much faster that retrieving associated properties.
    .PARAMETER Schema
    Will retrieve the schema definition for the object types supplied
    .PARAMETER ObjectType
    The Object Type of the Schema element to search for
    .PARAMETER Credential
    The PSCredential object in the form of <domain>\<username> of a user to impersonate. If not specified your current user credentials will be used.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter(HelpMessage = 'The name of the Idm server',
        ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Count')]
        [Parameter(ParameterSetName = 'Schema')]
        [string]$Server = $env:COMPUTERNAME,
        
        [Parameter(HelpMessage = 'The XPATH filter to apply to the search',
        ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Count')]
        [string]$Filter = "/*",
        
        [Parameter(HelpMessage = 'The properties of the objects to retrieve',
        ParameterSetName = 'Default')]
        [string[]]$Properties = "*",
        
        [Parameter(HelpMessage = 'The number of results to retrieve',
        ParameterSetName = 'Default')]
        [int]$PageSize,
        
        [Parameter(HelpMessage = 'Only retrieve the total count of objects that the filter returns',
        ParameterSetName = 'Count')]
        [switch]$CountOnly,

        [Parameter(HelpMessage = 'Only retrieve the schema of the specified object type',
        ParameterSetName = 'Schema')]
        [switch]$SchemaOnly,
        
        [Parameter(HelpMessage = 'The object type schema to retrieve',
        ParameterSetName = 'Schema')]
        [string[]]$ObjectType,

        [Parameter(HelpMessage = 'The credential to use to perform the query. Current user credentials will be used if none are specified',
        ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Count')]
        [Parameter(ParameterSetName = 'Schema')]
        [pscredential]$Credential
    )
    Begin
    {
        $ConnectionInfo = [IdmNet.IdmConnectionInfo]::new()
        $ConnectionInfo.Server = $Server
        if($Credential)
        {
            $ConnectionInfo.Domain = $env:USERDOMAIN
            $ConnectionInfo.Username = $Credential.UserName
            $ConnectionInfo.Password = $Credential.GetNetworkCredential().Password
        }
    
        $Client = [IdmNet.IdmNetClientFactory]::BuildClient($ConnectionInfo)
    }
    Process
    {    
        $SearchCriteria = [IdmNet.SoapModels.SearchCriteria]::new()
        $SearchCriteria.Filter = $Filter
    
        if($CountOnly)
        {
            $Client.GetCountAsync($Filter).Result
        }
        elseif($SchemaOnly)
        {
            foreach($Object in $ObjectType)
            {
                $Schema = $Client.GetSchemaAsync($Object)
                $Schema.Result
            }
        }
        else
        {
            foreach($Property in $Properties)
            {
                $SearchCriteria.Selection += $Property
            }
            if($PageSize)
            {
                $Client.GetPagedResultsAsync($SearchCriteria,$PageSize).Result.Items | Select-Object -Property $SearchCriteria.Selection
            }
            else
            {
                $Client.SearchAsync($SearchCriteria).Result | Select-Object -Property $SearchCriteria.Selection
            }
        }
    }
}

Function Set-IdmObject
{
    [CmdletBinding()]
    Param
    (
        [Parameter(HelpMessage = 'The name of the Idm server',
        ParameterSetName = 'Default')]
        [string]$Server = $env:COMPUTERNAME,

        [Parameter(Position = 0,
        ValueFromPipeline = $True,
        HelpMessage = 'The ObjectID of the Object to be modified',
        ParameterSetName = 'Default')]
        [guid]$ObjectID,

        [Parameter(HelpMessage = 'The operation to perform on the specified object',
        ParameterSetName = 'Default')]
        [ValidateSet('Add','Remove','Put')]
        [string]$Operation,
        
        [Parameter(HelpMessage = 'The attributes and values to create new object with',
        ParameterSetName = 'Default')]
        [hashtable]$Attributes,

        [Parameter(HelpMessage = 'The credential to use to perform the operation. Current user credentials will be used if none are specified',
        ParameterSetName = 'Default')]
        [pscredential]$Credential
    )

    Begin
    {
        $ConnectionInfo = [IdmNet.IdmConnectionInfo]::new()
        $ConnectionInfo.Server = $Server
        $Client = [IdmNet.IdmNetClientFactory]::BuildClient($ConnectionInfo)
        $IdmObject = [IdmNet.Models.IdmResource]::new()
    }
    Process
    {
        if($Operation -eq 'Add')
        {
            $Client.AddValueAsync(
        }
        elseif($Operation -eq 'Remove')
        {

        }
        else
        {

        }
        foreach($Attribute in $Attributes.Keys)
        {
            $IdmObject.SetAttrValue($Attribute, $($Attributes.$Attribute))
        }
        $Client.GetNewObjectId($($Client.CreateAsync($IdmObject)).Result)
    }
}

Function New-IdmObject
{
    [CmdletBinding()]
    Param
    (
        [Parameter(HelpMessage = 'The name of the Idm server',
        ParameterSetName = 'Default')]
        [string]$Server = $env:COMPUTERNAME,
        
        [Parameter(HelpMessage = 'The attributes and values to create new object with',
        ParameterSetName = 'Default')]
        [hashtable]$Attributes,

        [Parameter(HelpMessage = 'The credential to use to perform the operation. Current user credentials will be used if none are specified',
        ParameterSetName = 'Default')]
        [pscredential]$Credential
    )

    Begin
    {
        $ConnectionInfo = [IdmNet.IdmConnectionInfo]::new()
        $ConnectionInfo.Server = $Server
        $Client = [IdmNet.IdmNetClientFactory]::BuildClient($ConnectionInfo)
        $IdmObject = [IdmNet.Models.IdmResource]::new()
    }
    Process
    {
        foreach($Attribute in $Attributes.Keys)
        {
            $IdmObject.SetAttrValue($Attribute, $($Attributes.$Attribute))
        }
        $Client.GetNewObjectId($($Client.CreateAsync($IdmObject)).Result)
    }
}
#endregion

#region Original module cmdlets
function Get-IdmServer {
    [string]"http://localhost:25316"
}

function Search-IdmByFilter {
  <#
  .SYNOPSIS
  Search Identity Manger with an XPath filter
  .DESCRIPTION
  Get one or more resources from Identity Manager by supplying an XPath FILTER, an optional SELECT, and an optional SORT
  .EXAMPLE
  Search-IdmByFilter /ObjectTypeDescription
  .EXAMPLE
  Search-IdmByFilter -Filter /ObjectTypeDescription -Select "DisplayName,Name"
  .PARAMETER Filter
  The XPath Filter with which to search Identity Manager
  .PARAMETER Select
  An array of attribute names that should be retrieved as a part of the search. Defaults to (and always includes) "ObjectID,ObjectType"
  .PARAMETER Sort
  Comma separated list of attributes to sort by, must be in the format of  "AttributeName:SortDirection". For example: BoundObjectType:Ascending,BoundAttributeType:Descending - which would be a valid sort order for BindingDescription objects in Identity Manager
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='XPath filter to search with')]
    [string]$Filter,
    [Parameter(Mandatory=$false,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Comma-separated list of attributes to return')]
    [string]$Select,
    [Parameter(Mandatory=$false,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Comma separated list of attributes to sort by, must be in the format of  "AttributeName:SortDirection". For example: BoundObjectType:Ascending,BoundAttributeType:Descending - which would be a valid sort order for BindingDescription objects in Identity Manager')]
    [string]$Sort
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources?filter=$Filter&select=$Select&sort=$Sort"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url
  }
}


function Get-IdmCount {
  <#
  .SYNOPSIS
  Get Identity Manager Count
  .DESCRIPTION
  Get the count of the number of records that match (or would be returned) from a particular search request
  .EXAMPLE
  Get-IdmCount /ConstantSpecifier
  .PARAMETER Filter
  The XPath Filter with which to search Identity Manager
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      Position = 0,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='XPath filter to search with')]
    [string]$Filter
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources?filter=$Filter"
    Write-Verbose "URL = $url"
    $result = Invoke-WebRequest -Method Head -Uri $url
    $result.Headers["x-idm-count"]
  }
}


function Search-IdmByObjectID {
  <#
  .SYNOPSIS
  Search Identity Manger by ObjectID
  .DESCRIPTION
  Get the resource from Identity Manager by supplying its ObjectID, and an optional SELECT
  .EXAMPLE
  Search-IdmByFilter c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e
  .EXAMPLE
  Search-IdmByFilter -ObjectID c51c9ef3-2de0-4d4e-b30b-c1a18e79c56e -Select "DisplayName,Name"
  .PARAMETER ObjectID
  The ObjectID of the resource to retrieve from Identity Manager
  .PARAMETER Select
  An array of attribute names that should be retrieved as a part of the search. Defaults to (and always includes) "ObjectID,ObjectType"
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      Position=0,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='The ObjectID of the resource to retrieve from Identity Manager')]
    [string]$ObjectID,
    [Parameter(Mandatory=$false,
      Position=1,
      ValueFromPipeline=$false,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Comma-separated list of attributes to return')]
    [string]$Select
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources/$ObjectID`?select=$Select"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url
  }
}

function Add-IdmObject {
  <#
  .SYNOPSIS
  Create a new object/resource in Identity Manager
  .DESCRIPTION
  Create a new object in identity manager by supplying an appropriate JSON parameter to represent the object. Both examples show equivalent functionality
  .EXAMPLE
  Add-IdmObject '{ "ObjectType": "Person", "DisplayName": "_Test User" }'
  .EXAMPLE
  Add-IdmObject '{ "Attributes": [ { "Name": "ObjectType", "Values": ["Person"] }, { "Name": "DisplayName", "Values": ["_Test User"] } ] }'
  .PARAMETER Json
  The JSON representation of the object to be created in Identity Manager
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      Position=0,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='Supply the JSON for the new object')]
    [string]$Json
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url -Method Post -Body $Json -ContentType "application/json"
  }
}


function Remove-IdmObject {
  <#
  .SYNOPSIS
  Deletes an existing object/resource from Identity Manager
  .DESCRIPTION
  Deletes an existing object from identity manager by supplying the ObjectID of the object to be deleted.
  .EXAMPLE
  Remove-IdmObject 9e43f3a1-9efe-41dd-8405-23ea2e421e33
  .PARAMETER ObjectID
  The object ID of the object to be deleted.
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
      Position=0,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage='ID of the object to be deleted')]
    [string]$ObjectID
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    $url = "$idmApi/api/resources/$ObjectID"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url -Method Delete
  }
}
#endregion