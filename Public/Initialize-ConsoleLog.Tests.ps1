$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Initialize-ConsoleLog" -Tag 'unit' {

    Context "Parameter validation" {
        Context "LogLevel" {
            It "it is an enumeration of type Levels" {
                Get-Command "Initialize-ConsoleLog" | Should -HaveParameter 'LogLevel' -Type [Levels]
            }
            It "its default value is 'Information'" -skip {
                $true | Should -Be $false
            }
        }
    }

    InModuleScope 'PsFlexiLog' {

        Context "Default parameter values" {

            it "sets the script-level variables correctly" {
                $Script:Settings.Console.Enabled | Should -Be $true
                $Script:Settings.Console.LogLevel | Should -Be Information
            }

        }

    }

}
