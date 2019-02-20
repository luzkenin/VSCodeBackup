Import-Module C:\MyProjects\VSCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
InModuleScope 'VSCodeBackup' {
    Describe "Close-Application" -Tag 'Build' {
        Context "Closes the application" {
            Start-Process -FilePath notepad

            It "should close notepad" {
                $Notepad = Get-Process -Name "notepad"
                Close-Application -ApplicationName "notepad"
                $Notepad.HasExited | Should be $true
            }
        }
    }
}
