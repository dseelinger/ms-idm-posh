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
  Search-IdmByFilter -Filter /ObjectTypeDescription -Select @(DisplayName,Name)
  .PARAMETER Filter
  The XPath Filter with which to search Identity Manager
  .PARAMETER Select
  An array of attribute names that should be retrieved as a part of the search. Defaults to (and always includes) @(ObjectID,ObjectType)
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
    [string]$Select
  )

  begin {
    $idmApi = Get-IdmServer
  }

  process {
    write-verbose "Beginning process loop"
    #$encodedFilter = [System.Web.HttpUtility]::UrlEncode("$Filter")
    #Write-Verbose "Encoded Filter = $encodedFilter"
    $url = "$idmApi/api/resources?filter=$Filter&select=$Select"
    Write-Verbose "URL = $url"
    Invoke-RestMethod -Uri $url
  }
}