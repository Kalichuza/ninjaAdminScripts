Here’s how to set up the SMB network share on your Ubuntu 22.04 server without domain integration, using a single user profile for NinjaRMM backups.

### Step 1: Install Samba
First, install Samba to allow the Ubuntu server to act as an SMB server:
```bash
sudo apt update
sudo apt install samba -y
```

### Step 2: Create a User for the Service
1. Create a dedicated user account for managing the backups. For example, we will use `ninjabackupuser`:
   ```bash
   sudo adduser ninjabackupuser
   ```

2. Set a password for the user (this will be used to access the SMB share):
   ```bash
   sudo smbpasswd -a ninjabackupuser
   ```

### Step 3: Create the Backup Directory
1. Create the directory that will be shared:
   ```bash
   sudo mkdir -p /srv/samba/ninja-backups
   sudo chown ninjabackupuser:ninjabackupuser /srv/samba/ninja-backups
   sudo chmod 2770 /srv/samba/ninja-backups
   ```

### Step 4: Configure Samba
1. Open the Samba configuration file for editing:
   ```bash
   sudo nano /etc/samba/smb.conf
   ```

2. Add the following at the end of the file to define the backup share:
   ```ini
   [NinjaBackups]
   path = /srv/samba/ninja-backups
   browseable = yes
   writable = yes
   create mask = 0770
   directory mask = 0770
   valid users = ninjabackupuser
   ```

3. Save the file and exit the editor.

### Step 5: Restart Samba Services
Restart the Samba services to apply the changes:
```bash
sudo systemctl restart smbd nmbd
```

### Step 6: Set Firewall Rules (Optional)
If your firewall is enabled, allow SMB traffic:
```bash
sudo ufw allow samba
sudo ufw reload
```

### Step 7: Access the SMB Share from Windows
On a Windows machine:
1. Open File Explorer and enter the Ubuntu server’s IP address:
   ```
   \\<Ubuntu_Server_IP>\NinjaBackups
   ```

2. When prompted, enter the credentials of the `ninjabackupuser` created earlier.

After these steps, your Ubuntu server will be ready to accept backups from NinjaRMM via SMB.

Let me know if you need any adjustments!
