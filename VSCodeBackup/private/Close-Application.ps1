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
                if ($IsMacOS) {
                    $ApplicationRunning = Get-Process $ApplicationName -ErrorAction SilentlyContinue | Where-Object path -like "*visual studio*" #I don't like this approach since it makes this function less general
                }
                else {
                    $ApplicationRunning = Get-Process $ApplicationName -ErrorAction SilentlyContinue
                }
            }
            Catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
                break;
            }
            if ($ApplicationRunning) {
                if (($IsWindows) -or ($PSVersionTable.PSVersion.Major -le 5)) {
                    $ApplicationRunning.CloseMainWindow() | Out-Null
                }
                elseif ($IsLinux -or $IsMacOS) {
                    $ApplicationRunning | Stop-Process -Force
                }
                elseif ($PSVersionTable.PSVersion.Major -le 5) {
                    $ApplicationRunning.CloseMainWindow() | Out-Null
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