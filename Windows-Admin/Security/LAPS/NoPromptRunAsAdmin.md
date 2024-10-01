### SUse Task Scheduler to Bypass Credential Prompts

By setting up a **scheduled task** that runs with administrative privileges and creating a **desktop shortcut** to run that task, the user can run the application with elevated privileges **without entering credentials**.

Here's how to do it:

### Step-by-Step Guide

#### 1. Create a Scheduled Task on the User’s Machine

1. **Open Task Scheduler**:
   - Press `Windows + R`, type `taskschd.msc`, and press Enter to open Task Scheduler.

2. **Create a New Task**:
   - Click on **Create Task** from the right-hand panel.
   
3. **Configure the General Tab**:
   - **Name**: Give it a name like “Run MyApp as Admin.”
   - **Security Options**: Select **Run whether user is logged on or not**.
   - Check the option **Run with highest privileges**.

4. **Configure the Triggers Tab**:
   - You don't need to set any specific triggers because this task will be manually started via a shortcut.

5. **Configure the Actions Tab**:
   - Click **New**, and in the **Program/script** box, enter the full path to the application you want to run with administrative privileges.
   - Example: `C:\Program Files\AppName\App.exe`

6. **Save the Task**:
   - When prompted, enter the local administrator credentials (LAPS credentials if necessary).

#### 2. Create a Desktop Shortcut to Run the Task

1. **Right-click on the Desktop**:
   - Select **New** → **Shortcut**.

2. **Create the Shortcut**:
   - In the **location field**, enter the following command:
     ```bash
     schtasks /run /tn "Run MyApp as Admin"
     ```
     Replace `"Run MyApp as Admin"` with the name of the task you created in Task Scheduler.

3. **Name the Shortcut**:
   - Give the shortcut a descriptive name, like “Launch MyApp with Admin Rights.”

4. **Test the Shortcut**:
   - Double-click the shortcut. The application should launch with administrative privileges **without prompting for credentials**, as the task runs using the credentials already provided in Task Scheduler.

### Summary

- **Non-admin users** can now run the application without needing to enter credentials every time.
- The **administrative credentials** are securely stored in the scheduled task, and the shortcut triggers the task to run the application with elevated rights.

This method ensures that users do not need to repeatedly enter LAPS or admin credentials while maintaining security since the scheduled task is limited to that specific application.

Would you like further assistance with setting this up or automating it across multiple devices?
