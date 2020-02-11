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

    .PARAMETER CompressionLevel
    Specify compression level for zip file. Acceptable values are 'NoCompression' or 'Optimal'. Default value is 'NoCompression'.
    Compression is recommanded for extension backup.

    .EXAMPLE
    Backup-VSCode -Path c:\Users\bobby\Desktop -Settings -Extensions

    .EXAMPLE
    Backup-VSCode -Path c:\Users\bobby\Desktop -Settings -Extensions -CompressionLevel Optimal

    .NOTES
    Thanks t0rsten (https://github.com/t0rsten) for the additions
    #>

    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [ValidateScript( { Test-Path -Path $_ })]
        [string]
        $Path = ".\",
        # Parameter help description
        [Parameter()]
        [switch]
        $Settings,
        # Parameter help description
        [Parameter()]
        [switch]
        $Extensions,
        # Parameter help descripton
        [Parameter()]
        [ValidateSet('Optimal', 'NoCompression')]
        $CompressionLevel = 'NoCompression'
    )

    begin {
        $TimeStamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
        $Name = "VSCode-$($TimeStamp).zip"
        $Path = Resolve-Path -Path $Path
    }

    process {
        #Can't read some files while Code is running
        try {
            if ($IsMacOS) {
                Close-Application -ApplicationName "Electron" #On MacOS the process for Code is called Electron.
            }
            else {
                Close-Application -ApplicationName "code"
            }
        }
        catch {
            $_
        }

        $StartTime = Get-Date -Format o
        $CodeDir = Get-CodeDirectory

        if ($Extensions.IsPresent) {
            try {
                Compress-Archive -Path $CodeDir.ExtensionsDirectory -DestinationPath $Path\$Name -Update -CompressionLevel $CompressionLevel
            }
            catch {
                throw $_
            }
        }
        if ($Settings.IsPresent) {
            if ($CodeDir.SettingsFile | Test-Path -ErrorAction SilentlyContinue) {
                try {
                    Compress-Archive -LiteralPath $CodeDir.SettingsFile -DestinationPath $Path\$Name -Update -CompressionLevel $CompressionLevel
                }
                catch {
                    throw $_
                }
            }
            else {
                Write-Error "Settings file is missing, skipping settings file backup"
            }
        }
        $EndTime = Get-Date -Format o
        $ElapsedTime = New-TimeSpan -Start $StartTime -End $EndTime
        $ZippedSize = if (Test-Path "$Path\$Name") { [string]([math]::Round((Get-ChildItem $Path\$Name).Length / 1mb)) + "MB" }else { $null }

        if ($Extensions.IsPresent -or $Settings.IsPresent) {
            [PSCustomObject][ordered]@{
                FileName  = [string]$Name
                FilePath  = [string]$Path
                StartTime = [datetime]$StartTime
                EndTime   = [datetime]$EndTime
                Duration  = $ElapsedTime -replace '\.\d+$'
                Size      = $ZippedSize
            }
        }
        else {
            Write-Warning -Message "Nothing to backup."
        }
    }

    end {
    }
}
