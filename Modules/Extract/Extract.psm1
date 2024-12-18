function Extract {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$File,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$OutputDir
    )

    try {
        # Get path for output
        $fullPath = Resolve-Path -Path $File
        $outputDirectory = if ($OutputDir) { $OutputDir } else { (Get-Item $fullPath).Basename }

        Write-Output "Extracting '$fullPath' to '$outputDirectory'..."

        # Check output directory exists
        if (-not (Test-Path $outputDirectory)) {
            New-Item -Force -ItemType Directory -Path $outputDirectory | Out-Null
        }

        # Perform the extraction
        Expand-Archive -Path $fullPath -DestinationPath $outputDirectory -Force -Verbose

        Write-Output "Extraction completed successfully: $outputDirectory"
    } catch {
        Write-Error "An error occurred: $_"
    }
}

Export-ModuleMember -Function Extract
