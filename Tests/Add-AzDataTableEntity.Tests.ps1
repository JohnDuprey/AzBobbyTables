param(
    [Parameter()]
    [ValidateScript({ $_ -match '\.psd1$' }, ErrorMessage = 'Please input a .psd1 file')]
    $Manifest
)

BeforeDiscovery {
    . "$PSScriptRoot\CommonTestLogic.ps1"
    Invoke-ModuleReload -Manifest $Manifest
    
    # Get command from current test file name
    $Command = Get-Command ((Split-Path $PSCommandPath -Leaf) -replace '.Tests.ps1')
    $ParameterTestCases += @(
        @{
            Command       = $Command
            Name          = 'Context'
            Type          = 'PipeHow.AzBobbyTables.AzDataTableContext'
            ParameterSets = @(
                @{ Name = '__AllParameterSets'; Mandatory = $true }
            )
        }
        @{
            Command       = $Command
            Name          = 'Entity'
            Type          = 'System.Object[]'
            ParameterSets = @(
                @{ Name = '__AllParameterSets'; Mandatory = $true }
            )
        }
        @{
            Command       = $Command
            Name          = 'Force'
            Type          = 'System.Management.Automation.SwitchParameter'
            ParameterSets = @(
                @{ Name = '__AllParameterSets'; Mandatory = $false }
            )
        }
        @{
            Command       = $Command
            Name          = 'CreateTableIfNotExists'
            Type          = 'System.Management.Automation.SwitchParameter'
            ParameterSets = @(
                @{ Name = '__AllParameterSets'; Mandatory = $false }
            )
        }
    )
}

Describe 'Add-AzDataTableEntity' {
    Context 'parameters' {
        It 'only has expected parameters' -TestCases @{ Command = $Command ; Parameters = $ParameterTestCases.Name } {
            $Command.Parameters.GetEnumerator() | Where-Object {
                $_.Key -notin [System.Management.Automation.Cmdlet]::CommonParameters -and
                $_.Key -notin $Parameters
            } | Should -BeNullOrEmpty
        }

        It 'has parameter <Name> of type <Type>' -TestCases $ParameterTestCases {
            $Command | Should -HaveParameter $Name -Type $Type
        }

        It 'has correct parameter sets for parameter <Name>' -TestCases $ParameterTestCases {
            $Parameter = $Command.Parameters[$Name]
            $Parameter.ParameterSets.Keys | Should -BeExactly $ParameterSets.Name
        }

        foreach ($ParameterTestCase in $ParameterTestCases) {
            foreach ($ParameterSet in $ParameterTestCase.ParameterSets) {
                It 'has parameter <ParameterName> set to mandatory <Mandatory> for parameter set <Name>' -TestCases @{
                    Command       = $ParameterTestCase['Command']
                    ParameterName = $ParameterTestCase['Name']
                    Name          = $ParameterSet['Name']
                    Mandatory     = $ParameterSet['Mandatory']
                } {
                    $Parameter = $Command.Parameters[$ParameterName]
                    $Parameter.ParameterSets[$Name].IsMandatory | Should -Be $Mandatory
                }
            }
        }
    }

    Context 'error handling' {
        BeforeAll {
            $FakeTableName = 'FakeTable'
            $FakeConnectionString = 'FakeStorageString=true'

            $User = @{
                'PartitionKey' = 'AzBobbyTables'
                'RowKey'       = "AzBobbyTables"
                'FirstName'    = "Bobby"
                'LastName'     = "Tables"
            }
        }

        It 'respects ErrorAction' {
            $Context = New-AzDataTableContext -TableName $FakeTableName -ConnectionString $FakeConnectionString
            { Add-AzDataTableEntity -Context $Context -Entity $User -ErrorAction SilentlyContinue } | Should -Not -Throw
            { Add-AzDataTableEntity -Context $Context -Entity $User -ErrorAction Stop } | Should -Throw
        }
    }
}