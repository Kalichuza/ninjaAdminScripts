function Invoke-LogoffUser {
    param (
        [string]$userId
    )
    $users = quser
    $users | ? { $_ -match $userId } | % { logoff /id ($_.Split(' ')[2]) }
}
