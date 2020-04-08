Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {

    Describe "Reset-FileLog" {

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
