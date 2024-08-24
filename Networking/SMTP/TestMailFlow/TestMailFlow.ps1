# Import Chilkat ActiveX Module
Add-Type -Path "C:\path\to\ChilkatDotNet.dll"

# Create a MailMan object
$mailman = New-Object Chilkat.MailMan

# Set SMTP server details
$mailman.SmtpHost = "smtp.example.com"
$mailman.SmtpPort = 587
$mailman.SmtpSsl = $true

# Set login credentials
$mailman.SmtpUsername = "your_email@example.com"
$mailman.SmtpPassword = "your_password"

# Attempt to connect to the SMTP server
if ($mailman.SmtpConnect()) {
    Write-Output "Successfully connected to SMTP server."
} else {
    Write-Output "Failed to connect to SMTP server."
    Write-Output $mailman.LastErrorText
}
