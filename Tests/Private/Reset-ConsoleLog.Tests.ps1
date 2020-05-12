# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Reset-ConsoleLog.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Reset-ConsoleLog.ps1
. (Join-Path $PrivatePath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

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
