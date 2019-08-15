if (Test-Path -Path "C:\MyProjects") {
    Import-Module C:\MyProjects\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force 
}
else {
    Import-Module C:\git\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
}

InModuleScope 'VSCodeBackup' {
    Describe "Close-Application" -Tag 'Build' {
        Context "Closes the application" {
            & notepad

            It "should close notepad" {
                $Notepad = Get-Process -Name "notepad"
                Close-Application -ApplicationName "notepad"
                $Notepad.HasExited | Should be $true
            }
        }
    }
}
