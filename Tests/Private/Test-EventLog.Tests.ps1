Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {
    Describe "Test-EventLog" -Tag 'unit' {

        Context "Parameter validation" {
            # act
            $Command = Get-Command "Test-EventLog"

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

        Context "EventLog logging enabled" {
            # arrange
            $Script:Settings.EventLog.Enabled = $true

            Context "EventLog LogLevel >= LogLevel" {
                It "returns [True]" {
                    # arrange
                    $Script:Settings.EventLog.LogLevel = [Levels]::Debug
                    # act
                    $Actual = Test-EventLog -LogLevel Information
                    # assert
                    $Actual | Should -Be $True
                }
            }

            Context "EventLog LogLevel < LogLevel" {
                It "returns [False]" {
                    # arrange
                    $Script:Settings.EventLog.LogLevel = [Levels]::None
                    # act
                    $Actual = Test-EventLog -LogLevel Information
                    # assert
                    $Actual | Should -Be $false
                }
            }
        }

        Context "EventLog logging disabled" {
            It "returns [False]" {
                # arrange
                $Script:Settings.EventLog.Enabled = $false

                #act
                $Actual = Test-EventLog -LogLevel Information
                # assert
                $Actual | Should -Be $false
            }
        }

    }
    
}
