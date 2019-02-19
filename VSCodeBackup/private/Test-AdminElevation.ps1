function Test-AdminElevation {
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }

    end {
    }
}