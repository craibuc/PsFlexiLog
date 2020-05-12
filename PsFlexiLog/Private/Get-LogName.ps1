function Get-LogName {

    [CmdletBinding()]
    [OutputType([string])]
    Param (
        [Parameter(Mandatory)]
        [string]$Source
    )

    Process {
        [System.Diagnostics.EventLog]::LogNameFromSourceName($Source, ".")
    }

}
