
# PowerShell Remote Script Utilities

This repository contains two PowerShell scripts: `Get-RemoteScript.ps1` and `Run-Remote-Script.ps1`. These scripts facilitate downloading and executing remote scripts in a flexible and convenient manner.

## Get-RemoteScript.ps1

`Get-RemoteScript.ps1` downloads a PowerShell script from a specified URL and saves it to a specified file path on the local system.

### Parameters

- `-ScriptUrl` (mandatory): The URL of the script to download.
- `-FileName` (mandatory): The name (including path) of the file to save the downloaded script to.

### Usage

```powershell
.\Get-RemoteScript.ps1 -ScriptUrl "https://example.com/script.ps1" -FileName "script.ps1"
```

This command will download the script from `https://example.com/script.ps1` and save it as `C:\script.ps1`.

## Run-Remote-Script.ps1

`Run-Remote-Script.ps1` downloads a PowerShell script from a specified URL and executes it directly without saving it to the local file system.

### Parameters

- `-ScriptUrl` (mandatory): The URL of the script to download and execute.

### Usage

```powershell
.\Run-Remote-Script.ps1 -ScriptUrl "https://example.com/script.ps1"
```

This command will download the script from `https://example.com/script.ps1` and execute it immediately.

### Example

Here's an example of how to use these scripts:

1. **Download a Script:**

    ```powershell
    .\Get-RemoteScript.ps1 -ScriptUrl "https://raw.githubusercontent.com/yourusername/yourrepository/main/test.ps1" -FileName "test.ps1"
    ```

    This command downloads the `test.ps1` script from the specified GitHub repository and saves it as `C:\test.ps1`.

2. **Run a Script Directly:**

    ```powershell
    .\Run-Remote-Script.ps1 -ScriptUrl "https://raw.githubusercontent.com/yourusername/yourrepository/main/test.ps1"
    ```

    This command downloads and executes the `test.ps1` script from the specified GitHub repository without saving it to the local file system.


# Download and Install MSI Script

This script downloads an MSI file from a specified URL, installs it, and then deletes the downloaded file. It uses `curl` for downloading and `msiexec` for installation.

## Prerequisites

- PowerShell
- `curl` must be installed and accessible in your system's PATH.
- The URL must point to a valid MSI file.

## Usage

To use the script, provide the URL of the MSI file and the filename to save the downloaded MSI file as using the `-url` and `-filename` parameters.

```powershell
.\DownloadAndInstallMSI.ps1 -url "http://example.com/file.msi" -filename "setup"


These scripts are useful for automating the process of fetching and running remote PowerShell scripts, making it easier to manage and deploy scripts across multiple systems.
