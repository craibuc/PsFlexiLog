function Initialize-ConsoleLog {

    [CmdletBinding()]
    param (
        [Parameter()]
        [Levels]$LogLevel = [Levels]::Information
    )

    Write-Debug "LogLevel: $LogLevel"

    $Script:Settings.Console.Enabled = $true
    $Script:Settings.Console.LogLevel = $LogLevel

}
