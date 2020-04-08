Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {

    Describe "Initialize-EventLogLog" -Tag 'unit' {

        Context "Parameter validation" {
            # arrange
            $Command = Get-Command "Initialize-EventLogLog"

            Context "Source" {
                # arrange
                $ParameterName = 'Source'

                It "it is a string" {
                    $Command | Should -HaveParameter $ParameterName -Type string
                }
                It "it is mandatory" {
                    $Command | Should -HaveParameter $ParameterName -Type string -Mandatory
                }
            }

            Context "LogName" {
                # arrange
                $ParameterName = 'LogName'

                It "it is a string" {
                    $Command | Should -HaveParameter $ParameterName -Type string
                }
                It "its default value is 'Application'" -skip {
                    $true | Should -Be $false
                }
            }

            Context "LogLevel" {
                # arrange
                $ParameterName = 'LogLevel'

                It "it is an enumeration of type Levels" {
                    $Command | Should -HaveParameter $ParameterName -Type [Levels]
                }
                It "its default value is 'Error'" -skip {
                    $true | Should -Be $false
                }
            }

        }

        # arrange
        $Source = 'Import-Something'

        Context "Default parameter values" {

            it "sets the script-level variables correctly" -Skip {
                # act
                Initialize-EventLogLog -Source $Source

                # assert
                $Script:Settings.EventLog.Enabled | Should -Be $true
                $Script:Settings.EventLog.LogLevel | Should -Be Error
                $Script:Settings.EventLog.Source | Should -Be $Source
                $Script:Settings.EventLog.LogName| Should -Be 'Application'
            }

        }

        Context "-LogLevel" {

            it "sets the script-level variables correctly" -Skip {
                # arrange
                $LogLevel = [Levels]::Information

                # act
                Initialize-EventLogLog -Source $Source -LogLevel $LogLevel

                # assert
                $Script:Settings.EventLog.LogLevel | Should -Be Information
            }

        }

        Context "-Delimiter" {

            it "sets the script-level variables correctly" -Skip {
                # arrange
                $LogName = 'Another'

                # act
                Initialize-EventLogLog -Source $Source -LogName $LogName

                # assert
                $Script:Settings.EventLog.LogName | Should -Be $LogName
            }

        }

    }

}
