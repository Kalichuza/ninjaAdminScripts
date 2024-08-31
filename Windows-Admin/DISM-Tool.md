# Deployment Image Servicing and Management (DISM) Tool

The Deployment Image Servicing and Management (DISM) tool is a command-line tool included with Windows. It is used to service and prepare Windows images, such as those used for Windows PE, Windows Recovery Environment (Windows RE), and Windows Setup. DISM can also service a running operating system. Below are some of the most commonly used DISM commands and their purposes:

## Basic DISM Commands

### Check DISM Version
```bash
DISM /Online /Get-Version
```

### List all Available DISM Commands and Parameters
```bash
DISM /?
```

## Image Management

### Mount a Windows Image (.wim)
```bash
DISM /Mount-Wim /WimFile:<path_to_wim> /Index:<index_number> /MountDir:<mount_directory>
```

### Unmount a Windows Image and Commit Changes
```bash
DISM /Unmount-Wim /MountDir:<mount_directory> /Commit
```

### Unmount a Windows Image and Discard Changes
```bash
DISM /Unmount-Wim /MountDir:<mount_directory> /Discard
```

### List Information about an Image
```bash
DISM /Get-WimInfo /WimFile:<path_to_wim>
```

### Capture an Image
```bash
DISM /Capture-Image /ImageFile:<path_to_image> /CaptureDir:<directory_to_capture> /Name:"<name>"
```

### Apply an Image
```bash
DISM /Apply-Image /ImageFile:<path_to_image> /Index:<index_number> /ApplyDir:<target_directory>
```

## Online Servicing Commands (Running OS)

### Check System Health
```bash
DISM /Online /Cleanup-Image /CheckHealth
```

### Scan for System Corruption
```bash
DISM /Online /Cleanup-Image /ScanHealth
```

### Repair System Corruption
```bash
DISM /Online /Cleanup-Image /RestoreHealth
```

### Add or Remove Features or Packages

#### Add a Feature
```bash
DISM /Online /Enable-Feature /FeatureName:<feature_name>
```

#### Remove a Feature
```bash
DISM /Online /Disable-Feature /FeatureName:<feature_name>
```

#### Add a Package
```bash
DISM /Online /Add-Package /PackagePath:<path_to_package>
```

#### Remove a Package
```bash
DISM /Online /Remove-Package /PackagePath:<path_to_package>
```

## Cleaning up the Component Store

### Analyze the Component Store (WinSxS Folder)
```bash
DISM /Online /Cleanup-Image /AnalyzeComponentStore
```

### Reduce the Size of the Component Store
```bash
DISM /Online /Cleanup-Image /StartComponentCleanup
```

### Remove Superseded and Unused System Files
```bash
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
```

This is not an exhaustive list of all DISM commands but covers many of the common tasks you might need to perform with DISM. For detailed usage and options for each command, you can run `DISM /?` or `DISM /<command> /?` in the Command Prompt to get more information.
