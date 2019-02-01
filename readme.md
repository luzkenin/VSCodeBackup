# VSCodeBackup

    Simple module to backup and restore VS Code extensions and settings. Useful for transferring to an offline network.

    Authored by Joseph Warren

## Installer

VSCodeBackup works on PowerShell Core (aka PowerShell 6+). 

Run the following to install VSCodeBackup from the PowerShell Gallery (to install on a server or for all users, remove the `-Scope` parameter and run in an elevated session):

```powershell
Install-Module VSCodeBackup -Scope CurrentUser
```

## Usage scenarios

- Transferring to an offline network
- Easily migrating your settings from computer to computer
- Easily update to VS Code Insiders and keep all of your settings

## Usage examples

PowerShell v3 and above required.

`Backup-VSCode -Path c:\Users\bobby\Desktop -Settings -Extensions`

Backs up settings and extension to a new folder on bobby's desktop

`Restore-VSCode -Path .\VSCode-2019-01-31T23.33.58.3351871+01.00.zip -Settings -Extensions`

Restores settings and extensions from the VSCode-2019-01-31T23.33.58.3351871+01.00.zip