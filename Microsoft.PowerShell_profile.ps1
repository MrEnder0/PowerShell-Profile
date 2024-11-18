oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons


function reload {
	Write-Output("Reloading Proile")
    & $profile
}

function unzip ($file) {
    $dirname = (Get-Item $file).Basename
    Write-Output("Extracting", $file, "to", $dirname)
    New-Item -Force -ItemType directory -Path $dirname
    expand-archive $file -OutputPath $dirname -ShowProgress
}

function share ($text) {
    $apiKeyPath = "C:\Users\Ender\Documents\PowerShell\Secrets\pastebin_apikey.txt"
    if (Test-Path $apiKeyPath) {
        $apiKey = Get-Content -Path $apiKeyPath -Raw
        $apiKey = $apiKey.Trim()

        $apiUrl = "https://pastebin.com/api/api_post.php"

        $params = @{
            api_dev_key      = $apiKey
            api_option       = "paste"
            api_paste_code   = $text
            api_paste_format = "text"
        }

        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $params

        if ($response -like "http*") {
            Write-Host "Your paste is available at: $response"
	    } else {
        	Write-Host "An error occurred: $response"
	    }
    } else {
        Write-Host "API key file not found at $apiKeyPath"
    }
}

function Sudo ($command) {
    Start-Process -FilePath pwsh -ArgumentList "-Command $command" -Verb RunAs
}


#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
