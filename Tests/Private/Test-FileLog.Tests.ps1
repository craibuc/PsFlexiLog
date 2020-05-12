Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
