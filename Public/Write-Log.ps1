<#
.SYNOPSIS
Writes a log message to the sources that are enabled.

.PARAMETER Message
The message to be written.

.PARAMETER LogLevel
The logging level.

.PARAMETER LogLevel
The exception to be logged.

#>
function Write-Log {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [string]$Message,

        [Parameter()]
        [Levels]$LogLevel = [Levels]::Information,

        [Parameter()]
        [exception]$Exception
    )

    # Write-Debug $MyInvocation.MyCommand.Name

    <#
    `0 -- Null
    `a -- Alert
    `b -- Backspace
    `n -- New line
    `r -- Carriage return
    `t -- Horizontal tab
    `' -- Single quote
    `" -- Double quote
    #>

    $Timestamp = (Get-Date)

    if ($Exception)
    {
        $Message += "`n`nExceptionInformation" + `
        "`nMessage: $($Exception.Message)" + `
        "`nSource: $($Exception.Source)" + `
        "`nStackTrace: $($Exception.StackTrace)" + `
        "`nTargetSite: $($Exception.TargetSite)"
    }

    #
    # console logging
    #
    # if ( $Script:Settings.Console.Enabled -and $LogLevel -le $Script:Settings.Console.LogLevel )
    if ( Test-ConsoleLog -LogLevel $LogLevel )
    {
        $Value = "{0} - {1} - {2}" -f $Timestamp.ToString('yyyy-MM-dd HH:mm:ss'), $LogLevel.ToString().ToUpper(), $Message

        switch ($LogLevel) {
            "Error" { Write-Error $Value }
            "Warning" { Write-Warning $Value }
            "Information" { Write-Information $Value }
            "Debug" { Write-Debug $Value }
        }
    
    }

    #
    # file logging
    #
    # if ( $Script:Settings.File.Enabled -and $LogLevel -le $Script:Settings.File.LogLevel )
    if ( Test-FileLog -LogLevel $LogLevel )
    {

        # https://stackoverflow.com/a/26010117
        # ($FileExtensions.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join ';'

        $Values = @()
        $Values += $currentComputer
        $Values += $currentUser
        $Values += $Script:Settings.File.Source
        $Values += $Timestamp.ToString('yyyy-MM-dd HH:mm:ss')
        $Values += $LogLevel.ToString().ToUpper()
        $Values += $Message
        $Values += $null

        $Value = ( $Values -join $Script:Settings.File.Delimiter )
        Write-Debug "Value: $Value"

        Add-Content -Path $Script:Settings.File.Path -Value $Value
    }

    #
    # event-log logging
    #
    # if ( $Script:Settings.EventLog.Enabled -and $LogLevel -le $Script:Settings.EventLog.LogLevel )
    if ( Test-EventLog -LogLevel $LogLevel )
    {
        Write-EventLog -LogName $Script:Settings.EventLog.LogName -Source $Script:Settings.EventLog.Source -EntryType ( $LogLevel.ToString() ) -EventId $Script:Settings.EventLog.EventId -Message $Message
    }

}
