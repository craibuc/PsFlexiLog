function Initialize-EventLogLog {

    [CmdletBinding()]
    param (
        [Parameter(Position=0,Mandatory)]
        [string]$Source,

        [Parameter(Position=1)]
        [string]$LogName='Application',

        [Parameter(Position=2)]
        # [ValidateSet("Information", "Warning", "Error")]
        # [ValidateSet('None','Error','Warning','Information','Debug')]
        # [string]$LogLevel = 'Error'
        [Levels]$LogLevel = [Levels]::Error
    )

    # Write-Debug "LogName: $LogName"
    # Write-Debug "Source: $Source"
    # Write-Debug "LogLevel: $LogLevel"

    if ( $PsVersionTable.Platform -ne  'Win32NT' )
    { 
        Write-Warning "EventLog logging not available on $( $PsVersionTable.Platform )."
        return
    }

    # Check if the source exists.
    try {
        if (Test-EventLogSource -Source $Source) {
            # It does exist, make sure it points at the right log.
            if ((Get-LogName -Source $Source) -ne $LogName) {
                # Source exists but points to a different log.
                Write-Error -Message "Invalid source '$Source' in log '$LogName'."
                return
            }
        } else {
            # Source does not exist, try to create it.
            try {
                New-EventLog -LogName $LogName -Source $Source
            } catch [System.Exception] {
                Write-Error -Exception $_.Exception -Message "Unable to create source '$Source' in log '$LogName'."
                return
            }
        }
    } catch [System.Exception] {
        Write-Error -Exception $_.Exception -Message $_.Exception.Message 
        return
    }

    $Script:Settings.EventLog.Enabled = $true
    $Script:Settings.EventLog.LogLevel = $LogLevel
    $Script:Settings.EventLog.LogName = $LogName
    $Script:Settings.EventLog.Source = $Source

}
