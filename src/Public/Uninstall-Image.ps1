function Uninstall-Image {

    <#

    .SYNOPSIS
    Remove docker image

    .DESCRIPTION
    Wraps the docker command `docker image rm`.

    .LINK
    https://docs.docker.com/engine/reference/commandline/image_rm/

    .LINK
    Install-Image

    .PARAMETER Name
    Specifies the name of the image to be removed.

    .PARAMETER Force
    Specifies if the image should be removed, even if a container is using this image.

    .PARAMETER NoPrune
    Specifies if untagged parents should not be removed.

    .PARAMETER Timeout
    Specifies how long to wait for the command to finish.

    .EXAMPLE
    PS C:\> Get-DockerImage -Repository 'microsoft/powershell' | Uninstall-DockerImage

    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [Alias( 'Image' )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $Force = $false,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [switch] $NoPrune = $false,

        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName = $true )]
        [int] $Timeout = 10
    )


    $arguments = New-Object System.Collections.ArrayList

    if ( $Force ) {
        $arguments.Add( '--force' ) | Out-Null
    }

    if ( $NoPrune ) {
        $arguments.Add( '--no-prune' ) | Out-Null
    }

    $arguments.Add( $Name ) | Out-Null

    Invoke-ClientCommand 'image rm', $arguments -Timeout $Timeout
    Write-Verbose "Docker image '$Name' removed."

}
