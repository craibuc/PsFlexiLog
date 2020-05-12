function Reset-FileLog {

    $Script:Settings.File.Enabled = $false
    $Script:Settings.File.LogLevel = [Levels]::Information
    $Script:Settings.File.Path = $null
    $Script:Settings.File.Source = $null
    $Script:Settings.File.Columns = @(
        'Computer'
        'User'
        'Source'
        'Timestamp'
        'LogLevel'
        'Message'
        'ErrorId'
    )
    $Script:Settings.File.Delimiter = ','

}
