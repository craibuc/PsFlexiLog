Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptName = Split-Path -Path $PSCommandPath -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope PsFlexiLog {

    Describe "Write-Log" -Tag 'unit' {
    
        Context "Parameter validation" {
            # act
            $Command = Get-Command "Write-Log"

            Context "Message" {
                $ParameterName = 'Message'

                it "is a [String]" {
                    $Command | Should -HaveParameter $ParameterName -Type string
                }
                it "is mandatory" {
                    $Command | Should -HaveParameter $ParameterName -Mandatory
                }
            }

            Context "LogLevel" {
                $ParameterName = 'LogLevel'

                It "is a [Levels] enum" {
                    $Command | Should -HaveParameter $ParameterName -Type [Levels]
                }
                it "is optional" {
                    $Command | Should -HaveParameter $ParameterName -Not -Mandatory
                }
                It "has a default value of 'Error'" -skip {
                    $true | Should -Be $false
                }
            }

            Context "FunctionName" {
                $ParameterName = 'FunctionName'

                It "is a [String]" {
                    $Command | Should -HaveParameter $ParameterName -Type string
                }
                it "is optional" {
                    $Command | Should -HaveParameter $ParameterName -Not -Mandatory
                }
                It "has a default value of the calling function" -skip {
                    $true | Should -Be $ScriptName
                }
            }

            Context "Exception" {
                $ParameterName = 'Exception'

                it "is an [Exception]" {
                    $Command | Should -HaveParameter $ParameterName -Type exception
                }
                it "is optional" {
                    $Command | Should -HaveParameter $ParameterName -Not -Mandatory
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
                FunctionName = 'Write-Log.Tests.ps1'
                Timestamp = $Now.ToString('HH:mm:ss')
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
                Write-Log -Message $Expected.Message -LogLevel $LogLevel -FunctionName $ScriptName

                # assert
                $ExpectedValue = "[{0}] {1} - {2}" -f $Expected.Timestamp, $Expected.FunctionName, $Expected.Message
                # Write-Debug "ExpectedValue: $ExpectedValue"

                Assert-MockCalled "Write-$LogLevel" -ParameterFilter {
                    # Write-Debug "Message: $Message"
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
                Path = './Write-Log.log'
                Source = 'Source'
                LogLevel = [Levels]::Error
                Message = 'lorem, ipsum'
                Delimiter = ','
                Timestamp = $Now.ToString('yyyy-MM-dd HH:mm:ss')
            }

            BeforeEach {
                # arrange
                Mock Write-Error
                Mock Add-Content # prevents file from being created

                # act
                Initialize-FileLog -Path $Expected.Path -Source $Expected.Source
            }
            AfterEach {
                Reset-FileLog
            }

            Context "With default parameter values" {

                it "calls Add-Content with the expected values" {
                    # act
                    Write-Log -Message $Expected.Message -LogLevel $Expected.LogLevel

                    # assert
                    $ExpectedValue = ($Expected.Timestamp, $Expected.LogLevel.ToString().ToUpper(), "`"$( $Expected.Message )`"") -join $Expected.Delimiter
                    # Write-Debug "ExpectedValue: $ExpectedValue"
                    Assert-MockCalled Add-Content -ParameterFilter {
                        # Write-Debug "Value: $Value"
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
