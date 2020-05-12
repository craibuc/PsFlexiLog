# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-LogName.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Get-LogName.ps1
. (Join-Path $PrivatePath $sut)

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
