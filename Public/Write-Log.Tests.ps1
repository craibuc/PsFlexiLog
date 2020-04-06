Import-Module PsFlexiLog -Force

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

InModuleScope PsFlexiLog {

    Describe "Write-Log" {

        # arrange
        $DefaultMessage = 'lorem ipsum'

        # ensure that time doesn't vary when running the tests
        $Now = (Get-Date)
        Mock Get-Date { $Now }
        $Timestamp = $Now.ToString('yyyy-MM-dd HH:mm:ss')
    
        Context "Parameter validation" {

            Context "-Message" {
                it "is a [String]" {
                    Get-Command "Write-Log" | Should -HaveParameter 'Message' -Type string
                }
                it "is mandatory" {
                    Get-Command "Write-Log" | Should -HaveParameter 'Message' -Mandatory
                }
            }

            Context "-LogLevel" {
                It "is a [Levels] enum" {
                    Get-Command "Write-Log" | Should -HaveParameter 'LogLevel' -Type [Levels]
                }
                it "is optional" {
                    Get-Command "Write-Log" | Should -HaveParameter 'LogLevel' -Not -Mandatory
                }
                It "has a default value of 'Error'" -skip {
                    $true | Should -Be $false
                }
            }

            Context "-Exception" {
                it "is an [Exception]" {
                    Get-Command "Write-Log" | Should -HaveParameter 'Exception' -Type exception
                }
                it "is optional" {
                    Get-Command "Write-Log" | Should -HaveParameter 'Exception' -Not -Mandatory
                }
            }

        }

        Context "Console logging enabled" {

            BeforeEach {
                Initialize-ConsoleLog
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
                $Expected = "{0} - {1} - {2}" -f $Timestamp, $LogLevel.ToString().ToUpper(), $DefaultMessage

                Mock "Write-$LogLevel"

                # act
                Write-Log -Message $DefaultMessage -LogLevel $LogLevel

                # assert
                Assert-MockCalled "Write-$LogLevel" -ParameterFilter {
                    $Message -eq $Expected
                }
            }
        }

        Context "File logging enabled" {

            # arrange
            $DefaultPath = './test.log'
            $DefaultDelimiter = ','
            $LogLevel = [Levels]::Error

            BeforeEach {
                Initialize-FileLog -Path $DefaultPath
            }

            Context "With default parameter values" {

                it "calls Add-Content with the expected values" {
                    # arrange
                    Mock Add-Content

                    # act
                    Write-Log -Message $DefaultMessage -LogLevel $LogLevel

                    # assert
                    $Expected = ($Timestamp, $LogLevel.ToString().ToUpper(), $DefaultMessage) -join $DefaultDelimiter

                    Assert-MockCalled Add-Content -ParameterFilter {
                        $Value -like "*$Expected"
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
