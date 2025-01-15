function Streak {
    try {
        # Get the username and set the path for the streak file
        $userName = ($((Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty UserName) -split '\\')[-1])
        $streakPath = "C:\Users\$userName\Documents\PowerShell\Streak"
        $streakFile = Join-Path -Path $streakPath -ChildPath "streak.txt"

        # Ensure the directory exists
        if (-not (Test-Path -Path $streakPath)) {
            New-Item -ItemType Directory -Path $streakPath -Force | Out-Null
        }

        # Check if the streak file exists, create it if it doesn't
        if (-not (Test-Path -Path $streakFile)) {
            Set-Content -Path $streakFile -Value "1|$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "Streak file created. Your streak: 1" -ForegroundColor Green
            return
        }

        # Read the current streak and date
        $streakData = Get-Content -Path $streakFile -ErrorAction Stop
        $currentStreak, $lastDate = $streakData -split '\|'

        # Calculate the time difference
        $lastDateTime = [datetime]::Parse($lastDate)
        $timeDiff = (Get-Date) - $lastDateTime

        if ($timeDiff.TotalHours -lt 24) {
            # Inform the user if it's too soon to update and show the current streak
            Write-Host "You can only update the streak once every 24 hours. Your current streak: $currentStreak" -ForegroundColor Yellow
        } elseif ($timeDiff.TotalHours -gt 24 * 2) {
            # Reset the streak if it's older than 48 hours
            Set-Content -Path $streakFile -Value "1|$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "Streak reset due to inactivity. Your streak: 1" -ForegroundColor Red
        } else {
            # Increment the streak
            $newStreak = [int]$currentStreak + 1
            Set-Content -Path $streakFile -Value "$newStreak|$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "Streak updated. Your streak: $newStreak" -ForegroundColor Green
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Streak
