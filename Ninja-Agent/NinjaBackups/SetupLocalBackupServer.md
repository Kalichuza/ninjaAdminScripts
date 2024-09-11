To set up an SMB network share on Ubuntu 22.04 for NinjaRMM backups in a Windows Active Directory (AD) environment, follow these steps:

### Step 1: Install Samba
Samba is the service that allows Ubuntu to act as an SMB server.
```bash
sudo apt update
sudo apt install samba -y
```

### Step 2: Configure Samba
1. Create a directory that will be shared via SMB. For example:
   ```bash
   sudo mkdir -p /srv/samba/ninja-backups
   sudo chmod 2770 /srv/samba/ninja-backups
   ```

2. Set ownership of the shared directory. Assuming you will create an AD user later:
   ```bash
   sudo chown root:users /srv/samba/ninja-backups
   ```

3. Open the Samba configuration file for editing:
   ```bash
   sudo nano /etc/samba/smb.conf
   ```

4. Add the following at the end of the file to define your share:
   ```ini
   [NinjaBackups]
   path = /srv/samba/ninja-backups
   browseable = yes
   writable = yes
   create mask = 0770
   directory mask = 0770
   valid users = @users
   ```

### Step 3: Join the Server to Active Directory
1. Install necessary packages for AD integration:
   ```bash
   sudo apt install realmd sssd adcli krb5-user samba-common-bin -y
   ```

2. Discover your AD domain:
   ```bash
   sudo realm discover yourdomain.local
   ```

3. Join the domain:
   ```bash
   sudo realm join --user=administrator yourdomain.local
   ```

4. Check if the server is joined:
   ```bash
   realm list
   ```

5. Enable AD users to access the SMB share. Edit `/etc/samba/smb.conf` again and add:
   ```ini
   security = ads
   realm = YOURDOMAIN.LOCAL
   workgroup = YOURDOMAIN
   ```
   Make sure to configure the correct workgroup and realm.

### Step 4: Restart Samba and Enable Services
```bash
sudo systemctl restart smbd nmbd
sudo systemctl enable smbd nmbd
```

### Step 5: Set Permissions for AD Users
You can assign permissions to the AD users or groups on the shared directory:
```bash
sudo chown :YOURDOMAIN\domain_users /srv/samba/ninja-backups
sudo chmod 2770 /srv/samba/ninja-backups
```

### Step 6: Allow Samba Through the Firewall
If the firewall is enabled, allow SMB traffic:
```bash
sudo ufw allow samba
sudo ufw reload
```

### Step 7: Testing the SMB Share
From a Windows machine:
1. Open File Explorer and enter the Ubuntu server’s IP address:
   ```
   \\<Ubuntu_Server_IP>\NinjaBackups
   ```

2. Use your AD credentials to authenticate.

After these steps, your Ubuntu 22.04 server will be ready to accept backups via SMB in the NinjaRMM environment.

Let me know if you need any adjustments or specific configurations!
