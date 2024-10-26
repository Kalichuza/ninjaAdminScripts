Yes, you can retrieve more detailed information about Azure AD users, including properties like their last login time. Unfortunately, the `Get-AzureADUser` cmdlet itself does not provide sign-in activity data. However, you can use other cmdlets and modules to get more detailed information. Specifically, you can use the Microsoft Graph API or the Azure AD module with `Get-MgUser` and `Get-MgUserAuthenticationMethod`.

Here’s how you can get additional information about users, including their last sign-in details:

### Option 1: Using Microsoft Graph PowerShell (`Get-MgUser`)

1. **Install the Microsoft Graph PowerShell module** if you haven't already:

   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser
   ```

2. **Connect to Microsoft Graph**:

   ```powershell
   Connect-MgGraph -Scopes "User.Read.All", "AuditLog.Read.All"
   ```

3. **Get Last Sign-In Information**:

   You can use the following script to get the last sign-in information:

   ```powershell
   Get-MgAuditLogSignIn -Filter "userPrincipalName eq 'Benjamin@newpaltzny.org'" | Select-Object UserPrincipalName, CreatedDateTime, IpAddress, ClientAppUsed
   ```

   Or you can retrieve sign-in logs for all users:

   ```powershell
   Get-MgAuditLogSignIn | Select-Object UserPrincipalName, CreatedDateTime, IpAddress, ClientAppUsed
   ```

### Option 2: Using Azure AD PowerShell (`Get-AzureADAuditSignInLogs`)

The `Get-AzureADAuditSignInLogs` cmdlet allows you to retrieve Azure AD sign-in logs.

1. **Install the AzureAD.Standard.Preview** module:

   ```powershell
   Install-Module AzureAD.Standard.Preview -Scope CurrentUser
   ```

2. **Connect to Azure AD**:

   ```powershell
   Connect-AzureAD
   ```

3. **Retrieve Last Sign-In Information**:

   ```powershell
   Get-AzureADAuditSignInLogs -Top 10 | Where-Object {$_.UserPrincipalName -eq "Benjamin@newpaltzny.org"} | Select-Object UserPrincipalName, CreatedDateTime, IpAddress
   ```

### Example Script to Get User Last Login

Here’s an example of how you could run a script to gather the last login for all users:

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "AuditLog.Read.All"

# Get last login details for all users
$users = Get-MgUser -All
foreach ($user in $users) {
    $signIns = Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$($user.UserPrincipalName)'" -Top 1 | Sort-Object CreatedDateTime -Descending
    if ($signIns) {
        [PSCustomObject]@{
            DisplayName     = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            LastSignIn      = $signIns[0].CreatedDateTime
            IpAddress       = $signIns[0].IpAddress
        }
    }
}
```

### Using Azure Portal
You can also find the last login for users in the Azure Portal:

1. Go to **Azure Active Directory** in the Azure Portal.
2. Navigate to **Users** > **Sign-ins**.
3. Here, you will find the last sign-in information for users, including details like client app used, location, and device.

### Notes
- The Microsoft Graph API provides more flexible and detailed user and audit log information compared to Azure AD cmdlets.
- You need the appropriate permissions (`AuditLog.Read.All` or similar) to access sign-in information.
- The `Get-MgAuditLogSignIn` and `Get-AzureADAuditSignInLogs` methods will typically take a few minutes to reflect user sign-in data due to some latency in the audit logging process.

This should give you the user details, including last sign-in activity, which can help with tasks like auditing or compliance.
