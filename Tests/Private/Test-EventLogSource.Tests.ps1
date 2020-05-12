$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
