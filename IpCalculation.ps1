[string]$ipAddress = "192.168.1.1/28"
[string]$ip = $IPAddress.Split("/")[0]
[string]$subnetMask  = $IPAddress.Split("/")[1]

$ipBinary = (($ip.Split(".") | ForEach-Object { [Convert]::ToString($_, 2).PadLeft(8, '0') }) -join "").Trim()
$ipBinaryMask = ("1" * $subnetMask + "0" * (32 - $subnetMask)).ToCharArray() -join ""
$bitwiseAndNetworkAddress = [convert]::ToString([convert]::ToInt32($ipBinary, 2) -band [convert]::ToInt32($ipBinaryMask, 2), 2)
$wildcardMask = (($ipBinaryMask.ToCharArray() | ForEach-Object { if($_ -eq '0'){ $_ = '1' }else{$_ = '0'};$_ }) -join "").Trim()

# Calculate the broadcast address
$broadcastAddressBinary = [convert]::ToString([convert]::ToInt32($bitwiseAndNetworkAddress, 2) -bor [convert]::ToInt32($wildcardMask, 2), 2).PadLeft(32, '0')

# Calculate the first and last usable addresses
$firstUsableAddressBinary = [convert]::ToString([convert]::ToInt32($bitwiseAndNetworkAddress, 2) + 1, 2).PadLeft(32, '0')
$lastUsableAddressBinary = [convert]::ToString([convert]::ToInt32($broadcastAddressBinary, 2) - 1, 2).PadLeft(32, '0')

$broadcastAddressDecimal = ($broadcastAddressBinary | Select-String -AllMatches -Pattern ".{1,$substringLength}" | Foreach-Object { $_.Matches.Value } | ForEach-Object { [convert]::ToInt32($_, 2) }) -join "."
$firstUsableAddressDecimal = ($firstUsableAddressBinary | Select-String -AllMatches -Pattern ".{1,$substringLength}" | Foreach-Object { $_.Matches.Value } | ForEach-Object { [convert]::ToInt32($_, 2) }) -join "."
$lastUsableAddressDecimal = ($lastUsableAddressBinary | Select-String -AllMatches -Pattern ".{1,$substringLength}" | Foreach-Object { $_.Matches.Value } | ForEach-Object { [convert]::ToInt32($_, 2) }) -join "."

Write-Host $ipBinary
Write-Host $ipBinaryMask
Write-Host $wildcardMask
Write-Host $bitwiseAndNetworkAddress
Write-Host $broadcastAddressBinary

Write-Host $broadcastAddressDecimal
Write-Host $firstUsableAddressDecimal
Write-Host $lastUsableAddressDecimal