Here’s a complete, generalized tutorial on how to connect to an SMB share on a domain-joined Ubuntu machine. This tutorial ensures it is agnostic to specific names and provides detailed steps.

---

## **Tutorial: Connecting to an SMB Share on a Domain-Joined Ubuntu Machine**

### **Prerequisites**
1. Ensure the Ubuntu machine is domain-joined and can communicate with the SMB server.
2. Install necessary SMB utilities:
   ```bash
   sudo apt update
   sudo apt install cifs-utils smbclient
   ```

---

### **Step 1: Verify Network Connectivity**
Ensure the Ubuntu machine can reach the SMB server.

1. **Ping the SMB server**:
   ```bash
   ping smb-server.example.com
   ```
2. **Check if SMB port (445) is open**:
   ```bash
   nc -zv smb-server.example.com 445
   ```
   Replace `smb-server.example.com` with the hostname or IP address of the SMB server.

---

### **Step 2: Test the SMB Share**
Use the `smbclient` utility to test access to the SMB share.

1. **List available shares**:
   ```bash
   smbclient -L //smb-server.example.com -U 'DOMAIN\username'
   ```
   - Replace `DOMAIN` with your domain name.
   - Replace `username` with your domain user account.
   - Enter the password when prompted.

2. **Access the specific share**:
   ```bash
   smbclient //smb-server.example.com/share-name -U 'DOMAIN\username'
   ```
   - Replace `share-name` with the name of the SMB share.

   If this works, the SMB server is accessible, and your credentials are valid.

---

### **Step 3: Create a Mount Point**
Create a directory to serve as the mount point for the SMB share.

```bash
sudo mkdir -p /mnt/smb-share
```

Replace `/mnt/smb-share` with your preferred mount location.

---

### **Step 4: Mount the SMB Share Temporarily**
Mount the SMB share using the `mount` command.

```bash
sudo mount -t cifs //smb-server.example.com/share-name /mnt/smb-share -o username=DOMAIN\\username,password=your_password,domain=DOMAIN,vers=2.0,sec=ntlmssp
```

- Replace:
  - `smb-server.example.com` with the SMB server's hostname or IP.
  - `share-name` with the SMB share's name.
  - `DOMAIN` with your domain name.
  - `username` with your username.
  - `your_password` with your password.
  - `vers=2.0` specifies the SMB protocol version (use `1.0`, `2.0`, or `3.0` depending on your server's configuration).
  - `sec=ntlmssp` ensures secure authentication.

**Verify:** Check the contents of the mounted directory:
```bash
ls /mnt/smb-share
```

---

### **Step 5: Mount the SMB Share Persistently**
To ensure the SMB share mounts automatically after a reboot:

#### a) **Create a Credentials File**
1. Create a file to securely store SMB credentials:
   ```bash
   sudo nano /etc/smbcredentials
   ```
2. Add the following content:
   ```
   username=DOMAIN\username
   password=your_password
   domain=DOMAIN
   ```
3. Save the file and set permissions:
   ```bash
   sudo chmod 600 /etc/smbcredentials
   ```

#### b) **Edit `/etc/fstab`**
Add an entry for the SMB share in the `/etc/fstab` file:

```bash
sudo nano /etc/fstab
```

Add this line at the end of the file:
```
//smb-server.example.com/share-name /mnt/smb-share cifs credentials=/etc/smbcredentials,vers=2.0,sec=ntlmssp,iocharset=utf8 0 0
```

#### c) **Test the Configuration**
Test the `/etc/fstab` entry by remounting all filesystems:
```bash
sudo mount -a
```

Verify the share is mounted:
```bash
ls /mnt/smb-share
```

---

### **Step 6: Troubleshooting**
If you encounter issues:
1. **Check Kernel Logs for CIFS Errors**:
   ```bash
   sudo dmesg | grep cifs
   ```
2. **Ensure Proper Permissions on the SMB Server**:
   - Verify that the user or group has the necessary access to the share.
3. **Adjust SMB Protocol Version**:
   - If `vers=2.0` doesn't work, try `vers=3.0` or `vers=1.0`.

---

### **Summary**
1. Install `cifs-utils` and `smbclient`.
2. Test connectivity and credentials using `smbclient`.
3. Mount the SMB share temporarily using `mount`.
4. Configure persistent mounting with a credentials file and `/etc/fstab`.

This process ensures secure, repeatable access to SMB shares on a domain-joined Ubuntu machine. Let me know if further clarification is needed!
