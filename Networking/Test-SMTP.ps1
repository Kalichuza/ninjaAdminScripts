<#
.SYNOPSIS
    Tests an SMTP connection by sending a test email.

.DESCRIPTION
    This script tests an SMTP connection using the provided server, port, and credentials. 
    It sends a test email to verify that the SMTP settings are correct and functional.

.PARAMETER smtpServer
    The SMTP server address. Default is 'smtp-relay.gmail.com'.

.PARAMETER port
    The port number to use for the SMTP connection. Default is 465.

.PARAMETER username
    The username or email address used to authenticate with the SMTP server. Default is 'TaxCopier@Saugertiesny.gov'.

.PARAMETER password
    The password for the SMTP account. This parameter accepts a SecureString.

.PARAMETER useSSL
    A boolean value indicating whether to use SSL/TLS for the connection. Default is $true.

.EXAMPLE
    .\Test-SmtpConnection.ps1 -smtpServer "smtp-relay.gmail.com" -port 587 -username "user@example.com"

    Sends a test email using the specified SMTP server, port 587, and the given username.

.NOTES
    Author: [Your Name]
    Date: August 16, 2024
#>

[CmdletBinding()]
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
