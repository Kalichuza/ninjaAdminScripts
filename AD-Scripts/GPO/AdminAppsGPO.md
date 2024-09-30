Apologies for the confusion earlier. Here’s how to configure a **Group Policy** to allow certain applications to run with admin rights **without giving the user admin rights** using **AppLocker**.

### Steps to Set Up a GPO to Allow Applications to Run with Elevated Rights:

#### **1. Open Group Policy Management**
1. Press `Windows Key + R`, type `gpmc.msc`, and hit **Enter** to open the **Group Policy Management Console**.
2. In the console, navigate to **Domains > Your Domain > Group Policy Objects**.

#### **2. Create a New GPO**
1. Right-click on **Group Policy Objects** and select **New**.
2. Name the new GPO something like **"AppLocker Admin Apps"** and click **OK**.

#### **3. Edit the GPO**
1. Right-click the newly created GPO and select **Edit**.
2. In the Group Policy Management Editor, navigate to:
   - **Computer Configuration > Policies > Windows Settings > Security Settings > Application Control Policies > AppLocker**.

#### **4. Configure AppLocker**
1. Under **AppLocker**, you will see four rule categories:
   - **Executable Rules**
   - **Windows Installer Rules**
   - **Script Rules**
   - **Packaged App Rules**

2. **Enable the Executable Rules**:
   - Click **Executable Rules**.
   - In the right pane, right-click and select **Create Default Rules**. This will allow all applications signed by Microsoft to run (you can modify these later if needed).

3. **Create a New Rule for Your Specific App**:
   - Right-click on **Executable Rules** and choose **Create New Rule**.
   - Click **Next** through the introduction.
   - Choose **Allow** in the **Permissions** section and select **Everyone** as the user group (or specify a custom group if needed).

4. **Specify the Application**:
   - Choose **Publisher** or **Path** depending on how you want to identify the application.
     - **Publisher**: If the app is signed, you can choose this option to specify it by its digital signature.
     - **Path**: If the app isn't signed, you can use a file path (e.g., `C:\Program Files\YourApp\app.exe`) to identify it.
   - Click **Next**.

5. **Exceptions (Optional)**:
   - If you want to allow specific apps but deny others, you can add exceptions here.

6. **Review and Create**:
   - Click **Next** and then **Create** to finish creating the rule.

#### **5. Apply the GPO to the Right OU**
1. Go back to the **Group Policy Management Console**.
2. Right-click on the **OU** (Organizational Unit) where the users or computers are located that need to run this app, and select **Link an Existing GPO**.
3. Select the **AppLocker Admin Apps** GPO you just created and click **OK**.

#### **6. Enforce the GPO**
1. Right-click the linked GPO, and select **Enforce**.

#### **7. Update Group Policy on Clients**
1. You can wait for the next automatic GPO refresh, or force it to update immediately on the client machine by running the following command in **Command Prompt**:
   ```cmd
   gpupdate /force
   ```

#### **8. Verify AppLocker is Working**
1. On a target machine, check if the specified application runs without prompting for admin credentials.
2. If the app doesn’t run, use the Event Viewer to check the AppLocker logs:
   - Open **Event Viewer**.
   - Navigate to **Applications and Services Logs > Microsoft > Windows > AppLocker**.

---

### Important Notes:
- **AppLocker** requires the **Windows 10 Enterprise or Education** editions, or **Windows Server**.
- **AppLocker Policies** can be quite powerful and allow fine-grained control over which apps can run. Make sure to test your policy in a lab environment before applying it to production.
  
This setup ensures that only the specified application can run with elevated privileges while not granting full admin rights to the user.

Let me know if you need more assistance!
