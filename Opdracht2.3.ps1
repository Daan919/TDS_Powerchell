#https://www.powershellgallery.com/packages/Join-Object/2.0.1
#https://github.com/ili101/Join-Object/blob/master/README.md

$a = Get-SCVirtualMachine | Select-Object -Property Name  , Memory , Status , Owner 

$b = get-vm | Get-SCVirtualNetworkAdapter | Select-Object -Property Name , IPv4Addresses , IPv6Addresses 

$c = Join-Object -Left $b -Right $a -LeftJoinProperty 'Name' -RightJoinProperty 'Name'  

$c | Format-Table
$c | ConvertTo-Json