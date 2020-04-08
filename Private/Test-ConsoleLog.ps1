function Test-ConsoleLog {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Levels]$LogLevel
    )

    ( $Script:Settings.Console.Enabled -and $LogLevel -le $Script:Settings.Console.LogLevel )

}
