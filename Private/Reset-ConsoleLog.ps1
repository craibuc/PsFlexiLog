function Reset-ConsoleLog {

    $Script:Settings.Console.Enabled = $false
    $Script:Settings.Console.LogLevel = [Levels]::Information

}
