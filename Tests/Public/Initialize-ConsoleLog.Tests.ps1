# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Public
$PublicPath = Join-Path $ProjectDirectory "/PsFlexiLog/Public/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Initialize-ConsoleLog.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Public/Initialize-ConsoleLog.ps1
. (Join-Path $PublicPath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

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
                # act
                Initialize-ConsoleLog

                # assert
                $Script:Settings.Console.Enabled | Should -Be $true
                $Script:Settings.Console.LogLevel | Should -Be Information
            }

        }

        Context "LogLevel" {

            it "sets the script-level variables correctly" {
                # arrange
                $LogLevel = [Levels]::Error

                # act
                Initialize-ConsoleLog -LogLevel $LogLevel

                # assert
                $Script:Settings.Console.Enabled | Should -Be $true
                $Script:Settings.Console.LogLevel | Should -Be Error
            }

        }

    }

}
