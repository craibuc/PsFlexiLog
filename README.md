# PsFlexiLog

## Usage

```powershell
Import-Module PsFlexiLog -Force

# None = 0
# Error = 1
# Warning = 2
# Information = 3
# Debug = 4

# changes preferences to see these console messages
$DebugPreference = 'Continue'
$WarningPreference = 'Continue'
$InformationPreference = 'Continue'

# start a Console log that captures all message types (Debug, Information, Warning, and Error)
Initialize-ConsoleLog -LogLevel Debug

# start a File log that captures Information, Warning, and Error messages
$Path = "./Do-Something.$( Get-Date -Format 'yyyyMMdd.HHmmss' ).log"
Initialize-FileLog -LogLevel Information -Path $Path -Source 'Do-Something'

# start an EventLog log that captures Warning and Error messages; assumes that the Application log source 'Do-Something' has been created
Initialize-EventLogLog -LogLevel Warning -Source 'Do-Something'

Write-Log 'this message will not captured in any logs' -LogLevel None
Write-Log 'error message - captured in all logs' -LogLevel Error
Write-Log 'warning message - captured in all logs' -LogLevel Warning
Write-Log 'information message - captured in file and console logs' -LogLevel Information
Write-Log 'debug message - captured in console log' -LogLevel Debug
```

```powershell
Get-Content -Path $Path

Computer,User,Source,Timestamp,LogLevel,Message,ErrorId
Galadriel.lan,craig,Do-Something,2020-04-08 11:06:26,NONE,this message will not captured in any logs,
Galadriel.lan,craig,Do-Something,2020-04-08 11:06:26,ERROR,error message - captured in all logs,
Galadriel.lan,craig,Do-Something,2020-04-08 11:06:26,WARNING,warning message - captured in all logs,
Galadriel.lan,craig,Do-Something,2020-04-08 11:06:26,INFORMATION,information message - captured in file and console logs,
```

## Author

* [Craig Buchanan](https://github.com/craibuc)

## Contributors

* 

## Links

- [Parse log files with PowerShell](https://4sysops.com/archives/parse-log-files-with-powershell/)

## References

- [Building Logs for CMTrace with PowerShell](https://adamtheautomator.com/building-logs-for-cmtrace-powershell/)
- [dbatools](https://www.powershellgallery.com/packages/dbatools/0.9.187/Content/internal%5Cfunctions%5CWrite-Message.ps1)
- [EZLog](https://github.com/apetitjean/EZLog)
- [PSMultiLog](https://github.com/platta/PSMultiLog)
- [StreamLogging](https://github.com/alekdavis/StreamLogging)
