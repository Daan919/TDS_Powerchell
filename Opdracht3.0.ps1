#Import-CSV -Path .\Bulkuitrol.csv | Write-Host "VMnaam=" + $_.VMnaam

#Import-CSV -Path .\Bulkuitrol.csv | ForEach-Object {Write-Host "VMnaam=" + $_.VMnaam}

#$temp=gc "temp.csv"
# $array=@()

# $temp | Foreach{
#     $elements=$_.split(",")
#     $array+= ,@($elements[0],$elements[1],$elements[2])
# }

# foreach($value in $array)
# {
#     write-host "EmpID =" $value[0] "and Name =" $value[1] "and Dept =" $value[2]
# }


$virtualmachines = Import-Csv -Path .\Bulkuitrol.csv
foreach($VM in $virtualmachines){
    
    # Genarate new GUID for the VM   
    $JobGroup_IO = [guid]::NewGuid().ToString()
    $JobGroup_VM = [guid]::NewGuid().ToString()
    # VM variables 
    $HW_profile = "W2019-HP1-VLAN0"
    $VM_Template = "W2019_Template_02"
    $temp_template = "Temporary Template" +[guid]::NewGuid().ToString()
    $PcName = $VM.CompNaam
    $VM_name = $VM.VMnaam
    $VM_disctiption = $VM.VMdesc

    $PcName
    $VM_name
    $VM_disctiption
    # Create administrator credentials
    $password = ConvertTo-SecureString “Password01” -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential ("administrator", $password)


    # Create en set IO VM
    New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup $JobGroup_IO -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 
    $ISO = Get-SCISO -VMMServer localhost -ID "20067900-bd4c-4e57-bda4-7ea35dee51c1" | where {$_.Name -eq "en_windows_server_2019_x64_dvd_4cb967d8.iso"}
    New-SCVirtualDVDDrive -VMMServer localhost -JobGroup $JobGroup_IO -Bus 1 -LUN 0 -ISO $ISO 
    $VMSubnet = Get-SCVMSubnet -VMMServer localhost -Name "VM10-5-vlan0_0" | where {$_.VMNetwork.ID -eq "943f13d1-988d-45ff-9a37-4bf5849d031e"}
    $VMNetwork = Get-SCVMNetwork -VMMServer localhost -Name "VM10-5-vlan0" -ID "943f13d1-988d-45ff-9a37-4bf5849d031e"
    New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup $JobGroup_IO -MACAddress "00:00:00:00:00:00" -MACAddressType Static -Synthetic -EnableVMNetworkOptimization $false -EnableMACAddressSpoofing $false -EnableGuestIPNetworkVirtualizationUpdates $false -IPv4AddressType Static -IPv6AddressType Dynamic -VMSubnet $VMSubnet -VMNetwork $VMNetwork 
    Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 1 -JobGroup $JobGroup_IO 
    Set-SCVirtualCOMPort -NoAttach -VMMServer localhost -GuestPort 2 -JobGroup $JobGroup_IO 
    Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer localhost -NoMedia -JobGroup $JobGroup_IO 

    # Create temporary template with selected template and hardware profile
    $Template = Get-SCVMTemplate -VMMServer localhost -ID "852dc4b4-a6c2-4f44-bf81-9e48918fc5ae" | where {$_.Name -eq $VM_template }
    $HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq $HW_profile}
    $OperatingSystem = Get-SCOperatingSystem -VMMServer localhost -ID "dffb90ce-abb0-4082-8764-fb08db195c05" | where {$_.Name -eq "Windows Server 2019 Standard"}

    New-SCVMTemplate -Name $temp_template -Template $Template -HardwareProfile $HardwareProfile -JobGroup $JobGroup_VM -ComputerName "comp01" -TimeZone 110  -Workgroup "WORKGROUP" -AnswerFile $null -OperatingSystem $OperatingSystem -UpdateManagementProfile $null 

    # Assign temporary template to VM
    $template = Get-SCVMTemplate -All | where { $_.Name -eq $temp_template }
    $virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name $VM_name
    Write-Output $virtualMachineConfiguration

    # Get VMM host to store VM
    $vmHost = Get-SCVMHost -ID "50fcc871-63a8-4f03-903b-8e356172f64f"

    # Create VM with given variables
    Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
    Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
    Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -ComputerName $PcName
    $AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration
    Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
    New-SCVirtualMachine -Name $VM_name -VMConfiguration $virtualMachineConfiguration -Description $VM_disctiption -BlockDynamicOptimization $false -JobGroup $JobGroup_VM -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "SaveVM" -LocalAdministratorCredential $Cred
}