# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on donderdag 20 februari 2020 10:06:01 by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------


New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 

$ISO = Get-SCISO -VMMServer localhost -ID "20067900-bd4c-4e57-bda4-7ea35dee51c1" | where {$_.Name -eq "en_windows_server_2019_x64_dvd_4cb967d8.iso"}

New-SCVirtualDVDDrive -VMMServer localhost -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 -Bus 1 -LUN 0 -ISO $ISO 

$VMSubnet = Get-SCVMSubnet -VMMServer localhost -Name "VM10-5-vlan0_0" | where {$_.VMNetwork.ID -eq "943f13d1-988d-45ff-9a37-4bf5849d031e"}
$VMNetwork = Get-SCVMNetwork -VMMServer localhost -Name "VM10-5-vlan0" -ID "943f13d1-988d-45ff-9a37-4bf5849d031e"

New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 -MACAddress "00:00:00:00:00:00" -MACAddressType Static -Synthetic -EnableVMNetworkOptimization $false -EnableMACAddressSpoofing $false -EnableGuestIPNetworkVirtualizationUpdates $false -IPv4AddressType Static -IPv6AddressType Dynamic -VMSubnet $VMSubnet -VMNetwork $VMNetwork 


Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 


Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 


Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 

$CPUType = Get-SCCPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
$CapabilityProfile = Get-SCCapabilityProfile -VMMServer localhost | where {$_.Name -eq "Hyper-V"}

New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profile4a25b138-faa7-4a5d-ae79-37920260cca3" -Description "Profile used to create a VM/Template" -CPUCount 1 -MemoryMB 2048 -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -CPULimitFunctionality $false -CPULimitForMigration $false -CheckpointType Production -CapabilityProfile $CapabilityProfile -Generation 1 -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 



$Template = Get-SCVMTemplate -VMMServer localhost -ID "852dc4b4-a6c2-4f44-bf81-9e48918fc5ae" | where {$_.Name -eq "W2019_Template_02"}
$HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq "Profile4a25b138-faa7-4a5d-ae79-37920260cca3"}

$OperatingSystem = Get-SCOperatingSystem -VMMServer localhost -ID "dffb90ce-abb0-4082-8764-fb08db195c05" | where {$_.Name -eq "Windows Server 2019 Standard"}

New-SCVMTemplate -Name "Temporary Templatef7410298-368d-47c8-a825-be27be64df5e" -Template $Template -HardwareProfile $HardwareProfile -JobGroup 2bc7b5d9-c54f-4c07-b988-d6a556ecb062 -ComputerName "comp01" -TimeZone 110  -Workgroup "WORKGROUP" -AnswerFile $null -OperatingSystem $OperatingSystem -UpdateManagementProfile $null 



$template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary Templatef7410298-368d-47c8-a825-be27be64df5e" }
$virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name "Dit is VM naam"
Write-Output $virtualMachineConfiguration
$vmHost = Get-SCVMHost -ID "50fcc871-63a8-4f03-903b-8e356172f64f"
Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -ComputerName "ComputerNaam"

$AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration



Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
New-SCVirtualMachine -Name "Dit is VM naam" -VMConfiguration $virtualMachineConfiguration -Description "Dit is VM description" -BlockDynamicOptimization $false -JobGroup "2bc7b5d9-c54f-4c07-b988-d6a556ecb062" -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "SaveVM"
