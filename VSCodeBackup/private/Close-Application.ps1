function Close-Application {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ApplicationName,
        [Parameter()]
        [string]
        $TimeOut = 60
    )

    begin {
    }

    process {
        $Timeout = New-TimeSpan -Seconds $TimeOut
        $StopWatch = [diagnostics.stopwatch]::StartNew()

        do {
            $ApplicationRunning = Get-Process $ApplicationName -ErrorAction SilentlyContinue
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