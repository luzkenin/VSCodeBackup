function Close-Application {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ApplicationName,
        [Parameter()]
        $TimeOut = 60
    )

    begin {
    }

    process {
        $Timeout = New-TimeSpan -Seconds $TimeOut
        $StopWatch = [diagnostics.stopwatch]::StartNew()

        while ($true -and ($StopWatch.elapsed -lt $Timeout)) {
            Try {
                $ApplicationRunning = Get-Process $ApplicationName -ErrorAction Stop
            }
            Catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
                break;
            }
            if ($ApplicationRunning) {
                if ($PSVersionTable.Platform -notlike "*Unix*") {
                    $ApplicationRunning.CloseMainWindow() | Out-Null
                }
                elseif ($PSVersionTable.Platform -notlike "*Windows*") {
                    $ApplicationRunning | Stop-Process -Force
                }
                else {
                    Write-Error "Could not determine platform"
                }
            }
            else {
                break
            }
            Start-Sleep -m 500
        }

        if ($null -ne (Get-Process $ApplicationName -ErrorAction SilentlyContinue)) {
            Write-Error "Could not close $($ApplicationName)"
        }
    }

    end {
        if ($StopWatch.IsRunning) {
            $StopWatch.Stop()
        }
    }
}