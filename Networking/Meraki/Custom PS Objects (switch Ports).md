The short answer is: **You’re sending a “port” object to a cmdlet that wants “switch settings”**, and those are two different API payloads. Your `[PSCustomObject]` named `$sport17` is a single port’s configuration, but `Set-MerakiNetworkSwitchSettings` expects JSON for the entire switch’s settings (e.g., MAC blocklist, power exceptions, etc.), **not** per-port config.

Hence the `"Bad request: There was a problem in the JSON you submitted"` error: the JSON doesn’t match what `/networks/{networkId}/switch/settings` is expecting.

---

## 1. Use `Set-MerakiDeviceSwitchPort` (or similar) for Port Updates

If your goal is to **update an individual port** (or multiple ports), you usually need `Set-MerakiDeviceSwitchPort`:

```powershell
Set-MerakiDeviceSwitchPort `
  -AuthToken $token `
  -Serial    <YourSwitchSerial> `
  -PortId    <PortNumber> `
  -Name      <String or $null> `
  -Vlan      <Int> `
  -VoiceVlan <Int or $null> `
  ...[Other port attributes]...
```

This cmdlet corresponds to the “Update Device Switch Port” endpoint (`PUT /devices/{serial}/switch/ports/{portId}`). It’s the correct place to send port-level JSON, e.g.:

```powershell
$portObject = @{
    name             = "My Port Name"
    enabled          = $true
    poeEnabled       = $false
    type             = "trunk"
    vlan             = 198
    voiceVlan        = 13
    allowedVlans     = "all"
    rstpEnabled      = $true
    stpGuard         = "disabled"
    linkNegotiation  = "Auto negotiate"
    accessPolicyType = "Open"
    tags             = @("test")
}
$bodyJson = $portObject | ConvertTo-Json

Set-MerakiDeviceSwitchPort -AuthToken $token -Serial $switchSerial -PortId 17 -PortSettings $bodyJson
```

(See the docs/help for the exact parameter name—some versions want `-SwitchPort` or `-PortSettings` vs. each key individually.)

---

## 2. What `Set-MerakiNetworkSwitchSettings` Is For

By contrast, `Set-MerakiNetworkSwitchSettings` calls `PUT /networks/{networkId}/switch/settings`, which is an endpoint for **organization-wide or network-wide switch “global” settings**. For instance, the example from `Get-Help Set-MerakiNetworkSwitchSettings -Examples` shows a payload like:

```powershell
@{
  uplinkClientSampling = @{ enabled = $true }
  macBlocklist         = @{ enabled = $true }
  vlan                 = 100
  useCombinedPower     = $true
  powerExceptions      = @(
    @{ powerType = "redundant"; serial = "qwert-12345-qwert" }
  )
}
```

This is a totally different shape from a single port’s config, so sending your `$sport17` object there fails.

---

## 3. Summary

- **Updating a single port**: Use `Set-MerakiDeviceSwitchPort`, which will accept a JSON body describing that port’s config.
- **Updating global switch-level settings** (uplink sampling, MAC blocklist, global VLAN, etc.): Use `Set-MerakiNetworkSwitchSettings`.

Because you tried to feed per-port JSON into the global switch settings cmdlet, the API returned a 400 error about invalid JSON. Switch to the port-specific cmdlet/endpoint to fix the issue.