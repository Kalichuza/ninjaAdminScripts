param (
    [string]$smtpServer = "smtp-relay.gmail.com",
    [int]$port = 465,
    [string]$username = "TaxCopier@Saugertiesny.gov",
    [System.Security.SecureString]$password,
    [bool]$useSSL = $true
)

function Test-SmtpConnection {
    param (
        [string]$smtpServer,
        [int]$port,
        [string]$username,
        [System.Security.SecureString]$password,
        [bool]$useSSL
    )

    try {
        $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $port)
        $smtpClient.EnableSsl = $useSSL
        $smtpClient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

        # Create a test email message
        $mailMessage = New-Object System.Net.Mail.MailMessage
        $mailMessage.From = $username
        $mailMessage.To.Add($username)
        $mailMessage.Subject = "Test Email"
        $mailMessage.Body = "This is a test email sent from PowerShell"

        # Send the email
        $smtpClient.Send($mailMessage)

        Write-Host "Email sent successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to send email: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Prompt for password if not provided
if (-not $password) {
    $password = Read-Host -AsSecureString "Enter the SMTP password"
}

Test-SmtpConnection -smtpServer $smtpServer -port $port -username $username -password $password -useSSL $useSSL
