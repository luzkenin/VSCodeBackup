$script:ModuleName = 'VSCodeBackup'
# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module
$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path
# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Tests') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}
## this variable is for the VSTS tasks and is to be used for refernecing any mock artifacts
$Env:ModuleBase = $ModuleBase
Import-Module $ModuleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop | Out-Null
Describe "Basic function unit tests" -Tags Unit{
    Context "Validate Parameters" {
        $paramCount = 3
        $DefaultParamCount = 11
        [object[]]$params = (Get-ChildItem function:\Backup-VSCode).Parameters.Keys
        $KnownParameters = 'Path', 'Settings', 'Extensions'
        It "Should contain our specific parameters" {
            ( (Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual | Where-Object SideIndicator -eq "==").Count) | Should Be $paramCount
        }
        It "Should only contain $ParamCount parameters" {
            $params.Count - $DefaultParamCount | Should Be $paramCount
        }
    }
}
Describe "Basic function unit tests" -Tags Unit{
    Context "Validate Parameters" {
        $paramCount = 3
        $DefaultParamCount = 11
        [object[]]$params = (Get-ChildItem function:\Restore-VSCode).Parameters.Keys
        $KnownParameters = 'Path', 'Settings', 'Extensions'
        It "Should contain our specific parameters" {
            ( (Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual | Where-Object SideIndicator -eq "==").Count) | Should Be $paramCount
        }
        It "Should only contain $ParamCount parameters" {
            $params.Count - $DefaultParamCount | Should Be $paramCount
        }
    }
}


# clearly don't know what i'm doing here