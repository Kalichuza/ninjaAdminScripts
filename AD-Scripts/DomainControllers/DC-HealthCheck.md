Step-by-step guide covering the key checks you should regularly perform to maintain a solid baseline for your domain functions.

Let's dive in:

### **1. Check Active Directory Replication Health**
AD replication is vital for the consistency of domain data across all DCs.

- **Command:**
  ```powershell
  repadmin /replsummary
  ```
  This command provides a summary of replication status across all domain controllers, highlighting any errors or latency issues.

- **Detailed View:**
  ```powershell
  repadmin /showrepl
  ```
  This provides more detailed information about the inbound replication partners of each DC.

### **2. Validate DNS Health**
DNS is critical for the proper functioning of AD since domain controllers rely on it for communication.

- **Command:**
  ```powershell
  dcdiag /test:dns
  ```
  Run the `dcdiag` command with the `/test:dns` switch to validate the DNS server configuration, delegation, and overall health.

- **General DNS Health Check:**
  ```powershell
  Get-DnsServerDiagnostics
  ```
  This cmdlet can also provide additional insight into DNS server issues.

### **3. Domain Controller Diagnostic (DCDIAG)**
`DCDIAG` is a comprehensive tool for assessing the health of your domain controllers.

- **Command:**
  ```powershell
  dcdiag
  ```
  Running `dcdiag` without any parameters performs a full diagnostic check on all roles of the DC. Pay particular attention to any failed tests or warnings.

### **4. NtdsUtil Checks for Active Directory Database**
Checking the integrity of the AD database is crucial for domain health.

- **Command:**
  ```cmd
  ntdsutil
  ```
  Enter the interactive mode and use the following commands to check the integrity of the database:
  ```
  activate instance ntds
  files
  integrity
  ```
  This ensures there are no integrity issues with your AD database files.

### **5. Event Logs Monitoring**
Review the event logs on the Domain Controller for any errors or warnings related to:

- **Directory Service (Event Viewer > Applications and Services Logs > Directory Service)**
- **DNS Server (Event Viewer > Applications and Services Logs > DNS Server)**
- **System Log (Event Viewer > Windows Logs > System)**

Particularly look for events with IDs:
- **1844, 1925, 1311** (Replication issues)
- **4013, 4004** (DNS issues)

### **6. SYSVOL Health Check**
The SYSVOL folder should be replicated properly for group policies and scripts.

- **Command:**
  ```powershell
  dfsrdiag health
  ```
  This checks the status of DFSR replication. Make sure all domain controllers report the replication health as normal.

Alternatively, for environments using File Replication Service (FRS):
```powershell
ntfrsutl ds
```
This can give insights into FRS status.

### **7. Verify FSMO Role Holders**
Ensure that your Flexible Single Master Operations (FSMO) roles are functioning as expected and assigned correctly.

- **Command:**
  ```powershell
  netdom query fsmo
  ```
  Verify all FSMO roles are assigned as planned. Misplacement or failure of a FSMO role could degrade domain performance.

### **8. Time Synchronization**
Correct time synchronization is critical to Kerberos authentication.

- **Command:**
  ```powershell
  w32tm /monitor
  ```
  This checks the status of time synchronization across your domain controllers. Ensure all DCs are within the correct time skew.

### **9. Check Global Catalog Availability**
Global Catalog (GC) availability is critical for inter-domain operations.

- **Command:**
  ```powershell
  nltest /dsgetdc:<domainname> /GC
  ```
  This verifies if a DC is functioning properly as a Global Catalog server.

### **10. Check User Authentication and LDAP Functionality**
Validate that the LDAP server is responding properly and users can authenticate.

- **Command:**
  ```powershell
  nltest /sc_verify:<domainname>
  ```
  This command verifies that the secure channel between the DC and the domain is functioning properly.

### **11. Monitor CPU, Memory, and Disk Utilization**
Monitoring the resource utilization of your domain controllers is essential for ensuring the DC can handle load effectively.

- **Performance Counters to Monitor:**
  - **Processor Utilization**: Should stay under 75% under normal load.
  - **Memory Utilization**: Check for unusually high usage.
  - **Disk Space**: Ensure enough free space is available, especially for the volume holding the AD database (ntds.dit).

You can use PowerShell or Task Manager to check these metrics.

### **12. Automate Health Check with PowerShell Script**
To regularly run checks and export results, use PowerShell automation:

- **Example Script:**
  ```powershell
  $dcdiagResults = dcdiag /v
  $repadminResults = repadmin /replsummary
  $dfsResults = dfsrdiag health
  $nltestResults = nltest /sc_verify:<domainname>

  $reportPath = "C:\DCHealthCheckReport.txt"
  $results = @"
  DCDIAG Results:
  $dcdiagResults

  Replication Summary:
  $repadminResults

  DFSR Health:
  $dfsResults

  Secure Channel Verification:
  $nltestResults
  "@

  $results | Out-File -FilePath $reportPath
  Write-Host "Health Check Report saved to $reportPath"
  ```

### **13. Backup Status**
Ensure that your Active Directory and SYSVOL are regularly backed up to avoid data loss.

- **Command:**
  ```powershell
  wbadmin get versions -backuptarget:<DriveLetter>
  ```
  Confirm that the backups are recent and complete.

### **14. Additional Recommendations**
- **Schedule Regular Health Checks**: Automate the running of `dcdiag`, `repadmin`, and other checks on a daily or weekly basis.
- **Set Up Alerts**: Use monitoring tools like **SCOM**, **Splunk**, or **Nagios** to create alerts for critical errors.
  
### Summary
This baseline health check involves:
- Running **replication** and **dcdiag** checks.
- Monitoring **DNS**, **SYSVOL**, **FSMO roles**, **Time synchronization**, and **Global Catalog**.
- Reviewing **event logs** and **resource utilization**.
- Automating the collection and reporting of health check information.

These checks will help you maintain your domain controllers in a healthy state and avoid any major disruptions in your AD environment.

Would you like me to go into more detail on any of these steps or assist in automating these checks further?
