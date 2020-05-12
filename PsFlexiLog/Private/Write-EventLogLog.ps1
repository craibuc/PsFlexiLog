<#
.SYNOPSIS
Writes an entry to the Windows EventLog

.PARAMETER

.Example
PS> Write-EventLogLog

#>
function Write-EventLogLog {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LogName='Application',

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$Source,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [Alias('LogLevel')]
        [string]$EntryType,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [ValidateRange(0,65535)]
        [int]$EventId,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$Message

    )

    # $Script:Settings.EventLog.LogName
    # $Script:Settings.EventLog.Source
    # $Script:Settings.EventLog.EventId

    Write-EventLog -LogName $LogName -Source $Source -EntryType $EntryType -EventId $EventId -Message $Message

}
