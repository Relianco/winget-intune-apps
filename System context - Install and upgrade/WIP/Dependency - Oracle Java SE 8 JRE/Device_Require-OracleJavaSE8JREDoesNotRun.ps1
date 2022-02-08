﻿#Requires -Version 5.1
<#
    .SYNOPSIS
        Confirms that important Java processes are not running.

    .NOTES
        Author:   Olav Rønnestad Birkeland
        Created:  220119
        Modified: 220208

    .EXAMPLE
        & $psISE.CurrentFile.FullPath
        & $psISE.CurrentFile.FullPath -Testing
#>


# Input parameters
[OutputType([bool])]
Param(
    [Parameter(HelpMessage = 'Enabling this breaks Intune Win32 requirement script, so it is off by default.')]
    [switch] $Testing
)


# PowerShell preferences
$ErrorActionPreference = 'Stop'
$InformationPreference = $(if($Testing){'Continue'}else{'SilentlyContinue'})


# Check if running
if (
    $(
        [array](
            Get-Process -Name 'java*','jp2*' | Where-Object -FilterScript {
                $_.'Company' -like 'Oracle*' -and
                $_.'Path' -like '*jre*'
            }
        )
    ).'Count' -le 0
) {
    Write-Information -MessageData 'Not currently running.'
    $true
}
else {
    Write-Information -MessageData 'Currently running.'
    $false
}
