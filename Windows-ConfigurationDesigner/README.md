# Windows Configuration Designer - Adding Custom MSI to a Provisioning Package

This guide walks you through the process of using the Windows Configuration Designer (WCD) in advanced mode to add a custom MSI file to a provisioning package and export it as a `.ppkg` file. 

## Prerequisites

Before you begin, ensure you have the following:

- **Windows Configuration Designer** installed. You can download it from the [Microsoft Store](https://www.microsoft.com/store/productId/9NBLGGH4TX22).
- The **MSI file** you want to include in the provisioning package.
- A **Windows 10/11** machine to create the provisioning package.

## Step 1: Launch Windows Configuration Designer

1. Open the **Windows Configuration Designer** application.
2. In the "Start a new project" screen, select **Advanced provisioning**.

## Step 2: Create a New Project

1. Enter a project name and a project folder location. Choose a location that you can easily access later.
2. Click **Next** to proceed.

## Step 3: Configure Device Settings

1. On the "Choose what to configure" screen, you can select the settings you want to configure. For this guide, we'll focus on adding an MSI file.
2. Click **Finish** after selecting the desired settings.

## Step 4: Add Custom MSI to the Provisioning Package

1. In the left-hand pane, expand the **Runtime settings** section.
2. Expand **ProvisioningCommands** and click on **Primary Context** (or **FirstLogonCommands** depending on when you want the MSI to be installed.)
3. Click on **Add** to add a new provisioning command.
4. The top pane will ask you to select your installer file in the file explorer.
5. Set the **CommandLine** to the MSI installation command for your installer. For example we will use our ninjaOne installer:
    ```plaintext
    msiexec.exe /i "NINJA-INSTALLER.msi" 
    ```
6. You will set the 'ContinueInstall' setting to True and the 'RestartRequired' False
7. Repeat this process for each of the MSI files that you want to install. 

   - Ensure that the install command for each MSI file is correct. Usually, some diligent Googling will provide the correct command for silent install. 


## Step 5: Build and Save the Provisioning Package

1. Choose a location to save the `.ppkg` file.
2. Click **Build** to create the provisioning package.
3. Once the build is complete, you’ll find the `.ppkg` file in the location you specified.


For more detailed information, refer to the official [Microsoft Documentation](https://docs.microsoft.com/en-us/windows/configuration/provisioning-packages/provisioning-packages-overview).
