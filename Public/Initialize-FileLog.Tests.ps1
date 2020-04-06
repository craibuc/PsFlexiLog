$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Initialize-FileLog" -Tag 'unit' {

    Context "Parameter validation" {
        Context "Path" {
            It "it is a string" {
                Get-Command "Initialize-FileLog" | Should -HaveParameter 'Path' -Type string
            }
        }

        Context "LogLevel" {
            It "it is an enumeration of type Levels" {
                Get-Command "Initialize-FileLog" | Should -HaveParameter 'LogLevel' -Type [Levels]
            }
            It "its default value is 'Information'" -skip {
                $true | Should -Be $false
            }
        }

        Context "Delimiter" {
            It "it is a string" {
                Get-Command "Initialize-FileLog" | Should -HaveParameter 'Delimiter' -Type string
            }
            It "its default value is ','" -skip {
                $true | Should -Be $false
            }
        }

    }

    InModuleScope 'PsFlexiLog' {

        # arrange
        $Path = '~/Desktop/error.log'

        Context "Default parameter values" {

            it "sets the script-level variables correctly" {
                # act
                Initialize-FileLog -Path $Path

                # assert
                $Script:Settings.File.Enabled | Should -Be $true
                $Script:Settings.File.LogLevel | Should -Be Error
                $Script:Settings.File.Path | Should -Be $Path
                $Script:Settings.File.Delimiter| Should -Be ','
            }

        }

        Context "-LogLevel" {

            it "sets the script-level variables correctly" {
                # arrange
                $LogLevel = [Levels]::Information

                # act
                Initialize-FileLog -Path $Path -LogLevel $LogLevel

                # assert
                $Script:Settings.File.LogLevel | Should -Be Information
            }

        }

        Context "-Delimiter" {

            it "sets the script-level variables correctly" {
                # arrange
                $Delimiter = ';'

                # act
                Initialize-FileLog -Path $Path -Delimiter $Delimiter

                # assert
                $Script:Settings.File.Delimiter| Should -Be $Delimiter
            }

        }

    }

}
