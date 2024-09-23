# Define the temporary file path
$tempFile = [System.IO.Path]::Combine($env:TEMP, [System.IO.Path]::GetRandomFileName() + ".txt")

# Run dxdiag and output to the temporary file
Start-Process -FilePath "dxdiag" -ArgumentList "/t", $tempFile -Wait

# Check if the file exists
if (Test-Path $tempFile) {
    # Read and display relevant information
    $dxdiagContent = Get-Content $tempFile
    $displayInfo = $dxdiagContent -match "Card name|Current Mode|Monitor Name|Monitor Model|Monitor Id"
    $displayInfo

    # Clean up the temporary file
    Remove-Item $tempFile
} else {
    Write-Host "dxdiag did not create the output file. Please ensure dxdiag is available on your system."
}
