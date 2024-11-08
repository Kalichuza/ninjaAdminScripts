
You can use the `Disable-NetAdapterBinding` command, specifically targeting IPv6 for this network adapter. Here's the command:

```powershell
Disable-NetAdapterBinding -Name "<net adapeter name>" -ComponentID ms_tcpip6
```

### Explanation:
- **`-Name "<net adapeter name>"`**: This specifies the network adapter by its name.
- **`-ComponentID ms_tcpip6`**: This identifies the IPv6 protocol stack to disable.

### Verify That IPv6 Is Disabled
After running the command, you can verify the IPv6 binding status with:

```powershell
Get-NetAdapterBinding -Name "<net adapeter name>" -ComponentID ms_tcpip6
```

If it has been disabled successfully, the output should show `Enabled: False`.

