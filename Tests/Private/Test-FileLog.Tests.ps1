# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Test-FileLog.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Test-FileLog.ps1
. (Join-Path $PrivatePath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

InModuleScope 'PsFlexiLog' {
    Describe "Test-FileLog" -Tag 'unit' {

        Context "Parameter validation" {
            # act
            $Command = Get-Command "Test-FileLog"

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

        Context "File logging enabled" {
            # arrange
            $Script:Settings.File.Enabled = $true

            Context "File LogLevel >= LogLevel" {
                It "returns [True]" {
                    # arrange
                    $Script:Settings.File.LogLevel = [Levels]::Debug
                    # act
                    $Actual = Test-FileLog -LogLevel Information
                    # assert
                    $Actual | Should -Be $True
                }
            }

            Context "File LogLevel < LogLevel" {
                It "returns [False]" {
                    # arrange
                    $Script:Settings.File.LogLevel = [Levels]::None
                    # act
                    $Actual = Test-FileLog -LogLevel Information
                    # assert
                    $Actual | Should -Be $false
                }
            }
        }

        Context "File logging disabled" {
            It "returns [False]" {
                # arrange
                $Script:Settings.File.Enabled = $false

                #act
                $Actual = Test-FileLog -LogLevel Information
                # assert
                $Actual | Should -Be $false
            }
        }
    }

}
