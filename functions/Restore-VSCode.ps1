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
    }
    
    process {
        #Can't write some files while Code is running
        $CodeRunning = Get-Process code -ErrorAction SilentlyContinue
        
        if($CodeRunning) {
            Write-Verbose "Closing VS Code"
            $CodeRunning.CloseMainWindow() | Out-Null
        }

        $ExtenionsDirectory = "$env:USERPROFILE\.vscode"
        $SettingsDirectory = "$env:APPDATA\Code\User\settings.json"

        Expand-Archive -Path $Path -DestinationPath $env:TEMP
        if($Extensions) {
            Copy-Item -Path "$env:TEMP\.vscode" -Destination $Extensions -Force -Recurse
        }
        if($Settings) {
            Copy-Item -LiteralPath "$env:TEMP\settings.json" -Destination $Settings -Force
        }
    }
    
    end {
    }
}