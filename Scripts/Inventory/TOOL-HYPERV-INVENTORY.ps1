$srv_list = @(
"srv1"
"srv2"
"hyperv-srv-1"
)


$password = ConvertTo-SecureString "Turbo!!!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("sebast1enq",$password)


foreach($srv in $srv_list){

Enter-PSSession -ComputerName $srv -Credential $cred

$hyperv_host_list = get-vm

$vm_details = foreach($vm in $hyperv_host_list){


        $vmname = $vm.name
        $disk = $vm.HardDrives
        $disk_n = $disk.count
        [string]$memory = $vm.MemoryStartup /1gb
        $memory = $memory + "GB"
        $cpu = $vm.ProcessorCount
        $state = $vm.State
        $vm_ip = @((Resolve-DnsName -Name $vmname).ipaddress)
        [string]$vm_ip = $vm_ip -join " "


        [int]$vhdsize = 0

        
        $disk | foreach{
                            $vhd = get-vhd -Path $_.path
                            [int]$size = $vhd.Size
                            [int]$vhdsize += $vhdsize + $size
                        }

        $vhdsize = [string]$vhdsize
        $vhdsize = $vhdsize /1gb
        [string]$vhdsize = [string]$vhdsize + "GB"


        # Host disk
        $disk = (get-wmiobject -Class "Win32_LogicalDisk").DeviceID

        $disk_size = @(
                        $disk | foreach{
                        $counter =  "\LogicalDisk($_)\Free Megabytes"
                        $host_disk_free_space = (get-counter -Counter $counter | select-object -ExpandProperty CounterSamples).cookedvalue
                        
                        $host_disk_free_space = [math]::Round($host_disk_free_space /1024)
                        $host_disk_free_space = [string]$host_disk_free_space + "GB"
                        $message = "$_ = $host_disk_free_space libre"
                        $message

                        }
                        )
        
       [string]$disk_size = $disk_size -join " "
        # vmhost  
        $vmhost = Get-VMHost -ComputerName $env:computername

        # host ip
        $host_ip = @((Resolve-DnsName -Name $env:computername).ipaddress)
        [string]$host_ip = $host_ip -join " "

        # host memory
        [string]$vmhost_memory = [math]::Round($vmhost.memorycapacity /1GB)
        $vmhost_memory = [string]$vmhost_memory + "GB"

        # Host CPU Count
        $vmhost_processor = $vmhost.LogicalProcessorCount

        # Host DISK Disk Time
        #Get-counter -ListSet * | where-object {$_.countersetname -eq "logicaldisk"} | select-object -ExpandProperty counter

        $disk_time = (get-counter -Counter "\logicaldisk(_total)\% disk time" | select-object -ExpandProperty CounterSamples).cookedvalue
        $disk_time = [math]::Round([string]$disk_time)
        $disk_time = [string]$disk_time + "%"


        # host Free memory
        $host_free_memory = (get-counter -Counter "\Memory\Available Bytes" | select-object -ExpandProperty CounterSamples).cookedvalue
        $host_free_memory = $host_free_memory /1gb
        $host_free_memory = [math]::Round([string]$host_free_memory)
        $host_free_memory = [string]$host_free_memory + "GB"

        # host CPU HOTE
        $host_cpu = (get-counter -Counter "\processor(_total)\% processor time" | select-object -ExpandProperty CounterSamples).cookedvalue
        $host_cpu = [math]::Round($host_cpu,2)
        $host_cpu = [string]$host_cpu + "%"
        
        [pscustomobject]@{

                    "VM Name" = $vmname
                    "VM State" = $state
                    "VM Number of vCPU" = $cpu
                    "VM Memory" = $memory
                    "VM Number of HardDrive" = $disk_n
                    "VM Total HardDrive Size" = $vhdsize
                    "VM IP address" = $vm_ip
                    "Hyper-V Host" = $env:computername
                    "Hyper-V Host IP" = $host_ip
                    "Hyper-V Host Number of Processor" = $vmhost_processor
                    "Hyper-V Host Free Memory" = $host_free_memory
                    "Hyper-V Host Maximum Memory" = $vmhost_memory
                    "Hyper-V Host processor" = $host_cpu
                    "Disk Utilisation Time" = $disk_time
                    "Hyper-V Host Disk Free space" = $disk_size

                   }

        }


$txt = $env:computername + "_.txt"

$savepath = "c:\windows\temp\$txt"

Remove-Item -path $savepath -Force


$vm_details | export-csv -path $savepath -Delimiter "|" -NoTypeInformation -Encoding UTF8 -Force


Exit-PSSession


$txt = $srv + "_.txt"

$share = "\\10.2.2.2\s"
$remotec = "\\$srv\C$\windows\temp\$txt"

Copy-Item -Path $remotec -Destination $share -Force
}





