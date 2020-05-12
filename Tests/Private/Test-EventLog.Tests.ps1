# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Test-EventLogLog.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Reset-ConsoleLog.ps1
. (Join-Path $PrivatePath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

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
