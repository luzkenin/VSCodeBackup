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

        $ApplicationName = $ApplicationName -replace "\*", ""
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
        }
        else {
            Write-Verbose "$($ApplicationName) was not open"
        }
    }

    end {
        if ($StopWatch.IsRunning) {
            $StopWatch.Stop()
        }
    }
}