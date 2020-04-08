function Test-FileLog {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Levels]$LogLevel
    )

    ( $Script:Settings.File.Enabled -and $LogLevel -le $Script:Settings.File.LogLevel )

}
