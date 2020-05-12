Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope 'PsFlexiLog' {

    Describe "Initialize-FileLog" -Tag 'unit' {

        Context "Parameter validation" {
            Context "-Path" {
                It "is a [String]" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'Path' -Type string
                }
                It "is mandatory" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'Path' -Mandatory
                }
            } # /context

            Context "-Source" {
                It "is a [String]" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'Source' -Type string
                }
                It "is mandatory" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'Source' -Mandatory
                }
            } # /context

            Context "-LogLevel" {
                It "is [Levels] enumeration" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'LogLevel' -Type [Levels]
                }
                It "is optional" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'LogLevel' -Not -Mandatory
                }
                It "has a default value of 'Information'" -skip {
                    $true | Should -Be $false
                }
            } # /context

            Context "-Delimiter" {
                It "is a [String]" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'Delimiter' -Type string
                }
                It "is optional" {
                    Get-Command "Initialize-FileLog" | Should -HaveParameter 'Delimiter' -Not -Mandatory
                }
                It "has adefault value of ','" -skip {
                    $true | Should -Be $false
                }
            } # /context

        } # /context

        # arrange
        $Path = "~/Desktop/error.$( (Get-Date).ToString("o") ).log"
        $Source = 'DoSomething'

        Context "Default parameter values" {

            BeforeEach {
                # arrange
                Mock Add-Content
                # act
                Initialize-FileLog -Path $Path -Source $Source
            }

            it "sets the script-level variables correctly" {
                # assert
                $Script:Settings.File.Enabled | Should -Be $true
                $Script:Settings.File.LogLevel | Should -Be Error
                $Script:Settings.File.Path | Should -Be $Path
                $Script:Settings.File.Source | Should -Be $Source
                $Script:Settings.File.Delimiter| Should -Be ','
            }

            it "adds a header row to the log file" {
                # arrange
                $ExpectedValue = ( $Script:Settings.File.Columns -join $Script:Settings.File.Delimiter )

                # assert
                Assert-MockCalled Add-Content -ParameterFilter {
                    $Value -eq $ExpectedValue
                }
            }

        } # /context

        Context "-LogLevel" {

            BeforeEach {
                # arrange
                Mock Add-Content
            }
    
            it "sets the script-level variables correctly" {
                # arrange
                $LogLevel = [Levels]::Information

                # act
                Initialize-FileLog -Path $Path -Source $Source -LogLevel $LogLevel

                # assert
                $Script:Settings.File.LogLevel | Should -Be Information
            }

        } # /context

        Context "-Delimiter" {

            BeforeEach {
                # arrange
                Mock Add-Content
            }
    
            it "sets the script-level variables correctly" {
                # arrange
                $Delimiter = ';'

                # act
                Initialize-FileLog -Path $Path -Source $Source -Delimiter $Delimiter

                # assert
                $Script:Settings.File.Delimiter| Should -Be $Delimiter
            }

        } # /context

    } # /describe

} # /scope
