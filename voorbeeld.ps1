# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on maandag 17 februari 2020 15:37:44 by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------

#Alles in comments is het script van de andere machine


New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 
#New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 

#Volledige regel Die er in dit voorbeeld niet bij stond maar in de andere wel
#$ISO = Get-SCISO -VMMServer localhost -ID "20067900-bd4c-4e57-bda4-7ea35dee51c1" | where {$_.Name -eq "en_windows_server_2019_x64_dvd_4cb967d8.iso"}

New-SCVirtualDVDDrive -VMMServer localhost -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b -Bus 1 -LUN 0 
#New-SCVirtualDVDDrive -VMMServer localhost -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 -Bus 1 -LUN 0 -ISO $ISO

#Volledige regel Die er in dit voorbeeld niet bij stond maar in de andere wel
#$VMSubnet = Get-SCVMSubnet -VMMServer localhost -Name "VM10-5-vlan0_0" | where {$_.VMNetwork.ID -eq "943f13d1-988d-45ff-9a37-4bf5849d031e"}
#$VMNetwork = Get-SCVMNetwork -VMMServer localhost -Name "VM10-5-vlan0" -ID "943f13d1-988d-45ff-9a37-4bf5849d031e"

New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b -MACAddressType Dynamic -Synthetic -IPv4AddressType Dynamic -IPv6AddressType Dynamic 
#New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 -MACAddress "00:00:00:00:00:00" -MACAddressType Static -Synthetic -EnableVMNetworkOptimization $false -EnableMACAddressSpoofing $false -EnableGuestIPNetworkVirtualizationUpdates $false -IPv4AddressType Static -IPv6AddressType Dynamic -VMSubnet $VMSubnet -VMNetwork $VMNetwork 

Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 
#Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 

Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 
#et-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 

Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 
#Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 

$CPUType = Get-SCCPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
#$CPUType = Get-SCCPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
#$CapabilityProfile = Get-SCCapabilityProfile -VMMServer localhost | where {$_.Name -eq "Hyper-V"}

New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profile7f138022-af6a-4c39-aec8-39870992da6f" -Description "Profile used to create a VM/Template" -CPUCount 1 -MemoryMB 2048 -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -CheckpointType Production -Generation 1 -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 
#New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profile4a25b138-faa7-4a5d-ae79-37920260cca3" -Description "Profile used to create a VM/Template" -CPUCount 1 -MemoryMB 2048 -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -CPULimitFunctionality $false -CPULimitForMigration $false -CheckpointType Production -CapabilityProfile $CapabilityProfile -Generation 1 -JobGroup 0a503579-8680-459c-88bc-8aa6be9156e7 


$Template = Get-SCVMTemplate -VMMServer localhost -ID "852dc4b4-a6c2-4f44-bf81-9e48918fc5ae" | where {$_.Name -eq "W2019_Template_02"}
#$Template = Get-SCVMTemplate -VMMServer localhost -ID "852dc4b4-a6c2-4f44-bf81-9e48918fc5ae" | where {$_.Name -eq "W2019_Template_02"}
$HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq "Profile7f138022-af6a-4c39-aec8-39870992da6f"}
#$HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq "Profile4a25b138-faa7-4a5d-ae79-37920260cca3"}

$OperatingSystem = Get-SCOperatingSystem -VMMServer localhost -ID "dffb90ce-abb0-4082-8764-fb08db195c05" | where {$_.Name -eq "Windows Server 2019 Standard"}
#$OperatingSystem = Get-SCOperatingSystem -VMMServer localhost -ID "dffb90ce-abb0-4082-8764-fb08db195c05" | where {$_.Name -eq "Windows Server 2019 Standard"}

New-SCVMTemplate -Name "Temporary Template2afd32ee-225d-4599-a0bb-60c04eb3291f" -Template $Template -HardwareProfile $HardwareProfile -JobGroup 5c8a7ea0-4729-4229-afc7-51c9b79d1615 -ComputerName "comp01" -TimeZone 110  -Workgroup "WORKGROUP" -AnswerFile $null -OperatingSystem $OperatingSystem -UpdateManagementProfile $null 
#New-SCVMTemplate -Name "Temporary Templatef7410298-368d-47c8-a825-be27be64df5e" -Template $Template -HardwareProfile $HardwareProfile -JobGroup 2bc7b5d9-c54f-4c07-b988-d6a556ecb062 -ComputerName "comp01" -TimeZone 110  -Workgroup "WORKGROUP" -AnswerFile $null -OperatingSystem $OperatingSystem -UpdateManagementProfile $null 


$template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary Template2afd32ee-225d-4599-a0bb-60c04eb3291f" }
#$template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary Templatef7410298-368d-47c8-a825-be27be64df5e" }
$virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name "test-02"
#$virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name "Dit is VM naam"
Write-Output $virtualMachineConfiguration
#Write-Output $virtualMachineConfiguration
$vmHost = Get-SCVMHost -ID "50fcc871-63a8-4f03-903b-8e356172f64f"
#$vmHost = Get-SCVMHost -ID "50fcc871-63a8-4f03-903b-8e356172f64f"
Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
#Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
#Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
#Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -ComputerName "ComputerNaam"

$AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration
#$AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration


Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
#Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
New-SCVirtualMachine -Name "test-02" -VMConfiguration $virtualMachineConfiguration -Description "" -BlockDynamicOptimization $false -JobGroup "5c8a7ea0-4729-4229-afc7-51c9b79d1615" -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "SaveVM"
#New-SCVirtualMachine -Name "Dit is VM naam" -VMConfiguration $virtualMachineConfiguration -Description "Dit is VM description" -BlockDynamicOptimization $false -JobGroup "2bc7b5d9-c54f-4c07-b988-d6a556ecb062" -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "SaveVM"