function Share {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $false)]
        [ValidateSet("N", "10M", "1H", "1D", "1W", "2W", "1M")]
        [string]$Expiration = "N"  # Default to never expire
    )

    $userName = ($((Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty UserName) -split '\\')[-1])
    $apiKeyPath = "C:\Users\$userName\Documents\PowerShell\Secrets\pastebin_apikey.txt"

    try {
        if (-not (Test-Path $apiKeyPath)) {
            throw "API key file not found at $apiKeyPath"
        }

        $apiKey = Get-Content -Path $apiKeyPath -Raw | ForEach-Object { $_.Trim() }
        if (-not $apiKey) {
            throw "API key file is empty or invalid."
        }

        $apiUrl = "https://pastebin.com/api/api_post.php"

        $params = @{
            api_dev_key         = $apiKey
            api_option          = "paste"
            api_paste_code      = $Text
            api_paste_expire_date = $Expiration
        }

        # Make the API request
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $params

        # Handle response
        if ($response -like "http*") {
            Write-Host "Your paste is available at: $response" -ForegroundColor Green
        } else {
            throw "API returned an error: $response"
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Share
