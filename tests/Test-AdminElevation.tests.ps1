if (Test-Path -Path "C:\MyProjects") {
    Import-Module C:\MyProjects\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
}
else {
    Import-Module C:\git\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
}

InModuleScope 'VSCodeBackup' {
    Describe "Test-AdminElevation" -Tag 'Build' {
        Context "Tests admin elevation" {
            It "should return true or false" {
                $TestElevation = Test-AdminElevation
                $TestElevation | Should -Not -BeNullOrEmpty
            }
        }
    }
}