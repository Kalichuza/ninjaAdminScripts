To set up a cron job to perform daily updates at 9 PM on an Ubuntu server, follow these steps:

### Step 1: Open the crontab editor
Run the following command to edit the crontab for the root user (so that the updates will run with the necessary permissions):

```bash
sudo crontab -e
```

### Step 2: Add the cron job for daily updates
In the crontab file, add the following line to schedule daily updates at 9 PM:

```bash
0 21 * * * apt-get update && apt-get upgrade -y
```

Here’s what each part of the cron expression means:
- `0` – Run the command at the 0th minute (i.e., at the start of the hour).
- `21` – Run the command at 9 PM (21:00 in 24-hour format).
- `* * *` – Every day of the month, every month, every day of the week.
- `apt-get update && apt-get upgrade -y` – This will run `apt-get update` to update package lists and `apt-get upgrade -y` to upgrade all installed packages automatically.

### Step 3: Save and exit
Once you’ve added the line to the crontab, save the file and exit the editor.

### Step 4: Verify the cron job
To verify that the cron job has been successfully added, you can list all cron jobs for the root user with:

```bash
sudo crontab -l
```

This will display the cron job you just added.

Your system is now configured to perform updates daily at 9 PM.
