Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {

    Describe "Reset-ConsoleLog" -Tag 'unit' {

        BeforeEach {
            # arrange
            Initialize-ConsoleLog -LogLevel Debug

            # act
            Reset-ConsoleLog
        }

        It "disables the Console log" {
            $Script:Settings.Console.Enabled | Should -Be $false
        }
        It "sets the LogLevel to 'Information" {
            $Script:Settings.Console.LogLevel | Should -Be Information
        }

    }

}
