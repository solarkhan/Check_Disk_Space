#*******************************
#Author: Jonathan Parrilla
#Created: 2/24/2015
#Last Updated: 2/24/2015
#*******************************

#Import the function(s) that are needed.
. CheckDiskSpace.ps1
. WriteToLog.ps1

#Clear the console screen
Clear-Host

#Called in order to draw the GUI frame.
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$AnyError = $false

#****DEFINES THE GUI FRAME****#

#Creates a new form/frame
$GuiWindow = New-Object System.Windows.Forms.Form 

#Title text for the frame
$GuiWindow.Text = "Check Free Disk Space on Servers"

#Size of the frame
#$iisResetGuiWindow.Size = New-Object System.Drawing.Size(350,310)
$GuiWindow.Size = New-Object System.Drawing.Size(800,600)

#Form/frame's start position. 
$GuiWindow.StartPosition = "CenterScreen"

#****DEFINES A BUTTON****#

#Create button. Define location, size, text and its 'on-click' response.
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(15,75)
$Button.Size = New-Object System.Drawing.Size(75,23)
$Button.Text = "Check"

#What to do after pressing "Check"
$Button.Add_Click(
{
    
    #Checks to see if user entered any servers.
    if($boxForServers.TextLength -eq 0)
    {
        
        #If no servers were provided, let the user know.
        $InstructionLabel.Text = "NO SERVER PROVIDED!!!!"

        $AnyError = $true

        #Write-Host $AnyError

    }
    else
    {
        if($AnyError-eq $true)
        {
            $InstructionLabel.Text = "Let's try this again. Place Server Below."

            #Write-Host $AnyError

            $AnyError = $false
        }

        #Assign the server entered by the user to $server
        $server = $boxForServers.Text;
    
        $DiskSpaceResults.Text = "
"
    
        CheckDiskSpace $server;
    
        $DiskSizes = Get-Content "C:\Automation\PlaceForTextFiles\DriveSpace.txt"

        foreach($Disk in $DiskSizes)
        {
            Write-Host $Disk
            $DiskSpaceResults.Text += "$Disk
"
        }

        $server = ""

        Remove-Item "C:\Automation\PlaceForTextFiles\DriveSpace.txt"

        $user = $env:USERNAME

        $scriptName = "GUI_Check_Disk_Space.ps1"

        $logName = "Check_Disk_Space.txt"

        WriteToLog $user $scriptName $logName

        Write-Host Script finished. Log has been updated.
    }

})

#Add the button the GUI
$GuiWindow.Controls.Add($Button)


#****DEFINES LABELS ****#

#Instruction Label
$InstructionLabel = New-Object System.Windows.Forms.Label
$InstructionLabel.Location = New-Object System.Drawing.Size(15,20) 
$InstructionLabel.Size = New-Object System.Drawing.Size(280,20) 
$InstructionLabel.Text = "Place Server Below"

$GuiWindow.Controls.Add($InstructionLabel)


#Result Columns
$ResultColumnLabel = New-Object System.Windows.Forms.Label
$ResultColumnLabel.Location = New-Object System.Drawing.Size(300,20) 
$ResultColumnLabel.Size = New-Object System.Drawing.Size(370,25) 
$ResultColumnLabel.Text = "Server Name   |   Drive  |   Free Space   |   Total Space   |   Free Space %"

$GuiWindow.Controls.Add($ResultColumnLabel)


#Results
$DiskSpaceResults = New-Object System.Windows.Forms.Label
$DiskSpaceResults.Location = New-Object System.Drawing.Size(300,30) 
$DiskSpaceResults.Size = New-Object System.Drawing.Size(370,400) 
$DiskSpaceResults.Text = "

"

$GuiWindow.Controls.Add($DiskSpaceResults)



#****DEFINES A TEXT BOX TO INPUT SERVERS****#

#Create the box. Define its location and size.
$boxForServers = New-Object System.Windows.Forms.TextBox 
$boxForServers.Location = New-Object System.Drawing.Size(15,40) 
$boxForServers.Size = New-Object System.Drawing.Size(200,50)

#Add box to the GUI
$GuiWindow.Controls.Add($boxForServers) 



#************* CREATING THE GUI *********************
#Make the GUI Window the Top most form.
$GuiWindow.Topmost = $True

#Activate the GUI window
$GuiWindow.Add_Shown({$GuiWindow.Activate()})

#Display the GUI Window
[void] $GuiWindow.ShowDialog()
