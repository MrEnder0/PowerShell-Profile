Import-Module -Name Terminal-Icons
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin.omp.json" | Invoke-Expression


# Import custom commnads
Import-Module Share
Import-Module Extract

# Define super important commands
function reload {
	Write-Output("Reloading Proile")
    & $profile
}

function Sudo ($command) {
    Start-Process -FilePath pwsh -ArgumentList "-Command $command" -Verb RunAs
}
