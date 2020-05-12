<#
.SYNOPSIS
Test to determine if event-log source exists within an event log.

.PARAMETER SourceName
The name of the event-log source.

.EXAMPLE
PS> Test-EventLogSource -SourceName 'some event source'
True

#>
function Test-EventLogSource {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$SourceName
    )

    Write-Debug $MyInvocation.MyCommand.Name
    Write-Debug "SourceName: $SourceName"

    try
    {
        # store preference
        $Preference = $ErrorActionPreference
        
        # force exception to be raised
        $ErrorActionPreference = 'Stop'

        # returns True if the source exists
        [System.Diagnostics.EventLog]::SourceExists($SourceName)
    }
    catch
    {
        # no-match error raised
        $false
    }
    finally
    {
        # restore preference
        $ErrorActionPreference = $Preference
    }

}
