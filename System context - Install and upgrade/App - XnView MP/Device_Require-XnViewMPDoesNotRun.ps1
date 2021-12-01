﻿#Requires -Version 5.1
<#
    .SYNOPSIS
        Detects whether XnView MP runs, returns $false if it does.

    .NOTES
        Author:   Olav Rønnestad Birkeland
        Created:  211124
        Modified: 211201

    .EXAMPLE
        & $psISE.CurrentFile.FullPath
#>


# Input parameters
[OutputType([bool])]
Param()


# PowerShell preferences
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'


# Check if running
if (
    $(
        [array](
            Get-Process -Name 'xnviewmp' -ErrorAction 'SilentlyContinue'
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
