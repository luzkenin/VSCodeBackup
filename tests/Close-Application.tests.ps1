if (Test-Path -Path "C:\MyProjects") {
    Import-Module C:\MyProjects\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force 
}
else {
    Import-Module C:\git\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
}


InModuleScope 'VSCodeBackup' {
    Describe "Close-Application" -Tag 'Build' {
        Context "Closes the application" {
            It "should close notepad" {
                Mock notepad { $false }
                Close-Application -ApplicationName "notepad"
                notepad | Should be $false
            }
        }
    }
}
