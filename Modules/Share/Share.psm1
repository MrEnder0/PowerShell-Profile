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

Export-ModuleMember -Function Share
