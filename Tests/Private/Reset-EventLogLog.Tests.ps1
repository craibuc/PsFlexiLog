# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Reset-EventLogLog.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Reset-EventLogLog.ps1
. (Join-Path $PrivatePath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

InModuleScope 'PsFlexiLog' {

    Describe "Reset-EventLogLog" -Tag 'unit' {

        BeforeEach {
            # arrange
            Initialize-EventLogLog -LogLevel Debug -LogName 'Application' -Source 'Do-Something'

            # act
            Reset-EventLogLog
        }

        It "disables the EventLog log" {
            $Script:Settings.EventLog.Enabled | Should -Be $false
        }
        It "sets the LogLevel to 'Error'" {
            $Script:Settings.EventLog.LogLevel | Should -Be Error
        }
        It "sets the LogName to [null]" {
            $Script:Settings.EventLog.LogName | Should -Be $null
        }
        It "sets the Source to [null]" {
            $Script:Settings.EventLog.Source | Should -Be $null
        }
        It "sets the EventId to 1000" {
            $Script:Settings.EventLog.EventId | Should -Be 1000
        }

    }

}
