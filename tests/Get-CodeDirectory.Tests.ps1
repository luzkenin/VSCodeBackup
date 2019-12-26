#"$env:USERPROFILE\.vscode" | Resolve-Path -ErrorAction Stop
#$SettingsDirectory = "$env:APPDATA\Code\User" | Resolve-Path -ErrorAction Stop
#$SettingsFile = "$SettingsDirectory\settings.json"


if (Test-Path -Path "C:\MyProjects") {
    Import-Module C:\MyProjects\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
}
else {
    Import-Module C:\git\VsCodeBackup\VSCodeBackup\VSCodeBackup.psd1 -Force
}

$SettingsDirectory = "$env:APPDATA\Code\User"

if ($False -eq (Test-Path -Path "$env:USERPROFILE\.vscode")) {
    New-Item -Path "$env:USERPROFILE\.vscode" -ItemType Directory
}

if ($False -eq (Test-Path -Path "$env:APPDATA\Code\User")) {
    New-Item -Path "$env:APPDATA\Code\User" -ItemType Directory
}

if ($False -eq (Test-Path -Path "$SettingsDirectory\settings.json")) {
    New-Item -Path "$SettingsDirectory\settings.json" -ItemType File
}


InModuleScope 'VSCodeBackup' {
    Describe "Get-CodeDirectory" -Tag 'Build' {
        Context "Tests getting code directory" {
            It "should return true or false" {
                $CodeDirectory = Get-CodeDirectory

                $CodeDirectory.ExtensionsDirectory | Should -Be "$env:USERPROFILE\.vscode"
                $CodeDirectory.SettingsDirectory | Should -Be "$env:APPDATA\Code\User"
                $CodeDirectory.SettingsFile | Should -Be "$SettingsDirectory\settings.json"
            }
        }
    }
}