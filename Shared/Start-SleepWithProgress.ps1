﻿# Sleeps X seconds and displays a progress bar
Function Start-SleepWithProgress {
    Param(
        [Parameter(Mandatory = $true)]
        [int]$SleepTime,

        [string]$Message = "Sleeping"

    )

    # Loop Number of seconds you want to sleep
    For ($i = 0; $i -le $SleepTime; $i++) {
        $timeleft = ($SleepTime - $i);

        # Progress bar showing progress of the sleep
        Write-Progress -Activity $Message -CurrentOperation "$Timeleft More Seconds" -PercentComplete (($i / $sleeptime) * 100) -Status " "

        # Sleep 1 second
        Start-Sleep 1
    }

    Write-Progress -Completed -Activity "Sleeping" -Status " "
}
