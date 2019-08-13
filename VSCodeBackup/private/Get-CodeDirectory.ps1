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
        if ($PSVersionTable.OS -like "*linux*") {
            $ExtensionsDirectory = "$HOME/.vscode" | Resolve-Path
            $SettingsDirectory = "$HOME/.config/Code/User" | Resolve-Path
        }
        elseif ($PSVersionTable.OS -like "*mac*") {
            $ExtensionsDirectory = "$HOME/.vscode" | Resolve-Path
            $SettingsDirectory = "$HOME/Library/Application Support/Code/User" | Resolve-Path
        }
        elseif ($PSVersionTable.OS -like "*windows*") {
            $ExtensionsDirectory = "$env:USERPROFILE\.vscode" | Resolve-Path
            $SettingsDirectory = "$env:APPDATA\Code\User" | Resolve-Path
        }
        [PSCustomObject]@{
            ExtensionsDirectory = $ExtensionsDirectory
            SettingsDirectory   = $SettingsDirectory
            SettingsFile        = "$SettingsDirectory/settings.json" | Resolve-Path -ErrorAction SilentlyContinue
        }
    }
    
    end {
    }
}