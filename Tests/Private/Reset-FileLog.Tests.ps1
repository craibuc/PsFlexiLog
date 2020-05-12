# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Reset-FileLog.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Reset-FileLog.ps1
. (Join-Path $PrivatePath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

InModuleScope 'PsFlexiLog' {

    Describe "Reset-FileLog" -Tag 'unit' {

        BeforeEach {
            # arrange
            Initialize-FileLog -Path './foo.log' -Source 'source' -LogLevel Debug -Delimiter ','

            # act
            Reset-FileLog
        }

        It "disables the File log" {
            $Script:Settings.File.Enabled | Should -Be $false
        }
        It "sets the LogLevel to 'Information'" {
            $Script:Settings.File.LogLevel | Should -Be Information
        }
        It "sets the Path to [null]" {
            $Script:Settings.File.Path | Should -Be $null
        }
        It "sets the Source to [null]" {
            $Script:Settings.File.Source | Should -Be $null
        }
        It "sets the Delimiter to '," {
            $Script:Settings.File.Delimiter | Should -Be ','
        }

    }

}
