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
        if ($PSVersionTable.PSEdition -eq 'Core') {
            if ($IsLinux) {
                $ExtensionsDirectory = "$HOME/.vscode"
                $SettingsDirectory = "$HOME/.config/Code/User"
            }
            elseif ($IsMacOS) {
                $ExtensionsDirectory = "$HOME/.vscode"
                $SettingsDirectory = "$HOME/Library/Application Support/Code/User"
            }
            elseif ($IsWindows) {
                $ExtensionsDirectory = "$env:USERPROFILE\.vscode"
                $SettingsDirectory = "$env:APPDATA\Code\User"
            }
        }
        else {
            $ExtensionsDirectory = "$env:USERPROFILE\.vscode"
            $SettingsDirectory = "$env:APPDATA\Code\User"
        }
        [PSCustomObject]@{
            ExtensionsDirectory = $ExtensionsDirectory
            SettingsDirectory   = $SettingsDirectory
            SettingsFile        = "$SettingsDirectory\settings.json"
        }
    }

    end {
    }
}