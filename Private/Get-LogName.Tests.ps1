$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-LogName" -Tag 'unit' {

    Context "Parameter validation" {
        it "is a [String]" {
            Get-Command "Get-LogName" | Should -HaveParameter 'Source' -Type 'string'
        }
        it "is mandatory" {
            Get-Command "Get-LogName" | Should -HaveParameter 'Source' -Mandatory
        }
    }

    Context "-Source" {

        it "invokes LogNameFromSourceName with the expected parameter" -Skip {
            # arrange
            $DefaultSource = 'Do-Something'

            function LogNameFromSourceName1 { Param([string]$Source) }
            Mock LogNameFromSourceName1

            $EventLog = New-MockObject -Type 'System.Diagnostics.EventLog'
            $EventLog | Add-Member -MemberType ScriptMethod -Name LogNameFromSourceName -Value { LogNameFromSourceName1 } -Force

            # act
            Get-LogName -Source $DefaultSource

            # assert
            Assert-MockCalled LogNameFromSourceName1 -ParameterFilter {
                $Source -eq $DefaultSource
            }

        }

    }

}
