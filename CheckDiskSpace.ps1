<#
Author: Jonathan Parrilla
Created: 2/24/2015
Last Updated: 2/24/2015
Location - C:\Automation\Check_Disk_Space\CheckDiskSpace.ps1
#>

#Function CheckDiskSpace expects a server to be sent to it.
Function CheckDiskSpace([string] $server)
{
    #Does the server responds to a ping (otherwise the WMI queries will fail)
    $PingQuery = "select * from win32_pingstatus where address = '$server'"
    $PingResult = Get-WmiObject -query $PingQuery
    
    #Checks if the ping results are successful (Specifically the protocol address)
    if ($PingResult.protocoladdress) 
    {

        #Get the Disks for this server
        $AllDiskDrives = get-wmiobject Win32_LogicalDisk -computername $server -Filter "DriveType = 3"

        # For each disk calculate the free space
        foreach ($disk in $AllDiskDrives) 
        {
            #Checks to see if the disk's size is greater than 0 (which it should be)
            if ($disk.size -gt 0) 
            {
                #Get Total Disk Space in GB
                $TotalDiskSpace = [Math]::round(($disk.size/1000000000))
                
                #Get Free Disk Space in GB
                $FreeDiskSpace = [Math]::round(($disk.freespace/1000000000))
            
                #Calculates the free space % by taking the free space and dividing it by the total size then multiplying it by 100.
                $PercentFree = [Math]::round((($disk.freespace/$disk.size) * 100))
            }
            #Should the disk size be 0, then the free percentage should also be 0. (this should seldome if ever occur)
            else 
            {
                $PercentFree = 0
            }
            
            #Get the Drive Letter of the current disk
            $Drive = $disk.DeviceID
                
            #Write the results of the current Drive to a text file. The gui will use this file to update itself for the user's benefit.
            "$server  |   $Drive        |   $FreeDiskSpace GB            |  $TotalDiskSpace GB             |   $PercentFree%" | Out-File -Filepath "C:\Automation\PlaceForTextFiles\DriveSpace.txt" -Append
        }
    }
}

#***************************************************** END OF SCRIPT ****************************************************