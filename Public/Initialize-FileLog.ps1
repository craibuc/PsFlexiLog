function Initialize-FileLog {

    [CmdletBinding()]
    param (
        [Parameter(Position=0,Mandatory)]
        # [ValidateScript({ Test-Path -Path $PSItem -PathType Any })]
        [string]$Path,

        [Parameter(Position=1,Mandatory)]
        [string]$Source,

        [Parameter(Position=2)]
        [Levels]$LogLevel = [Levels]::Error,

        [Parameter(Position=3)]
        [string]$Delimiter=','
    )

    Write-Debug $MyInvocation.MyCommand.Name
    # Write-Debug "Path: $Path"
    # Write-Debug "Source: $Source"
    # Write-Debug "LogLevel: $LogLevel"
    # Write-Debug "Delimiter: $Delimiter"

    # $ResolvedPath = Resolve-Path $Path

    $Script:Settings.File.Enabled = $true
    $Script:Settings.File.LogLevel = $LogLevel
    $Script:Settings.File.Path = $Path
    $Script:Settings.File.Source = $Source
    $Script:Settings.File.Delimiter = $Delimiter

    $Value = ( $Script:Settings.File.Columns -join $Script:Settings.File.Delimiter )
    Write-Debug "Value: $Value"

    Add-Content -Path $Script:Settings.File.Path -Value $Value

}
