
### **Step 1: Install Samba**
First, ensure Samba is installed on your Ubuntu server:

```bash
sudo apt update
sudo apt install samba -y
```

---

### **Step 2: Create a Directory for the Share**
Create the directory you want to share:

```bash
sudo mkdir -p /srv/samba/shared
```

---

### **Step 3: Set Directory Ownership and Permissions**
Set permissions so only the dedicated user (`smbuser`) can access this directory:

```bash
sudo chown smbuser:smbuser /srv/samba/shared
sudo chmod 2770 /srv/samba/shared
```

This ensures that `smbuser` and members of the same group can access the share.

---

### **Step 4: Add a Samba User**
Create a dedicated user if it doesn’t already exist:

```bash
sudo adduser smbuser
```

Then, set up this user for Samba:

```bash
sudo smbpasswd -a smbuser
sudo smbpasswd -e smbuser
```

---

### **Step 5: Configure Samba**
Edit the Samba configuration file to define the share:

```bash
sudo nano /etc/samba/smb.conf
```

Add the following configuration at the bottom of the file:

```ini
[shared]
   path = /srv/samba/shared/
   read only = No
   create mask = 0770
   directory mask = 0770
   browsable = yes
   writable = yes
   guest ok = no
   valid users = smbuser
   force group = smbuser

```

Save and exit the editor (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

### **Step 6: Restart the Samba Service**
Restart the Samba service to apply your changes:

```bash
sudo systemctl restart smbd
sudo systemctl enable smbd
```

---

### **Step 7: Allow Samba Through the Firewall**
If you are using a firewall, allow Samba traffic:

```bash
sudo ufw allow 'Samba'
```

---

### **Step 8: Verify the Samba Configuration**
Ensure the Samba configuration is valid:

```bash
testparm
```

This command checks the syntax and validity of your `smb.conf` file. If there are no errors, the configuration is good to go.

---

### **Step 9: Test the Share**
From the Ubuntu server, test the share locally:

```bash
smbclient -L localhost -U smbuser
```

Provide the password for `smbuser` when prompted. You should see the `[shared]` share listed.

---

### **Step 10: Map the Share on a Windows PC**
1. Open **File Explorer** on the Windows PC.
2. Right-click **This PC** and select **Map network drive**.
3. Choose a drive letter (e.g., `Z:`) and enter the network path, such as:
   ```
   \\<Ubuntu_Server_IP>\shared
   ```
4. Check **Connect using different credentials**.
5. Enter the Samba username (`smbuser`) and the password you set earlier.

Click **Finish**, and the shared folder should be mapped to your Windows PC.

---

### Notes:
- Replace `<Ubuntu_Server_IP>` with the actual IP address of your Ubuntu server.
- If your network has strict permissions or requires DNS, ensure the server hostname or IP is correctly resolved on the Windows PC.

This should fully set up and configure your SMB share! Let me know if you need further assistance.
