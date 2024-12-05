Certainly! `nmap` is a powerful network scanning tool, used to discover hosts and services on a network, along with details about the target systems. Below, I'll break down some of the most useful `nmap` variations and commands that you might find helpful.

### Basic `nmap` Syntax
```bash
nmap [OPTIONS] [TARGET]
```
Where:
- `[OPTIONS]` allow you to customize your scan.
- `[TARGET]` can be an IP address, hostname, or a range/subnet of IPs.

### Useful `nmap` Variations

#### 1. **Basic Ping Scan**
```bash
nmap -sn 192.168.1.0/24
```
The `-sn` flag (previously `-sP`) disables port scanning and just checks which hosts are up by sending a ping. This is useful for quickly identifying live hosts on a network.

#### 2. **Port Scan for Open Ports**
```bash
nmap -p 22,80,443 192.168.1.10
```
The `-p` option allows you to specify which ports to scan. You can list them explicitly (`22,80,443`) or use a range (`-p 1-1000`). If you omit the `-p` flag, `nmap` will scan the 1000 most commonly used ports.

#### 3. **Service Version Detection**
```bash
nmap -sV 192.168.1.10
```
The `-sV` flag will attempt to determine the versions of the services running on open ports. This is useful for understanding the software and potential vulnerabilities on the target.

#### 4. **Operating System Detection**
```bash
nmap -O 192.168.1.10
```
The `-O` flag attempts to identify the target operating system. Note that this can sometimes be less reliable on heavily firewalled or customized systems.

#### 5. **Scan Multiple IPs or a Subnet**
```bash
nmap 192.168.1.1,192.168.1.2,192.168.1.10
nmap 192.168.1.0/24
```
You can either list specific IPs (comma-separated) or scan an entire subnet using CIDR notation (`192.168.1.0/24`).

#### 6. **Aggressive Scan**
```bash
nmap -A 192.168.1.10
```
The `-A` flag enables aggressive scan options, including:
- Service version detection (`-sV`).
- OS detection (`-O`).
- Traceroute.
- Common script scanning.

This provides a lot of detail but is more intrusive and takes longer than basic scans.

#### 7. **Save Scan Output to a File**
```bash
nmap -oN output.txt 192.168.1.10
```
The `-oN` flag saves the output in a normal human-readable format to a file (`output.txt`). You can also use `-oX` to save in XML format or `-oG` for a greppable output format.

#### 8. **UDP Scan**
```bash
nmap -sU 192.168.1.10
```
The `-sU` flag initiates a UDP scan. UDP scanning is typically slower and requires more packets since UDP does not have the same connection handshake as TCP.

#### 9. **TCP SYN Scan (Stealth Scan)**
```bash
nmap -sS 192.168.1.10
```
The `-sS` flag performs a TCP SYN scan. This is also called a "stealth scan" because it does not complete the TCP handshake, making it less likely to be detected by target systems.

#### 10. **Use Specific Scan Timing Templates**
```bash
nmap -T4 192.168.1.10
```
The `-T` flag allows you to adjust the timing of the scan. It ranges from `-T0` (slowest, most cautious) to `-T5` (fastest). For most purposes, `-T3` (normal) or `-T4` (faster) is sufficient. Faster scans can be more detectable by firewalls and IDS (Intrusion Detection Systems).

#### 11. **Scan All Ports**
```bash
nmap -p- 192.168.1.10
```
The `-p-` option tells `nmap` to scan all 65,535 TCP ports rather than just the default top 1000. This is more thorough but can be significantly slower.

#### 12. **Scan Using a Specific Source Port**
```bash
nmap --source-port 53 192.168.1.10
```
The `--source-port` flag can be used to specify a source port. This is useful for bypassing poorly configured firewalls that might allow traffic on certain source ports (e.g., DNS traffic on port 53).

#### 13. **Scan with Default Scripts**
```bash
nmap -sC 192.168.1.10
```
The `-sC` flag runs the default set of NSE (Nmap Scripting Engine) scripts. These scripts perform useful tasks, such as service detection and vulnerability checks, without being overly aggressive.

#### 14. **Use NSE for Vulnerability Scanning**
```bash
nmap --script vuln 192.168.1.10
```
The `--script` option can be used to run specific scripts or script categories. In this example, the `vuln` category runs scripts to check for known vulnerabilities on the target.

#### 15. **Detect Firewall or IDS**
```bash
nmap -sA 192.168.1.10
```
The `-sA` flag performs an ACK scan, which helps determine whether a host is protected by a firewall and, if so, what type of rules are in place (e.g., stateless vs. stateful).

#### 16. **Spoof MAC Address**
```bash
nmap --spoof-mac 00:11:22:33:44:55 192.168.1.10
```
The `--spoof-mac` flag allows you to spoof the MAC address used in the scan. This can be useful to avoid detection or for testing network devices that enforce MAC address restrictions.

#### 17. **Scan for Open Proxies**
```bash
nmap --script http-open-proxy -p 8080 192.168.1.0/24
```
This uses the `--script` option with the `http-open-proxy` script, which allows you to scan for open HTTP proxies in a network. This is useful for network security assessments.

#### 18. **Traceroute**
```bash
nmap --traceroute 192.168.1.10
```
The `--traceroute` flag will attempt to discover the route that packets take to reach the target. This can be useful for diagnosing network problems and mapping a network.

### Examples of Complex `nmap` Commands

1. **Full TCP Scan and Service Version Detection with Output to File**:
   ```bash
   nmap -sS -sV -oN full_scan.txt 192.168.1.10
   ```
   This command combines a SYN scan (`-sS`) and service version detection (`-sV`) while saving the results in a text file.

2. **Scan a Network with Top 100 Ports and Default Scripts**:
   ```bash
   nmap -sC -F 192.168.1.0/24
   ```
   The `-F` flag tells `nmap` to scan only the top 100 ports, and `-sC` runs the default scripts.

3. **Scan Using Specific Timing and Avoid Ping**:
   ```bash
   nmap -T4 -Pn 192.168.1.10
   ```
   The `-Pn` flag tells `nmap` to skip the ping phase and directly attempt port scans. This is useful if the target system blocks ICMP echo requests (commonly used by `ping`).

### Summary of Commonly Used `nmap` Options

| Option | Description                                  |
|--------|----------------------------------------------|
| `-sn`  | Ping scan only (no port scan).               |
| `-p`   | Specify ports to scan (e.g., `-p 80,443`).   |
| `-sV`  | Service version detection.                   |
| `-O`   | Detect operating system.                     |
| `-A`   | Aggressive scan (OS detection, version, scripts). |
| `-T`   | Timing templates (`0`-`5`, `5` is fastest).  |
| `-sU`  | UDP scan.                                    |
| `-sS`  | TCP SYN scan (stealth scan).                 |
| `-oN`  | Output to a normal text file.                |
| `-sC`  | Run default NSE scripts.                     |
| `--script` | Run a specific NSE script (e.g., `vuln`).|
| `-Pn`  | Skip host discovery (useful if ICMP is blocked). |
| `--traceroute` | Attempt traceroute to target.        |
| `-r`   | Scan ports sequentially (faster but noisier).|

### Summary Tips for `nmap`
- **Avoid Detection**: Use `-sS` (SYN scan) and adjust timing (`-T2` or `-T3`) to reduce the chance of being flagged by firewalls or IDS.
- **Identify Services**: Combine `-sV` (service version) with default scripts (`-sC`) for comprehensive information on each open port.
- **Customization**: Use NSE scripts for tailored scans. `nmap` has an extensive scripting library (`--script`) that allows you to run specific scripts for specific purposes, such as vulnerability detection or banner grabbing.

These variations will help you leverage `nmap` to its fullest capabilities, whether you're conducting a simple network inventory or a detailed security assessment.
