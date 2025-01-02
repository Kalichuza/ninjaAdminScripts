Below is a **getting started** guide and **comprehensive overview** of how to use the Meraki PowerShell module (as shown in your `Get-Command -Module meraki` output). It covers basic setup steps, authentication, and usage patterns so that you can quickly become productive with the Meraki module in PowerShell.

---

## 1. Overview

The Meraki PowerShell module is a set of PowerShell functions (cmdlets) that wrap the Cisco Meraki Dashboard API. It allows you to automate common tasks in the Meraki Dashboard, such as:

- Managing organizations, networks, and devices
- Retrieving analytics and performance data
- Configuring wireless, switching, and security appliances
- Handling bulk operations (firmware upgrades, claim devices, move licenses, etc.)

If you have used the Meraki Dashboard Web GUI, you will notice these cmdlets align closely to Meraki’s REST endpoints—almost every function corresponds to one or two endpoints in the Meraki API.

---

## 2. Installation and Prerequisites

1. **Install the module** (if not already installed).
    
    ```powershell
    Install-Module -Name meraki
    ```
    
2. **Check your module version** (to confirm which version is installed):
    
    ```powershell
    Get-Module meraki -ListAvailable
    ```
    
3. **Meraki API Key**:  
    You need a Meraki Dashboard API key with sufficient privileges to manage the organizations, networks, or devices you plan to automate. You can generate or retrieve the API key in the Meraki Dashboard under **Organization > Settings > Dashboard API access**.
    
4. **Storing your API Key**:  
    Typically, you can either:
    
    - Store the key in a variable in your session:
        
        ```powershell
        $MerakiApiKey = '1234abcd...'
        ```
        
    - Store the key in a PowerShell environment variable, or a credential manager or vault of your choice, so that it’s not exposed in plain text. (Implementation depends on your local security policies.)

> **Tip**: Some users create a custom function (e.g., `Set-MerakiEnvironment`) in their profile to automatically set `$env:MERAKI_API_KEY` or a variable each time a new PowerShell session starts.

---

## 3. Connecting to Meraki

Most of the module’s commands support passing the `-ApiKey` parameter or rely on a default variable if you have set `$env:MERAKI_API_KEY`. For example:

```powershell
# Option 1: Pass the ApiKey parameter directly
Get-MerakiOrganizations -ApiKey $MerakiApiKey

# Option 2: Have the key stored in an environment variable MERAKI_API_KEY
Get-MerakiOrganizations
```

If your environment variable is named `MERAKI_DASHBOARD_API_KEY` instead, you can reference it with `$env:MERAKI_DASHBOARD_API_KEY` or rename your variable so that the module finds it automatically (depending on how your environment is configured).

---

## 4. Basic Usage Patterns

### 4.1. Reading / Listing Information

All **Get-** commands retrieve data from the Meraki Dashboard. The most common pattern is:

```powershell
Get-MerakiOrganization                      # Lists all organizations you have access to
Get-MerakiNetwork -OrganizationId <OrgId>   # Lists all networks in a given organization
Get-MerakiDevice -Serial <DeviceSerial>     # Retrieves info about a single device
```

You’ll see many `Get-Meraki*` commands in your list. They typically require an `-OrganizationId`, `-NetworkId`, or `-Serial` parameter, depending on the resource type. Most also support filtering or additional parameters.

### 4.2. Creating / Provisioning Resources

**New-** commands allow you to create objects in Meraki. A few examples:

```powershell
# Create a new organization
New-MerakiOrganization -Name 'My New Org'

# Create a new network within an organization
New-MerakiOrganizationNetwork -OrganizationId <OrgId> -Name "My Branch" -Type "wireless appliance switch"

# Add a new VLAN on a given appliance network
New-MerakiNetworkApplianceVLAN -NetworkId <NetId> -Id 20 -Name "VLAN20" -Subnet "192.168.20.0/24" -ApplianceIp "192.168.20.1"
```

### 4.3. Updating / Changing Configuration

**Set-** commands modify the configuration of existing resources, e.g., changing VLAN settings, SSIDs, switch port configurations, and so on:

```powershell
# Update device attributes
Set-MerakiDevice -Serial <DeviceSerial> -Name "MyRenamedMX"

# Modify an organization’s settings
Set-MerakiOrganization -OrganizationId <OrgId> -Name "Renamed Org"

# Configure a switch port
Set-MerakiDeviceSwitchPort -Serial <SwitchSerial> -PortId <PortNumber> -Name "Uplink Port" -Vlan 10
```

### 4.4. Removing / Deleting Resources

**Remove-** commands will delete or remove Meraki objects:

```powershell
# Remove a network
Remove-MerakiNetwork -NetworkId <NetId>

# Remove an appliance VLAN
Remove-MerakiNetworkApplianceVLAN -NetworkId <NetId> -VlanId <VlanNumber>
```

Always **double-check** the parameters to avoid deleting critical resources.

### 4.5. Invoking Actions / Commands

**Invoke-** commands typically handle operational tasks that aren’t just create/update/delete. Examples include rebooting devices, blinking LEDs, or performing live cable tests:

```powershell
Invoke-MerakiDeviceBlinkLEDs -Serial <DeviceSerial>
Invoke-MerakiDeviceReboot -Serial <DeviceSerial>
New-MerakiDeviceLiveToolsCableTest -Serial <SwitchSerial> -PortId <PortNumber>
```

---

## 5. Examples of Common Workflows

Below are some real-world examples that tie multiple cmdlets together in a workflow.

### 5.1. List All Your Organizations and Their Networks

```powershell
# 1) List all organizations available to your API Key
$orgs = Get-MerakiOrganization

# 2) For each organization, list networks
foreach ($org in $orgs) {
    Write-Host "Organization: $($org.name) (ID: $($org.id))"
    $nets = Get-MerakiNetwork -OrganizationId $org.id
    foreach ($net in $nets) {
        Write-Host "  - Network: $($net.name) (ID: $($net.id))"
    }
}
```

### 5.2. Claim and Add Devices into a Network

```powershell
# Example: Claim new devices into an Org and then add them to a Network

$orgId   = <YourOrgId>
$netId   = <YourNetId>
$serials = @("Q2XX-ABCD-WXYZ", "Q2YY-1234-5678")

# 1) Claim these devices into the org
Invoke-MerakiOrganizationInventoryClaim -OrganizationId $orgId -Serials $serials

# 2) Move them into a specific network
Invoke-MerakiNetworkClaimDevices -NetworkId $netId -Serials $serials
```

### 5.3. Quickly Retrieve a Device’s Status and Perform Actions

```powershell
$serial = <YourDeviceSerial>

# 1) Get device info
$device = Get-MerakiDevice -Serial $serial
Write-Host "Device Name: $($device.name)"
Write-Host "Model: $($device.model)"
Write-Host "Network Id: $($device.networkId)"

# 2) Perform a cable test on port 1
New-MerakiDeviceLiveToolsCableTest -Serial $serial -PortId 1
# 3) Blink the LEDs to identify the device in the rack
Invoke-MerakiDeviceBlinkLEDs -Serial $serial
```

---

## 6. Working with Return Objects and JSON

Most **Get-*** cmdlets return PowerShell objects that you can pipeline into other cmdlets or convert to JSON if you want:

```powershell
Get-MerakiOrganization | ConvertTo-Json | Out-File -FilePath .\orgs.json
```

Because they’re standard PowerShell objects, you can also filter, sort, group, or otherwise manipulate the data natively:

```powershell
# Show organizations sorted by name
Get-MerakiOrganization | Sort-Object name | Format-Table

# Retrieve only the first 5 networks
Get-MerakiNetwork -OrganizationId <OrgId> | Select-Object -First 5
```

---

## 7. Tips and Best Practices

1. **Use descriptive variables** for IDs, networks, and serials. This prevents confusion about what is an organization ID vs. a network ID vs. a device serial, etc.
2. **Store your API key securely** and avoid hardcoding it in scripts that might be version-controlled or shared.
3. **Experiment in a test org / test network** to avoid unintended changes in production.
4. **Leverage ‘-WhatIf’**  
    Some cmdlets may support `-WhatIf` or `-Confirm:$false/$true` to help you see what will happen before running a command that changes or removes resources.
5. **Batch operations**
    - The Meraki API has rate limits. If you’re making large numbers of calls, consider “action batches” or other recommended best practices in the Meraki developer docs to avoid hitting rate limits.

---

## 8. Finding Help and Further Documentation

- **Inline PowerShell Help**: Each function typically has a built-in help file. You can run:
    
    ```powershell
    Get-Help Get-MerakiOrganization -Full
    Get-Help New-MerakiNetwork -Full
    ```
    
    for detailed parameter usage, examples, and descriptions.
    
- **Meraki Developer Hub**: The [Meraki Dashboard API Documentation](https://developer.cisco.com/meraki) covers the endpoints and the JSON request/response structure. The PowerShell commands generally mirror those endpoints, so the official docs are also a great resource.
    
- **Community & Support**:
    
    - [Cisco Meraki Community](https://community.meraki.com/)
    - [Issues / GitHub pages for the module](https://github.com/) (if the module is open sourced)

---

## 9. Summary

1. **Install the module** and **configure your API key**.
2. Use **Get-** cmdlets to explore organizations, networks, and devices.
3. Create objects with **New-** commands, update them with **Set-** commands, and remove them with **Remove-** commands.
4. Perform operational tasks (e.g., blink LED, reboot device) with **Invoke-** commands.
5. Refer to **Get-Help <cmdlet> -Full** or the Meraki Developer Hub for function-level details.

By following the patterns above, you can script, automate, and manage almost every aspect of the Meraki Dashboard via PowerShell. Use the cmdlets responsibly, and always confirm you’re working on the correct org or network before making changes!