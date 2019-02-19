function Restore-VSCode {
    <#
    .SYNOPSIS
    Restore VS Code from a backup
    
    .DESCRIPTION
    Restore VS Code from a backup
    
    .PARAMETER Path
    Path to backup file
    
    .PARAMETER Settings
    Switch to restore settings
    
    .PARAMETER Extensions
    Switch to restore extensions
    
    .EXAMPLE
    Restore-VSCode -Path .\VSCode-2019-01-31T23.33.58.3351871+01.00.zip -Settings -Extensions
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [ValidateScript( {Test-Path -Path $_})]
        [string]
        $Path,
        # Parameter help description
        [Parameter()]
        [switch]
        $Settings,
        # Parameter help description
        [Parameter()]
        [switch]
        $Extensions
    )
    
    begin {
        $Path = Resolve-Path -Path $Path
    }
    
    process {
        #Can't write some files while Code is running
        try {
            Close-Application -ApplicationName "code"
        }
        catch {
            $_
        }

        $ExtensionsDirectory = "$env:USERPROFILE\.vscode" | Resolve-Path
        $SettingsDirectory = "$env:APPDATA\Code\User\settings.json" | Resolve-Path

        try {
            Expand-Archive -Path $Path -DestinationPath $env:TEMP -force
        }
        catch {
            throw $_
        }
        
        if ($Extensions.IsPresent) {
            Copy-Item -Path "$env:TEMP\.vscode\extensions" -Destination $ExtensionsDirectory -Force -Recurse
        }
        if ($Settings.IsPresent) {
            Copy-Item -LiteralPath "$env:TEMP\settings.json" -Destination $SettingsDirectory -Force
        }
    }
    
    end {
    }
}