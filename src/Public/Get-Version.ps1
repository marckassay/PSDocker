function Get-Version {

    <#

    .SYNOPSIS Get version information

    .DESCRIPTION
    Returns version information of the docker client and service.
    Wraps the docker command [version](https://docs.docker.com/engine/reference/commandline/version/).

    .PARAMETER Timeout
    Specifies the timeout of the docker client command.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Timeout = 1
    )

    $output = (
        Invoke-ClientCommand "version" -Timeout $Timeout -StringOutput
    ).Split( [Environment]::NewLine )

    $dockerVersionTable = @{
        'Client' = @{}
        'Server' = @{}
    }

    $component = $null
    foreach ( $line in $output ) {
        switch ( $line ) {
            "" {}
            "Client:" { $component = 'Client' }
            "Server:" { $component = 'Server' }
            Default {
                if ( -not $component ) {
                    throw "unexpected response from 'docker version'"
                } else {
                    $key, $value = $line -Split ':  ' | ForEach-Object { $_.Trim() }
                    $componentVersionTable = $dockerVersionTable[$component]
                    $componentVersionTable.Add($key.Replace('/', '').Replace(' ', ''), $value)
                }
            }
        }
    }

    New-Object PSObject -Property @{
        Client = ( New-Object PSObject -Property $dockerVersionTable['Client'] )
        Server = ( New-Object PSObject -Property $dockerVersionTable['Server'] )
    }

}