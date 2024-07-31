### Step-by-Step Guide for Windows Configuration Designer

#### 1. **Install Windows Configuration Designer**
1. Download and install the Windows Configuration Designer from the Microsoft Store or as part of the Windows ADK (Assessment and Deployment Kit).

#### 2. **Create a New Provisioning Package**
1. Open Windows Configuration Designer.
2. Click on `Provision desktop devices` to create a new provisioning package.
3. Name your project and choose a location to save it.

#### 3. **Configure Device Settings**
1. In the left pane, go to `Runtime settings`.
2. Expand `Common to all Windows editions` and then `Accounts`.
   - Configure the Administrator account by setting the `Password` and `AutoLogin` settings.
3. Expand `DeviceName`.
   - Set `DeviceName` to `car206-%RAND:0000-9999%` to generate a random computer name.

#### 4. **Add Applications**
1. In the left pane, go to `Applications`.
2. Click `Add` and specify the path to the application installer(s) you want to pre-load. You can also add multiple applications here.

#### 5. **Configure Additional Settings**
1. Expand `OOBE` (Out-Of-Box Experience).
   - Configure the OOBE settings as needed, such as skipping certain setup screens or specifying default user settings.
2. Expand `Time zone`.
   - Set the `Time zone` to `Eastern Standard Time`.

#### 6. **Build the Provisioning Package**
1. Click on `Export` in the toolbar and select `Provisioning package`.
2. Choose the `Build` button.
3. Once the package is built, save it to a location of your choice.

#### 7. **Apply the Provisioning Package**
1. You can apply the provisioning package during the Windows installation process or to an existing Windows installation.
   - To apply it during installation, copy the provisioning package to a USB drive and insert it into the PC during the Windows setup.
   - To apply it to an existing installation, open `Settings` > `Accounts` > `Access work or school` > `Add or remove a provisioning package`, and then add the package from your USB drive or other storage media.

### Example of `DeviceName` Configuration

For generating a unique computer name with a specific prefix and a random number, use the following format:

```plaintext
NAME-PC%RAND:0000-9999%
```

This configuration ensures that each device will be named starting with `car206-` followed by a random number between `0000` and `9999`.

### Summary
By following these steps, you can easily create a provisioning package that configures each PC with a unique name like `car206-XXXX` (where `XXXX` is a random number), along with preloaded software and specific configurations. This method allows you to quickly deploy the same configuration across multiple devices with minimal effort.

If you have more specific requirements or need further customization, please let me know!
