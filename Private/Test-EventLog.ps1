function Test-EventLog {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Levels]$LogLevel
    )

    ( $Script:Settings.EventLog.Enabled -and $LogLevel -le $Script:Settings.EventLog.LogLevel )

}
