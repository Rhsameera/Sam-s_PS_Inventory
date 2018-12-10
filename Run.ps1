#---------------Sam's Inventory Script----- V.1.4-----------------#


$InputFilePath=".\host.csv"
$ErrorFilePath=".\"
$Hostname = Import-CSV $InputFilePath | %{$_.'Hostnames'}
$Hostname_type = $Hostname.GetType()
echo "Host Name`tSerial`tManufacturer`tModel`tPri. Monior Manuf.`tPri. Moni. Model`tPri Moni. Serial`tSec. Monitor Manuf.`tSec. Moni. Model`tSec. Moni. Serial`tMac Addr." >> results.csv
Function ConvertTo-Char
(	
	$Array
)
{
	$Output = ""
	ForEach($char in $Array)
	{	$Output += [char]$char -join ""
	}
	return $Output
}

if($Hostname_type.IsArray -eq $false){
        Write-Host -ForegroundColor DarkYellow "Gathering Data From " $Hostname"..." -NoNewline
        try{  
                                       
                            $SreipedSytemSer = Get-WMIObject -Class Win32_BIOS  -ComputerName $Hostname  | select -ExpandProperty SerialNumber
                            $StripedSysManu = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Hostname | select -ExpandProperty Manufacturer
                            $StripedSysModel = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Hostname | select -ExpandProperty Model
                            $SripedMAC = get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" -ComputerName $Hostname | select -ExpandProperty macaddress
                            $Monitors = Get-WmiObject -Query "Select * FROM WMIMonitorID" -Namespace root\wmi -ComputerName $Hostname
                            
                            $Results = ForEach ($Monitor in $Monitors){    
	                            New-Object PSObject -Property @{
	                            	ComputerName = $CName
	                            	Active = $Monitor.Active
	                            	Manufacturer = ConvertTo-Char($Monitor.ManufacturerName)
	                            	UserFriendlyName = ConvertTo-Char($Monitor.userfriendlyname)
	                            	SerialNumber = ConvertTo-Char($Monitor.serialnumberid)
                                    }
                            }


                            $StripedPriManu = $Results[0] | select -ExpandProperty Manufacturer
                            $StripedPriModel = $Results[0] | select -ExpandProperty UserFriendlyName
                            $StripedPriMonSerial = $Results[0] | select -ExpandProperty SerialNumber
                            
                            $StripedSecManu = $Results[1] | select -ExpandProperty Manufacturer
                            $StripedSecModel = $Results[1] | select -ExpandProperty UserFriendlyName
                            $StripedSecMonSerial = $Results[1] | select -ExpandProperty SerialNumber
                            $CSVHostname = $Hostname


                            echo "$CSVHostname`t$SreipedSytemSer`t$StripedSysManu`t$StripedSysModel`t$StripedPriManu`t$StripedPriModel`t$StripedPriMonSerial`t$StripedSecManu`t$StripedSecModel`t$StripedSecMonSerial`t$SripedMAC" >> results.csv



                            Write-Host -ForegroundColor DarkYellow `r`n$SreipedSytemSer 
                            Write-Host -ForegroundColor DarkYellow "--------------------------------------"
                            
                }catch{
                    Write-Host -ForegroundColor Red "Error while connecting or gathering data on " $Hostname[$i]
                   Add-Content error.txt $Hostname
                }
}else{
            for($i=0;$i -lt $Hostname.Length;$i++){
                Write-Host -ForegroundColor DarkYellow "Gathering Data From " $Hostname[$i] "..." -NoNewline
                           $connectivityavailability = Test-Connection -Count 1 -ComputerName $Hostname[$i]  -Quiet
                           
                           if ($connectivityavailability -eq $True) {
                                                               
                                     try{  
                                                    
                                         $SreipedSytemSer = Get-WMIObject -Class Win32_BIOS  -ComputerName $Hostname[$i]  | select -ExpandProperty SerialNumber
                                         $sysdetails = Get-WMIObject -ComputerName $Hostname[$i] -class Win32_ComputerSystem
                                         $StripedSysManu = $sysdetails.Manufacturer
                                         $StripedSysModel = $sysdetails.Model
                                         $SripedMAC = get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" -ComputerName $Hostname[$i] | select -ExpandProperty macaddress
                                         $Monitors = Get-WmiObject -Query "Select * FROM WMIMonitorID" -Namespace root\wmi -ComputerName $Hostname[$i]
                                         
                                         $Results = ForEach ($Monitor in $Monitors){    
	                                         New-Object PSObject -Property @{
	                                         	ComputerName = $CName
	                                         	Active = $Monitor.Active
	                                         	Manufacturer = ConvertTo-Char($Monitor.ManufacturerName)
	                                         	UserFriendlyName = ConvertTo-Char($Monitor.userfriendlyname)
	                                         	SerialNumber = ConvertTo-Char($Monitor.serialnumberid)
                                                 }
                                         }


                                         $StripedPriManu = $Results[0] | select -ExpandProperty Manufacturer
                                         $StripedPriModel = $Results[0] | select -ExpandProperty UserFriendlyName
                                         $StripedPriMonSerial = $Results[0] | select -ExpandProperty SerialNumber
                                         
                                         $StripedSecManu = $Results[1] | select -ExpandProperty Manufacturer
                                         $StripedSecModel = $Results[1] | select -ExpandProperty UserFriendlyName
                                         $StripedSecMonSerial = $Results[1] | select -ExpandProperty SerialNumber
                                         $CSVHostname = $Hostname[$i]


                                         echo "$CSVHostname`t$SreipedSytemSer`t$StripedSysManu`t$StripedSysModel`t$StripedPriManu`t$StripedPriModel`t$StripedPriMonSerial`t$StripedSecManu`t$StripedSecModel`t$StripedSecMonSerial`t$SripedMAC" >> results.csv



                                         Write-Host -ForegroundColor DarkYellow `r`n$SreipedSytemSer 
                                         Write-Host -ForegroundColor DarkYellow "--------------------------------------"
                                         
                                     }catch{
                                         Write-Host -ForegroundColor Red "Error while connecting or gathering data"
                                         $errHostname = $Hostname[$i]
                                         Add-Content error.txt $errHostname

                                     }

                                     }else{
                                     $errHostname = $Hostname[$i]
                                     Write-Host -ForegroundColor Red "Error While Connecting... Cannot ping the host $errHostname"
                                     $errHostname = $Hostname[$i]
                                         Add-Content error.txt $errHostname
                                     }

            }
                
 }
            
        
   





$Results = ForEach ($Monitor in $Query)
{    
	New-Object PSObject -Property @{
		ComputerName = $CName
		Active = $Monitor.Active
		Manufacturer = ConvertTo-Char($Monitor.ManufacturerName)
		UserFriendlyName = ConvertTo-Char($Monitor.userfriendlyname)
		SerialNumber = ConvertTo-Char($Monitor.serialnumberid)

	}
}

$Results | Select ComputerName,Active,Manufacturer,UserFriendlyName,SerialNumber,WeekOfManufacture,YearOfManufacture﻿
