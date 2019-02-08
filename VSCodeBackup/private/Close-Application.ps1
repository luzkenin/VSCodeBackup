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
        if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true ) {
            throw "This module requires elevation."
        }
    }

    process {
        $ApplicationName = $ApplicationName -replace "\*", ""
        $Timeout = New-TimeSpan -Seconds $TimeOut
        $StopWatch = [diagnostics.stopwatch]::StartNew()

        do {
            $ApplicationRunning = Get-Process -Name "*$($ApplicationName)*" -ErrorAction SilentlyContinue
            foreach ($App in $ApplicationRunning) {
                $App.CloseMainWindow() | Out-Null
            }
        } while ($true -and $StopWatch.elapsed -lt $timeout)

        if ($null -ne (Get-Process $ApplicationName -ErrorAction SilentlyContinue)) {
            Write-Error "Could not close $($ApplicationName)"
        }
    }

    end {
    }
}