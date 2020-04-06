<#
.SYNOPSIS
Load functions and settings

.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_enum?view=powershell-7
https://blog.pauby.com/post/creating-enums-in-powershell/
#>

##
# load (dot-source) *.PS1 files, excluding unit-test scripts (*.Tests.*), and disabled scripts (__*)
#
@("$PSScriptRoot\Public\*.ps1","$PSScriptRoot\Private\*.ps1") | 
    Get-ChildItem | 
        Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | 
            ForEach-Object {
                # dot-source script
                . $_
            }

##
# Streams
#
# Allow module to inherit '-Debug' flag.
if (($PSCmdlet) -and (-not $PSBoundParameters.ContainsKey('Debug'))) {
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
}

# Allow module to inherit '-Verbose' flag.
if (($PSCmdlet) -and (-not $PSBoundParameters.ContainsKey('Verbose'))) {
    $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
}

##
# Operating System
#
if ($isLinux -or $isMacOS)
{
    $currentUser     = $ENV:USER
    $currentComputer = uname -n
    $OSName          = uname -s
    $OSArchi         = uname -m
    $StrTerminator   = "`r"
}
else
{
    $currentUser     = $ENV:USERDOMAIN + '\' + $ENV:USERNAME
    $currentComputer = $ENV:COMPUTERNAME  
    $WmiInfos        = Get-CimInstance win32_operatingsystem
    $OSName          = $WmiInfos.caption
    $OSArchi         = $WmiInfos.OSArchitecture
    $StrTerminator     = "`r`n"
}

# Write-Debug "currentComputer: $currentComputer"
# Write-Debug "currentUser: $currentUser"
# Write-Debug "OSName: $OSName"
# Write-Debug "OSArchi: $OSArchi"
# Write-Debug "StrTerminator: $StrTerminator"

##
# Enumerations
#
enum Levels {
    None = 0
    Error = 1
    Warning = 2
    Information = 3
    Debug = 4
}

##
# Settings for each of the log types
#
$Script:Settings = [pscustomobject]@{

    Console = [pscustomobject] @{
        Enabled = $false
        LogLevel = [Levels].Error
    }

    File = [pscustomobject] @{
        Enabled = $false
        LogLevel = [Levels].Error
        Path = $null
        Source = $null
        Delimiter = ','
    }

    EventLog = [pscustomobject] @{
        Enabled = $false
        LogLevel = [Levels].Error
        LogName = $null
        Source = $null
        EventId = 1000
    }

}
