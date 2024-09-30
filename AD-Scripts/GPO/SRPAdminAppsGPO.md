If most of the PCs in your environment are running **Windows 10 Pro** or **Windows 11 Pro**, then **AppLocker** will **not** be available to you. AppLocker is only available in **Windows 10/11 Enterprise** or **Education** editions, as well as **Windows Server**.

However, for **Windows 10/11 Pro** environments, you can achieve similar functionality using **Software Restriction Policies (SRP)**, though SRP is less granular and powerful compared to AppLocker.

Here’s how you can use **Software Restriction Policies** to allow certain applications to run with admin rights on **Windows Pro** machines:

---

### Steps to Set Up Software Restriction Policies (SRP)

#### **1. Open Group Policy Management**
1. On your **Domain Controller**, open **Group Policy Management Console** (`gpmc.msc`).
2. Navigate to your domain: **Domains > YourDomain > Group Policy Objects**.

#### **2. Create a New GPO**
1. Right-click on **Group Policy Objects** and select **New**.
2. Name the new GPO, e.g., **"SRP Admin Apps"**.
3. Click **OK**.

#### **3. Edit the GPO**
1. Right-click on the new GPO and select **Edit**.
2. Navigate to **Computer Configuration > Policies > Windows Settings > Security Settings > Software Restriction Policies**.
   - If no Software Restriction Policies are defined, right-click **Software Restriction Policies** and select **New Software Restriction Policies**.

#### **4. Create a Path Rule for the Application**
1. In the **Software Restriction Policies** section, right-click on **Additional Rules** and choose **New Path Rule**.
2. In the **Path** field, enter the full path to the executable that you want to allow with admin rights (e.g., `C:\Program Files\YourApp\app.exe`).
3. In the **Security Level** dropdown, select **Unrestricted** to allow the application to run without restrictions.
4. Click **OK** to save the rule.

#### **5. Apply the GPO**
1. In the **Group Policy Management Console**, right-click on the **OU** where the users or computers are located that need to run the app, and select **Link an Existing GPO**.
2. Select the **SRP Admin Apps** GPO you created earlier, and click **OK**.

#### **6. Update Group Policy on Client Machines**
1. Run the following command on the client machine to immediately apply the GPO:
   ```cmd
   gpupdate /force
   ```

---

### Alternative Method: Using Task Scheduler

If you need to allow users to run specific apps with elevated privileges without prompting for admin credentials, another option for **Windows Pro** environments is to use **Task Scheduler** to create a task that runs the application as an administrator:

1. Open **Task Scheduler** and create a new task.
2. Set the task to run the desired application (e.g., `app.exe`) under **admin credentials**.
3. Configure the task to be triggered by the user, but ensure it runs with **elevated privileges**.
4. The user can then trigger the task without needing admin rights.

