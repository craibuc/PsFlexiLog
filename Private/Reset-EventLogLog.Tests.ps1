Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {

    Describe "Reset-EventLogLog" {

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
