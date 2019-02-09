function Close-Application {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ApplicationName,
        [Parameter()]
        [string]
        $TimeOut = "60"
    )

    begin {
    }

    process {
        if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true ) {
            throw "This module requires elevation."
        }

        $ApplicationName = $ApplicationName -replace "\*", ""
        $Timeout = New-TimeSpan -Seconds $TimeOut
        $StopWatch = [diagnostics.stopwatch]::StartNew()
        $ApplicationRunning = Get-Process -Name "*$($ApplicationName)*" -ErrorAction SilentlyContinue
        if ($ApplicationRunning) {
            do {
                $ApplicationRunning = Get-Process -Name "*$($ApplicationName)*" -ErrorAction SilentlyContinue
                foreach ($App in $ApplicationRunning) {
                    $App.CloseMainWindow() | Out-Null
                }
            } while (($ApplicationRunning.HasExited -contains $false) -and ($StopWatch.elapsed -lt $timeout))
            Start-Sleep -Milliseconds 500
            if ($ApplicationRunning.HasExited -contains $false) {
                Write-Error "Could not close all instances of $($ApplicationName)"
            }
        }
        else {
            Write-Verbose "$($ApplicationName) was not open"
        }
    }

    end {
    }
}