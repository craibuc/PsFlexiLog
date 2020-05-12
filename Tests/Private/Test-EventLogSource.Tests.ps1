# /PsFlexiLog
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFlexiLog/PsFlexiLog/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsFlexiLog/Private/"

# /PsFlexiLog/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Test-EventLogSource.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFlexiLog/PsFlexiLog/Private/Test-EventLogSource.ps1
. (Join-Path $PrivatePath $sut)

Import-Module (Join-Path $ProjectDirectory PsFlexiLog) -Force

Describe "Test-EventLogSource" -Tag 'unit' {

    Context "Event source exists" {
        It "returns $true" {
            $Actual = Test-EventLogSource 'SceCli'
            $Actual | Should -Be $true
        }
    
    }

    Context "Event source does not exists" {
        It "returns $faflse" {
            $Actual = Test-EventLogSource 'dummy'
            $Actual | Should -Be $false
        }
    
    }

}
