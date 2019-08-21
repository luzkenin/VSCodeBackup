[![Build status](https://ci.appveyor.com/api/projects/status/pmxqbaxof9xnl78x?svg=true)](https://ci.appveyor.com/project/luzkenin/VSCodeBackup)
[![PSGallery Version](https://img.shields.io/powershellgallery/v/VSCodeBackup.png?style=flat&logo=powershell&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/VSCodeBackup)

# VSCodeBackup

Simple module to backup and restore VS Code extensions and settings. Useful for transferring to an offline network. PS Core is supported.

Authored by Joseph Warren

## GitPitch PitchMe presentation

* [gitpitch.com/luzkenin/VSCodeBackup](https://gitpitch.com/luzkenin/VSCodeBackup)

## Getting Started

Run the following to install VSCodeBackup from the PowerShell Gallery (to install on a server or for all users, remove the `-Scope` parameter and run in an elevated session):

```powershell
Install-Module VSCodeBackup -Scope CurrentUser
```

## Usage scenarios

- Transferring to an offline network
- Easily migrating your settings from computer to computer
- Easily update to VS Code Insiders and keep all of your settings

## Usage examples

PowerShell v5.1 and above required.

`Backup-VSCode -Path c:\Users\bobby\Desktop -Settings -Extensions`

Backs up settings and extension to a new folder on bobby's desktop

`Restore-VSCode -Path .\VSCode-2019-01-31T23.33.58.3351871+01.00.zip -Settings -Extensions`

Restores settings and extensions from the VSCode-2019-01-31T23.33.58.3351871+01.00.zip

## More Information

For more information

* [VSCodeBackup.readthedocs.io](http://VSCodeBackup.readthedocs.io)
* [github.com/luzkenin/VSCodeBackup](https://github.com/luzkenin/VSCodeBackup)
* [luzkenin.github.io](https://luzkenin.github.io)
