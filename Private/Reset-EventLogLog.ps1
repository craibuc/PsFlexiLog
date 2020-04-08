function Reset-EventLogLog {

    $Script:Settings.EventLog.Enabled = $false
    $Script:Settings.EventLog.LogLevel = [Levels]::Error
    $Script:Settings.EventLog.LogName = $null
    $Script:Settings.EventLog.Source = $null
    $Script:Settings.EventLog.EventId = 1000

}
