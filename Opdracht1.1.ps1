
# genarate new GUID for the vm   
$GUID = New-Guid
$ISO = Get-SCISO -VMMServer localhost -ID "20067900-bd4c-4e57-bda4-7ea35dee51c1" | where {$_.Name -eq "en_windows_server_2019_x64_dvd_4cb967d8.iso"}

# create % set new IO for VM
New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup $GUID -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 

New-SCVirtualDVDDrive -VMMServer localhost -JobGroup $GUID -Bus 1 -LUN 0 
$VMSubnet = Get-SCVMSubnet -VMMServer localhost -Name "VM10-5-vlan0_0" | where {$_.VMNetwork.ID -eq "943f13d1-988d-45ff-9a37-4bf5849d031e"}
$VMNetwork = Get-SCVMNetwork -VMMServer localhost -Name "VM10-5-vlan0" -ID "943f13d1-988d-45ff-9a37-4bf5849d031e"
New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup $GUID -MACAddressType Dynamic -Synthetic -IPv4AddressType Dynamic -IPv6AddressType Dynamic 
Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup $GUID 
Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup $GUID 
Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup $GUID


$CPUType = Get-SCCPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profile7f138022-af6a-4c39-aec8-39870992da6f" -Description "Profile used to create a VM/Template" -CPUCount 1 -MemoryMB 2048 -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -CheckpointType Production -Generation 1 -JobGroup $GUID
