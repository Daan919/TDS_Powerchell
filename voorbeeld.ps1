# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on maandag 17 februari 2020 15:37:44 by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------


New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 


New-SCVirtualDVDDrive -VMMServer localhost -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b -Bus 1 -LUN 0 


New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b -MACAddressType Dynamic -Synthetic -IPv4AddressType Dynamic -IPv6AddressType Dynamic 


Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 


Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 


Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 

$CPUType = Get-SCCPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}


New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profile7f138022-af6a-4c39-aec8-39870992da6f" -Description "Profile used to create a VM/Template" -CPUCount 1 -MemoryMB 2048 -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -CheckpointType Production -Generation 1 -JobGroup d90e3e82-46d3-4528-8bf4-3e4426d6146b 



$Template = Get-SCVMTemplate -VMMServer localhost -ID "852dc4b4-a6c2-4f44-bf81-9e48918fc5ae" | where {$_.Name -eq "W2019_Template_02"}
$HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq "Profile7f138022-af6a-4c39-aec8-39870992da6f"}

$OperatingSystem = Get-SCOperatingSystem -VMMServer localhost -ID "dffb90ce-abb0-4082-8764-fb08db195c05" | where {$_.Name -eq "Windows Server 2019 Standard"}

New-SCVMTemplate -Name "Temporary Template2afd32ee-225d-4599-a0bb-60c04eb3291f" -Template $Template -HardwareProfile $HardwareProfile -JobGroup 5c8a7ea0-4729-4229-afc7-51c9b79d1615 -ComputerName "comp01" -TimeZone 110  -Workgroup "WORKGROUP" -AnswerFile $null -OperatingSystem $OperatingSystem -UpdateManagementProfile $null 



$template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary Template2afd32ee-225d-4599-a0bb-60c04eb3291f" }
$virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name "test-02"
Write-Output $virtualMachineConfiguration
$vmHost = Get-SCVMHost -ID "50fcc871-63a8-4f03-903b-8e356172f64f"
Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration

$AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration



Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
New-SCVirtualMachine -Name "test-02" -VMConfiguration $virtualMachineConfiguration -Description "" -BlockDynamicOptimization $false -JobGroup "5c8a7ea0-4729-4229-afc7-51c9b79d1615" -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "SaveVM"
