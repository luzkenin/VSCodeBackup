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
        $Extensions
    )

    begin {
        $Path = Resolve-Path -Path $Path
        $TempPath = [system.io.path]::GetTempPath()
        $CodeDir = Get-CodeDirectory
        $CodeRunning = Get-Process -Name "code" -ErrorAction SilentlyContinue
    }

    process {
        if ($CodeRunning) {
            #Can't write some files while Code is running
            Write-Verbose "Closing VS Code"
            try {
                if ($Pscmdlet.ShouldProcess("VS Code", "Closing VS Code")) {
                    Close-Application -ApplicationName "code"
                }
            }
            catch {
                $_
            }
        }

        try {
            if ($Pscmdlet.ShouldProcess($TempPath, "Expanding VS Code archive to temp destination")) {
                Expand-Archive -Path $Path -DestinationPath $TempPath -force
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
    }

    end {
    }
}