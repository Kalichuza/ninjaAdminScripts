# Creating and Deploying a Custom Windows Image

This guide provides step-by-step instructions to create and deploy a custom Windows image with preinstalled software and settings, and then create an ISO for distribution.

## Prerequisites

1. A reference computer with a clean installation of Windows.
2. Required software and drivers installed on the reference computer.
3. Windows ADK (Assessment and Deployment Kit) and Windows PE add-on.

## Step 1: Prepare the Reference Computer

1. **Install Windows**:
   - Start with a clean installation of Windows on a reference computer.

2. **Install Software and Configure Settings**:
   - Install all the necessary applications and configure the system settings as required.
   - Update Windows and install drivers.

3. **Create Default User Profile**:
   - Configure the user profile with default settings.
   - Copy the configured profile to the default user profile:
     ```powershell
     Copy-Item -Recurse -Force "C:\Users\YourUserProfile" "C:\Users\Default"
     ```

## Step 2: Generalize the System

1. **Open Command Prompt as Administrator**:
   - Run the Sysprep tool to generalize the system:
     ```powershell
     C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown
     ```
   - The system will shut down after the process is complete.

## Step 3: Capture the Image

### 3.1: Download and Install Windows ADK and Windows PE Add-on

1. **Download Windows ADK**:
   - [Download the Windows ADK 10.1.26100.1 (May 2024)](https://go.microsoft.com/fwlink/?linkid=2166081).
   - Run the installer and select the required components (especially "Deployment Tools").

2. **Download Windows PE Add-on**:
   - [Download the Windows PE add-on for the Windows ADK 10.1.26100.1 (May 2024)](https://go.microsoft.com/fwlink/?linkid=2166164).
   - Run the installer to add the Windows PE components to your ADK installation.

### 3.2: Create a Bootable Windows PE ISO

1. **Create Windows PE Media**:
   - Open the "Deployment and Imaging Tools Environment" as an administrator from the Start menu.
   - Create a working directory for Windows PE files:
     ```cmd
     copype.cmd amd64 C:\WinPE_amd64
     ```

2. **Mount the Boot Image**:
   - Mount the boot image to add custom files:
     ```cmd
     dism /Mount-Image /ImageFile:C:\WinPE_amd64\media\sources\boot.wim /index:1 /MountDir:C:\WinPE_amd64\mount
     ```

3. **Add Custom Files (Optional)**:
   - If you need to add any custom scripts or files, copy them to the mounted image directory:
     ```cmd
     xcopy /s C:\Path\To\Your\Files C:\WinPE_amd64\mount\Your\Destination
     ```

4. **Unmount and Commit the Changes**:
   - Unmount the image and commit the changes:
     ```cmd
     dism /Unmount-Image /MountDir:C:\WinPE_amd64\mount /Commit
     ```

5. **Create the ISO File**:
   - Use the `MakeWinPEMedia` command to create an ISO file:
     ```cmd
     MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE.iso
     ```

### 3.3: Boot the Reference Computer with Windows PE ISO

1. **Boot the Reference Computer**:
   - Use virtual machine software (like Hyper-V, VMware, or VirtualBox) to boot the ISO, or burn the ISO to a DVD and boot the reference computer from it.

2. **Capture the Image Using DISM**:
   - Once booted into Windows PE, you will see a command prompt.
   - Use the `DISM` tool to capture the Windows image:
     ```cmd
     dism /capture-image /imagefile:D:\CustomImage.wim /capturedir:C:\ /name:"Custom Windows Image" /description:"Custom Windows Image with Preinstalled Software"
     ```
     - **/imagefile**: The path where the captured image will be saved. Replace `D:\CustomImage.wim` with the desired path (e.g., an external USB drive).
     - **/capturedir**: The drive you want to capture, usually `C:\`.
     - **/name**: A name for the image.
     - **/description**: A description for the image.

3. **Wait for the Process to Complete**:
   - The DISM tool will now capture the image of your reference computer and save it to the specified location. This process may take some time depending on the size of the installation.

## Step 4: Create a Custom Windows ISO with the Custom Image

### 4.1: Download and Mount a Windows ISO

1. **Download Windows ISO**:
   - Download the Windows ISO file from Microsoft's official website.

2. **Mount the ISO**:
   - Mount the Windows ISO file by double-clicking it or using right-click and selecting "Mount".

### 4.2: Copy ISO Contents to a Working Directory

1. **Create a Working Directory**:
   - Create a directory to store the ISO contents, for example `C:\WinISO`.
   - Copy all the contents of the mounted ISO to this directory:
     ```cmd
     xcopy D:\* C:\WinISO /E /H
     ```
   - Replace `D:` with the drive letter of your mounted ISO.

### 4.3: Replace the Install.wim File

1. **Replace Install.wim**:
   - Replace the `install.wim` file in the `C:\WinISO\sources` folder with your custom WIM file:
     ```cmd
     copy /y C:\Path\To\CustomImage.wim C:\WinISO\sources\install.wim
     ```

## Step 5: Create an Unattended Installation File

1. **Create an Unattended Installation File**:
   - Create an `unattend.xml` file with the following content and save it in the `C:\WinISO` directory:

## Step 6
**Create New ISO File**
1. Download and install the Windows ADK (Assessment and Deployment Kit) if not already installed.
2. Open the "Deployment and Imaging Tools Environment" as an administrator from the Start menu.
3. Use the oscdimg tool to create a new ISO file:
   ```cmd
   oscdimg -n -m -bC:\WinISO\boot\etfsboot.com C:\WinISO C:\CustomWindows.iso
   ```
