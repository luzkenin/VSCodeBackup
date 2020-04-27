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

    .PARAMETER Snippets
    Switch to restore snippets

    .EXAMPLE
    Restore-VSCode -Path .\VSCode-2019-01-31T23.33.58.3351871+01.00.zip -Settings -Extensions

    .EXAMPLE
    Restore-VSCode -Path .\VSCode-2019-01-31T23.33.58.3351871+01.00.zip -Settings -Extensions -Snippets

    .NOTES
    General notes
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Path to zip file
        [Parameter(Mandatory)]
        [ValidateScript( { Test-Path -Path $_ })]
        [string]
        $Path,
        # Parameter help description
        [Parameter()]
        [switch]
        $Settings,
        # Parameter help description
        [Parameter()]
        [switch]
        $Extensions,
        # Parameter help description
        [Parameter()]
        [switch]
        $Snippets
    )

    begin {
        $Path = Resolve-Path -Path $Path
        $TempPath = [system.io.path]::GetTempPath()
        $CodeDir = Get-CodeDirectory
        #$CodeRunning = Get-Process -Name "code" -ErrorAction SilentlyContinue
        $StartTime = Get-Date -Format o
    }

    process {
        #Can't write some files while Code is running
        Write-Verbose "Closing VS Code"
        try {
            if ($Pscmdlet.ShouldProcess("VS Code", "Closing VS Code")) {
                if ($IsMacOS) {
                    Close-Application -ApplicationName "Electron" #On MacOS the process for Code is called Electron.
                }
                else {
                    Close-Application -ApplicationName "code"
                }
            }
        }
        catch {
            $_
        }

        try {
            if ($Pscmdlet.ShouldProcess($TempPath, "Expanding VS Code archive to temp destination")) {
                Expand-Archive -Path $Path -DestinationPath $TempPath -Force
            }
        }
        catch {
            throw $_
        }

        if ($Extensions.IsPresent) {
            if ($Pscmdlet.ShouldProcess($CodeDir.ExtensionsDirectory, "Copying extensions to extenions folder")) {
                Copy-Item -Path "$TempPath\.vscode\extensions" -Destination $CodeDir.ExtensionsDirectory -Force -Recurse
            }
        }
        if ($Settings.IsPresent) {
            if ($Pscmdlet.ShouldProcess($CodeDir.SettingsFile, "Copying settings")) {
                Copy-Item -LiteralPath "$TempPath\settings.json" -Destination $CodeDir.SettingsFile -Force
            }
        }
        if ($Snippets.IsPresent) {
            if ($Pscmdlet.ShouldProcess($CodeDir.SnippetsDirectory, "Copying Snippets Directory")) {
                Copy-Item -LiteralPath "$TempPath\Snippets" -Destination $($CodeDir.SnippetsDirectory | Split-Path -Parent) -Force -Recurse
            }
        }
        $EndTime = Get-Date -Format o
        $ElapsedTime = New-TimeSpan -Start $StartTime -End $EndTime
        $ZippedSize = if (Test-Path "$Path") { [string]([math]::Round((Get-ChildItem $Path).Length / 1mb)) + "MB" }else { $null }

        if ($Extensions.IsPresent -or $Settings.IsPresent -or $Snippets.IsPresent) {
            [PSCustomObject][ordered]@{
                FilePath  = [string]$Path
                StartTime = [datetime]$StartTime
                EndTime   = [datetime]$EndTime
                Duration  = $ElapsedTime -replace '\.\d+$'
                Size      = $ZippedSize
            }
        }
        else {
            Write-Warning -Message "Nothing to restore."
        }
    }

    end {
    }
}
