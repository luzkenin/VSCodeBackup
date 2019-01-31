function Backup-VSCode {
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
        $TimeStamp = Get-Date -Format o | foreach {$_ -replace ":", "."}
        $Name = "VSCode-$($TimeStamp).zip"
    }
    
    process {
        $CodeRunning = Get-Process code
        
        if($CodeRunning) {
            Write-Verbose "Closing VS Code"
            $CodeRunning.CloseMainWindow() | Out-Null
        }

        $ExtenionsDirectory = "$env:USERPROFILE\.vscode"
        $SettingsDirectory = "$env:APPDATA\Code\User\settings.json"
        if($Extensions) {
            try {
                Compress-Archive -Path $ExtenionsDirectory -DestinationPath $Path\$Name -Update -CompressionLevel NoCompression
            }
            catch {
                throw $_
            }
        }
        if($Settings) {
            try {
                Compress-Archive -LiteralPath $SettingsDirectory -DestinationPath $Path\$Name -Update
            }
            catch {
                throw $_
            }
        }
    }
    
    end {
    }
}