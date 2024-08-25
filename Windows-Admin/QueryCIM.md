Yes, you can query WMI (Windows Management Instrumentation) in PowerShell using built-in cmdlets. There are two primary cmdlets for querying WMI:

1. **`Get-WmiObject`**: This cmdlet is available in PowerShell versions 5.1 and earlier.
2. **`Get-CimInstance`**: This cmdlet is available in PowerShell 3.0 and later and is the preferred method because it uses the CIM (Common Information Model) cmdlets, which are more robust and use newer protocols.

### Example: Using `Get-CimInstance`

Here’s an example of how to query WMI for information about the operating system using `Get-CimInstance`:

```powershell
Get-CimInstance -ClassName Win32_OperatingSystem
```

### Example: Using `Get-WmiObject`

If you're using PowerShell 5.1 or earlier, you can use `Get-WmiObject`:

```powershell
Get-WmiObject -Class Win32_OperatingSystem
```

### Installing the `CimCmdlets` Module

In case you are working in an environment where the `Get-CimInstance` cmdlet is not available, you can install the `CimCmdlets` module. However, this module is built into Windows PowerShell 3.0 and later, so it should be available by default in most cases.

```powershell
Install-Module -Name CimCmdlets
```

### Querying Other WMI Classes

You can query different WMI classes depending on the information you need. For example:

- **CPU Information**:
  ```powershell
  Get-CimInstance -ClassName Win32_Processor
  ```

- **BIOS Information**:
  ```powershell
  Get-CimInstance -ClassName Win32_BIOS
  ```

- **Network Adapter Information**:
  ```powershell
  Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration
  ```

### Filtering Results

You can filter results directly in the query:

```powershell
Get-CimInstance -ClassName Win32_Service -Filter "StartMode='Auto' AND State='Running'"
```

This command retrieves only services that are set to start automatically and are currently running.

Using `Get-CimInstance` is generally recommended over `Get-WmiObject` for modern PowerShell scripts because it offers better performance and security by using the DCOM and WSMan protocols.