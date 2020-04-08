$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Write-EventLogLog" -Tag 'unit' {

    Context "Parameter validation" {

        # act
        $Command = Get-Command "Write-EventLogLog"

        Context "LogName" {
            $ParameterName = 'LogName'

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "has a default value of 'Application'" -skip {
                $true | Should -Be $false
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "Source" {
            $ParameterName = 'Source'

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "it is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "EntryType" {
            $ParameterName = 'EntryType'

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "it is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "has a default value of 'Error'" -skip {
                $true | Should -Be $false
            }
            It "has an alias of 'LogLevel'" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'LogLevel'
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "EventId" {
            $ParameterName = 'EventId'

            It "it is an [Int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
            it "is in a range from 0 to 65535" {
                $ValidateRangeAttribute = $Command.parameters.eventId.attributes | Where-Object {$_.TypeId -eq [System.Management.Automation.ValidateRangeAttribute] }
                $ValidateRangeAttribute.MinRange | Should -Be 0
                $ValidateRangeAttribute.MaxRange | Should -Be 65535
            }
        }

        Context "Message" {
            $ParameterName = 'Message'

            it "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

    } # /context

    Context "Setting parameter values" {

        $Expected = [pscustomobject]@{
            LogName = 'Application'
            Source = 'Do-Something'
            EntryType = 'Information'
            EventId = 1000
            Message = 'lorem ipsum'    
        }

        BeforeEach {
            # arrange
            Mock Write-EventLog

            # act
            Write-EventLogLog -LogName $Expected.LogName -Source $Expected.Source -EntryType $Expected.EntryType -EventId $Expected.EventId -Message $Expected.Message
        }

        It "logs the expected LogName" -skip {
            # assert
            Assert-MockCalled Write-EventLog -ParameterFilter {$LogName -eq $Expected.LogName}
        }
        It "logs the expected Source" -skip {
            # assert
            Assert-MockCalled Write-EventLog -ParameterFilter {$Source -eq $Expected.Source}
        }
        It "logs the expected EntryType" -skip {
            # assert
            Assert-MockCalled Write-EventLog -ParameterFilter {$EntryType -eq $Expected.EntryType}
        }
        It "logs the expected EventId" -skip {
            # assert
            Assert-MockCalled Write-EventLog -ParameterFilter {$EventId -eq $Expected.EventId}
        }
        It "logs the expected Message" -skip {
            # assert
            Assert-MockCalled Write-EventLog -ParameterFilter {$Message -eq $Expected.Message}
        }

    }

}
