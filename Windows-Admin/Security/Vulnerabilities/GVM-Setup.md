For scanning Windows endpoints from an Ubuntu server, several free or low-cost vulnerability scanners can help identify vulnerabilities on Windows systems. Here are some options you can consider:

### **OpenVAS (Greenbone Vulnerability Manager)**
   - **Overview**: OpenVAS is a popular open-source tool for vulnerability scanning, which includes support for Windows endpoints.
   - **Setup**: It can be installed on Ubuntu and configured to scan remote Windows systems over the network.
   - **Capabilities**: Scans for vulnerabilities in operating systems, applications, and network protocols.
   - **Cost**: Free and open-source.
   - **Installation**:
     ```bash
     sudo apt update
     sudo apt install openvas
     sudo gvm-setup  
     ```
   - **Web Interface**: After installation, you can access OpenVAS through a web interface and configure it to scan Windows endpoints.

