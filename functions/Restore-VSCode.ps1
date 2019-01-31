function Restore-VSCode {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Path
    Parameter description
    
    .PARAMETER Settings
    Parameter description
    
    .PARAMETER Extensions
    Parameter description
    
    .EXAMPLE
    An example
    
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
        $CodeRunning = Get-Process code -ErrorAction SilentlyContinue
        
        if($CodeRunning) {
            Write-Verbose "Closing VS Code"
            $CodeRunning.CloseMainWindow() | Out-Null
        }

        $ExtenionsDirectory = "$env:USERPROFILE\.vscode"
        $SettingsDirectory = "$env:APPDATA\Code\User\settings.json"

        Expand-Archive -Path $Path -DestinationPath $env:TEMP
        if($Extensions) {
            Copy-Item -Path "$env:TEMP\.vscode" -Destination $Extensions -Recurse -Force
        }
        if($Settings) {
            Copy-Item -LiteralPath "$env:TEMP\settings.json" -Destination $Settings -Force
        }
    }
    
    end {
    }
}