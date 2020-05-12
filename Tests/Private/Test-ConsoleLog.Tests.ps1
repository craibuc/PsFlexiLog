Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {
    Describe "Test-ConsoleLog" -Tag 'unit' {

        Context "Parameter validation" {
            # act
            $Command = Get-Command "Test-ConsoleLog"

            Context "LogLevel" {
                $ParameterName = 'LogLevel'

                It "is a [Levels]" {
                    $Command | Should -HaveParameter $ParameterName -Type [Levels]
                }
                It "is mandatory" {
                    $Command | Should -HaveParameter $ParameterName -Mandatory
                }
            }
        }

        Context "Console logging enabled" {
            # arrange
            $Script:Settings.Console.Enabled = $true

            Context "Console LogLevel >= LogLevel" {
                It "returns [True]" {
                    # arrange
                    $Script:Settings.Console.LogLevel = [Levels]::Debug
                    # act
                    $Actual = Test-ConsoleLog -LogLevel Information
                    # assert
                    $Actual | Should -Be $True
                }
            }

            Context "Console LogLevel < LogLevel" {
                It "returns [False]" {
                    # arrange
                    $Script:Settings.Console.LogLevel = [Levels]::None
                    # act
                    $Actual = Test-ConsoleLog -LogLevel Information
                    # assert
                    $Actual | Should -Be $false
                }
            }
        }

        Context "Console logging disabled" {
            It "returns [False]" {
                # arrange
                $Script:Settings.Console.Enabled = $false

                #act
                $Actual = Test-ConsoleLog -LogLevel Information
                # assert
                $Actual | Should -Be $false
            }
        }

    }
    
}
