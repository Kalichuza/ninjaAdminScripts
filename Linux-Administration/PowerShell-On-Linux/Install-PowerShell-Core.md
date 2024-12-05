To install PowerShell Core on an Ubuntu server, follow these steps:

### 1. **Update the Package Lists**

First, ensure your package lists are up to date:

```bash
sudo apt-get update
```

### 2. **Install the Prerequisites**

You need to install the `ca-certificates` and `apt-transport-https` packages:

```bash
sudo apt-get install -y ca-certificates apt-transport-https software-properties-common
```

### 3. **Import the Microsoft GPG Key**

Next, you need to import the Microsoft GPG key:

```bash
wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
```

### 4. **Install the PowerShell Package**

Now that you have added the Microsoft repository, install PowerShell:

```bash
sudo apt-get update
sudo apt-get install -y powershell
```

### 5. **Start PowerShell**

Once installed, you can start PowerShell by typing:

```bash
pwsh
```

### 6. **Verify Installation**

To verify that PowerShell Core is installed and running, you can check the version by running:

```bash
pwsh --version
```

This will display the installed version of PowerShell Core, confirming that the installation was successful.

### Notes:
- The steps above assume you are using Ubuntu 22.04. If you are using a different version of Ubuntu, make sure to replace `22.04` with your specific version in the URL when downloading the Microsoft repository package.
- PowerShell Core is typically referred to simply as "PowerShell" starting from version 7.0, but it's different from the Windows PowerShell that comes installed on Windows by default.
