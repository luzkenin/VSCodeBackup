function Get-CodeDirectory {
    <#Settings file locations

        By default VS Code shows the Settings editor, but you can still edit the underlying settings.json file by using the Open Settings (JSON) command or by changing your default settings editor with the workbench.settings.editor setting.

        Depending on your platform, the user settings file is located here:

            Windows %APPDATA%\Code\User\settings.json
            macOS $HOME/Library/Application Support/Code/User/settings.json
            Linux $HOME/.config/Code/User/settings.json
        #>
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            if ($IsLinux) {
                $ExtensionsDirectory = "$HOME/.vscode" | Resolve-Path -ErrorAction Stop
                $SettingsDirectory = "$HOME/.config/Code/User" | Resolve-Path -ErrorAction Stop
                $SettingsFile = "$SettingsDirectory/settings.json"
            }
            elseif ($IsMacOS) {
                $ExtensionsDirectory = "$HOME/.vscode" | Resolve-Path -ErrorAction Stop
                $SettingsDirectory = "$HOME/Library/Application Support/Code/User" | Resolve-Path -ErrorAction Stop
                $SettingsFile = "$SettingsDirectory/settings.json"
            }
            elseif ($IsWindows) {
                $ExtensionsDirectory = "$env:USERPROFILE\.vscode" | Resolve-Path -ErrorAction Stop
                $SettingsDirectory = "$env:APPDATA\Code\User" | Resolve-Path -ErrorAction Stop
                $SettingsFile = "$SettingsDirectory\settings.json"
            }
        }
        elseif ($PSVersionTable.PSVersion.Major -le 5) {
            $ExtensionsDirectory = "$env:USERPROFILE\.vscode" | Resolve-Path -ErrorAction Stop
            $SettingsDirectory = "$env:APPDATA\Code\User" | Resolve-Path -ErrorAction Stop
            $SettingsFile = "$SettingsDirectory\settings.json"
        }
        [PSCustomObject]@{
            ExtensionsDirectory = $ExtensionsDirectory
            SettingsDirectory   = $SettingsDirectory
            SettingsFile        = $SettingsFile
        }
    }

    end {
    }
}