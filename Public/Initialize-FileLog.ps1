function Initialize-FileLog {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        # [ValidateScript({ Test-Path -Path $PSItem -PathType Any })]
        [string]$Path,

        [Parameter(Position=1)]
        [Levels]$LogLevel = [Levels]::Error,

        [Parameter(Position=2)]
        [string]$Delimiter=','
    )

    Write-Debug $MyInvocation.MyCommand.Name
    # Write-Debug "Path: $Path"
    # Write-Debug "LogLevel: $LogLevel"
    # Write-Debug "Delimiter: $Delimiter"

    # $ResolvedPath = Resolve-Path $Path

    $Script:Settings.File.Enabled = $true
    $Script:Settings.File.LogLevel = $LogLevel
    $Script:Settings.File.Path = $Path
    $Script:Settings.File.Delimiter = $Delimiter

}
