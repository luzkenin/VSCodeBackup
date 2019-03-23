function Backup-VSCode {
    <#
    .SYNOPSIS
    Backup VS Code settings and extensions

    .DESCRIPTION
    Backup VS Code settings and extensions

    .PARAMETER Path
    Location to store zip file

    .PARAMETER Settings
    Switch to backup settings

    .PARAMETER Extensions
    Switch to backup extensions

    .EXAMPLE
    Backup-VSCode -Path c:\Users\bobby\Desktop -Settings -Extensions

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
        $TimeStamp = Get-Date -Format o | ForEach-Object {$_ -replace ":", "."}
        $Name = "VSCode-$($TimeStamp).zip"
        $Path = Resolve-Path -Path $Path
    }

    process {
        #Can't read some files while Code is running
        try {
            Close-Application -ApplicationName "code"
        }
        catch {
            $_
        }

        $StartTime = Get-Date -Format o
        $ExtensionsDirectory = "$env:USERPROFILE\.vscode" | Resolve-Path
        $SettingsDirectory = "$env:APPDATA\Code\User\settings.json" | Resolve-Path
        if ($Extensions.IsPresent) {
            try {
                Compress-Archive -Path $ExtensionsDirectory -DestinationPath $Path\$Name -Update -CompressionLevel NoCompression
            }
            catch {
                throw $_
            }
        }
        if ($Settings.IsPresent) {
            try {
                Compress-Archive -LiteralPath $SettingsDirectory -DestinationPath $Path\$Name -Update -CompressionLevel NoCompression
            }
            catch {
                throw $_
            }
        }
        $EndTime = Get-Date -Format o
        $ElapsedTime = New-TimeSpan -Start $StartTime -End $EndTime
        $ZippedSize = if (Test-Path "$Path\$Name") {[string]([math]::Round((Get-ChildItem $Path\$Name).Length / 1mb)) + "MB"}else {$null}

        if ($Extensions.IsPresent -or $Settings.IsPresent) {
            [PSCustomObject]@{
                FileName  = [string]$Name
                FilePath  = [string]$Path
                StartTime = [datetime]$StartTime
                Duration  = $ElapsedTime -replace '\.\d+$'
                EndTime   = [datetime]$EndTime
                Size      = $ZippedSize
            }
        }
        else {
            Write-warning -Message "Nothing to backup."
        }
    }

    end {
    }
}
