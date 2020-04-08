Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope PsFlexiLog {

    Describe "Write-Log" -Tag 'unit' {
    
        Context "Parameter validation" {
            # act
            $Command = Get-Command "Write-Log"

            Context "-Message" {
                it "is a [String]" {
                    $Command | Should -HaveParameter 'Message' -Type string
                }
                it "is mandatory" {
                    $Command | Should -HaveParameter 'Message' -Mandatory
                }
            }

            Context "-LogLevel" {
                It "is a [Levels] enum" {
                    $Command | Should -HaveParameter 'LogLevel' -Type [Levels]
                }
                it "is optional" {
                    $Command | Should -HaveParameter 'LogLevel' -Not -Mandatory
                }
                It "has a default value of 'Error'" -skip {
                    $true | Should -Be $false
                }
            }

            Context "-Exception" {
                it "is an [Exception]" {
                    $Command | Should -HaveParameter 'Exception' -Type exception
                }
                it "is optional" {
                    $Command | Should -HaveParameter 'Exception' -Not -Mandatory
                }
            }

        }

        Context "Console logging enabled" {

            # arrange
            # ensure that time doesn't vary when running the tests
            $Now = (Get-Date)
            Mock Get-Date { $Now }

            $Expected = [pscustomobject]@{
                LogLevel = [Levels]::Error
                Message = 'lorem ipsum'
                Timestamp = $Now.ToString('yyyy-MM-dd HH:mm:ss')
            }

            BeforeEach {
                Initialize-ConsoleLog -LogLevel Debug # use most verbose
            }
            AfterEach {
                Reset-ConsoleLog
            }

            $TestCases = @( 
                @{ LogLevel = [Levels]::Error }
                @{ LogLevel = [Levels]::Warning }
                @{ LogLevel = [Levels]::Information }
                @{ LogLevel = [Levels]::Debug }
            )

            it "calls Write-<LogLevel> with the expected values" -TestCases $TestCases {
                param ($LogLevel)

                # arrange
                Mock "Write-$LogLevel"

                # act
                Write-Log -Message $Expected.Message -LogLevel $LogLevel

                # assert
                $ExpectedValue = "{0} - {1} - {2}" -f $Expected.Timestamp, $LogLevel.ToString().ToUpper(), $Expected.Message
                Assert-MockCalled "Write-$LogLevel" -ParameterFilter {
                    $Message -eq $ExpectedValue
                }

            }
        }

        Context "File logging enabled" {

            # arrange
            # ensure that time doesn't vary when running the tests
            $Now = (Get-Date)
            Mock Get-Date { $Now }

            $Expected = [pscustomobject]@{
                Path = './test.log'
                Source = 'Source'
                LogLevel = [Levels]::Error
                Message = 'lorem ipsum'
                Delimiter = ','
                Timestamp = $Now.ToString('yyyy-MM-dd HH:mm:ss')
            }

            BeforeEach {
                Initialize-FileLog -Path $Expected.Path -Source $Expected.Source
            }
            AfterEach {
                Reset-FileLog
            }

            Context "With default parameter values" {

                it "calls Add-Content with the expected values" {
                    # arrange
                    Mock Write-Error
                    Mock Add-Content

                    # act
                    Write-Log -Message $Expected.Message -LogLevel $Expected.LogLevel

                    # assert
                    $ExpectedValue = ($Expected.Timestamp, $Expected.LogLevel.ToString().ToUpper(), $Expected.Message) -join $Expected.Delimiter
                    Assert-MockCalled Add-Content -ParameterFilter {
                        $Value -like "*$ExpectedValue*" # beware of ending ','
                    }
                }

            }
        }

        Context "With -Exception" {
            it "adds exception's text to the log" -skip {
            }
        }

    } # /describe

} # /inmodulescope
