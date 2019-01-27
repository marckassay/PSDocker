function Search-Image {

    <#

    .SYNOPSIS

    Search the Docker Hub for images

    .DESCRIPTION

    Wraps the command [docker search](https://docs.docker.com/engine/reference/commandline/search/).

    .PARAMETER Term

    Specifies the search term.

    .PARAMETER Limit

    Specifies the maximum number of results.
    If the limit is $null or 0 the docker default (25) is used instead.

    .PARAMETER Timeout

    Specifies the number of seconds to wait for the command to finish.

    .EXAMPLE

    PS C:\> Search-DockerImage 'nanoserver' -Limit 2

    IsAutomated : False
    Description :
    Name        : microsoft/nanoserver
    Stars       : 431
    IsOfficial  : False

    IsAutomated : False
    Description : Nano Server + IIS. Updated on 08/21/2018 -- …
    Name        : nanoserver/iis
    Stars       : 35
    IsOfficial  : False

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Term,

        [Parameter(Mandatory=$true)]
        [int]
        $Limit,

        [Parameter(Mandatory=$false)]
        [int]
        $Timeout = 30
    )

    # prepare arugments
    $arguments = New-Object System.Collections.ArrayList

    $arguments.Add( 'search' ) | Out-Null

    if ( $Limit ) {
        $arguments.Add( "--limit $Limit" ) | Out-Null
    }

    $arguments.Add( $Term ) | Out-Null

    $resultTable = Invoke-ClientCommand `
        -ArgumentList $arguments `
        -Timeout $Timeout `
        -TableOutput @{
        'NAME' = 'Name'
        'DESCRIPTION' = 'Description'
        'STARS' = 'Stars'
        'OFFICIAL' = 'IsOfficial'
        'AUTOMATED' = 'IsAutomated'
    } | Foreach-Object {
        New-Object -Type PsObject -Property @{
            Name = $_.Name
            Description = $_.Description
            Stars = [int] $_.Stars
            IsOfficial = switch($_.IsOfficial) { '[OK]' { $true } default { $false }}
            IsAutomated = switch($_.IsAutomated) { '[OK]' { $true } default { $false }}
        }
    }

    Write-Output $resultTable
}