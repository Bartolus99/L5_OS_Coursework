# Author Joshua Button - U1628860 - www.JoshuaButton.co.uk
# Co-Author Bartosz Stasik - U1730148

#This script was originally developed for 

############
#References#
############

#BurntToast Win10 Toast Notification Powershell Module https://github.com/Windos/BurntToast
#Forms Checkbox https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.checkbox?view=netframework-4.7.2
#PoshGUI - Powershell GUI Builder http://www.PoshGUI.com 
#Invoke-WebRequest https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-6
#Get-Folder Dialog https://stackoverflow.com/questions/25690038/how-do-i-properly-use-the-folderbrowserdialog-in-powershell
#Windows logo modified from http://logos.wikia.com/wiki/File:Old-windows-logo.png

####################
#Load Prerequisites#
#################### 
[Net.ServicePointManager]::SecurityProtocol::Tls12 #Powershell uses TLS1.0 by default. This is now deprecated and many public webpages will not allow 1.0 request so we force Powershell to use 1.2
clear #Clear Powershell console to keep it clean (Setting TLS leaves a message in console)
Install-Module -Name BurntToast #This installs a Powershell module for Win10 Notification creation

$BackupLocation = $ConfigFile.Backup.BackupLocation #Pulls users backup location choice from XML file

$BackupScript = Join-Path $PSScriptRoot '\src\Backup.ps1'

#Powershell doesn't use relative paths very well so we use Join-Path to connect $PSScriptRoot (a powershell command to get root dir of script) with the rest of the path
$ConfigFilePath = Join-Path $PSScriptRoot '\src\Config.xml' #Sets Folder for Config file to be stored in. 

$BackupFilePath = Join-Path $PSScriptRoot '\src\Backup.ps1' #Sets Path for Backup Script

$RestoreFilePath = Join-Path $PSScriptRoot '\src\Restore.ps1' #Sets Path for Restore Script

$SrcDirPath = Join-Path $PSScriptRoot '\src' #Sets Path for src folder in root

$logoPath = Join-Path $PSScriptRoot '\src\WinBackupLogo.png' #Sets path for scripts logo in GUI and Noticiations

#Checks if src directory exists in root
If(!(test-path $SrcDirPath)) 
{
	mkdir src #Creates "src" directory in root
	clear #Clears screen to keep it clean
}

#Tests to see if ConfigFile.xml exists. If it doesn't; it will download it from GitHub.
If(!(test-path $ConfigFilePath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/Config.xml" -OutFile $ConfigFilePath
}

#Tests to see if Backup.ps1 exists. If it doesn't; it will download it from GitHub.
If(!(test-path $BackupFilePath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/Backup.ps1" -OutFile $BackupFilePath
}

#Tests to see if Restore.ps1 exists. If it doesn't; it will download it from GitHub.
If(!(test-path $RestoreFilePath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/Restore.ps1" -OutFile $RestoreFilePath
}

#Tests to see if WinBackupLogo.png exists. If it doesn't; it will download it from GitHub.
If(!(test-path $logoPath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/WinBackupLogo.png" -OutFile $logoPath
}



[xml]$ConfigFile = Get-Content -path $ConfigFilePath #Pulls Config file and reads it ready to be queried

###############
#MAIN MENU GUI#
###############

#This form was created using POSHGUI.com a free online GUI designer for PowerShell
#PoshGUI was used to decide on initial layout of buttons and generate starting code
#Then all edits and button interactions were coded in Notepad++

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '349,221'
$Form.text                       = "Windows Backup Script - By Josh and Bart"
$Form.TopMost                    = $false
$Form.FormBorderStyle 			 = 'Fixed3D' #Disables resizing the form window
$Form.MaximizeBox 				 = $false #Removes Maximize button
$Form.MinimizeBox 				 = $false #Removes Minimize button

$DocumentsCB                     = New-Object system.Windows.Forms.CheckBox
$DocumentsCB.text                = "Documents"
$DocumentsCB.AutoSize            = $false
$DocumentsCB.width               = 95
$DocumentsCB.height              = 20
$DocumentsCB.location            = New-Object System.Drawing.Point(21,70)
$DocumentsCB.Font                = 'Microsoft Sans Serif,10'
$DocumentsCB.Checked		     = [System.Convert]::ToBoolean($ConfigFile.Backup.Documents.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$Logo                     		 = New-Object system.Windows.Forms.PictureBox
$Logo.width               		 = 200
$Logo.height              		 = 60
$Logo.location            		 = New-Object System.Drawing.Point(13,10)
$Logo.imageLocation       		 = "$logoPath"
$Logo.SizeMode      	         = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$MusicCB                         = New-Object system.Windows.Forms.CheckBox
$MusicCB.text                    = "Music"
$MusicCB.AutoSize                = $false
$MusicCB.width                   = 95
$MusicCB.height                  = 20
$MusicCB.location                = New-Object System.Drawing.Point(21,90)
$MusicCB.Font                    = 'Microsoft Sans Serif,10'
$MusicCB.Checked				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Music.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$CustomFolder1                   = New-Object system.Windows.Forms.TextBox
$CustomFolder1.multiline         = $false
$CustomFolder1.text              = $ConfigFile.Backup.CustomFolder1.path #Pulls custom folder string from XML file
$CustomFolder1.width             = 120
$CustomFolder1.height            = 20
$CustomFolder1.location          = New-Object System.Drawing.Point(34,170)
$CustomFolder1.Font              = 'Microsoft Sans Serif,10'
$CustomFolder1.ReadOnly			 = $true

$CustomFolder2                   = New-Object system.Windows.Forms.TextBox
$CustomFolder2.multiline         = $false
$CustomFolder2.text              = $ConfigFile.Backup.CustomFolder2.path #Pulls custom folder string from XML file
$CustomFolder2.width             = 120
$CustomFolder2.height            = 20
$CustomFolder2.location          = New-Object System.Drawing.Point(34,190)
$CustomFolder2.Font              = 'Microsoft Sans Serif,10'
$CustomFolder2.ReadOnly			 = $true

$CustomCB1                       = New-Object system.Windows.Forms.CheckBox
$CustomCB1.AutoSize              = $false
$CustomCB1.width                 = 95
$CustomCB1.height                = 20
$CustomCB1.location              = New-Object System.Drawing.Point(21,170)
$CustomCB1.Font                  = 'Microsoft Sans Serif,10'
$CustomCB1.Checked			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder1.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$DesktopCB                       = New-Object system.Windows.Forms.CheckBox
$DesktopCB.text                  = "Desktop"
$DesktopCB.AutoSize              = $false
$DesktopCB.width                 = 95
$DesktopCB.height                = 20
$DesktopCB.location              = New-Object System.Drawing.Point(21,150)
$DesktopCB.Font                  = 'Microsoft Sans Serif,10'
$DesktopCB.Checked 				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Desktop.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$VideosCB                        = New-Object system.Windows.Forms.CheckBox
$VideosCB.text                   = "Videos"
$VideosCB.AutoSize               = $false
$VideosCB.width                  = 95
$VideosCB.height                 = 20
$VideosCB.location               = New-Object System.Drawing.Point(21,130)
$VideosCB.Font                   = 'Microsoft Sans Serif,10'
$VideosCB.Checked				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Videos.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$PicturesCB                      = New-Object system.Windows.Forms.CheckBox
$PicturesCB.text                 = "Pictures"
$PicturesCB.AutoSize             = $false
$PicturesCB.width                = 95
$PicturesCB.height               = 20
$PicturesCB.location             = New-Object System.Drawing.Point(21,110)
$PicturesCB.Font                 = 'Microsoft Sans Serif,10'
$PicturesCB.Checked 			 = [System.Convert]::ToBoolean($ConfigFile.Backup.Pictures.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$CustomCB2                       = New-Object system.Windows.Forms.CheckBox
$CustomCB2.AutoSize              = $false
$CustomCB2.width                 = 95
$CustomCB2.height                = 20
$CustomCB2.location              = New-Object System.Drawing.Point(21,190)
$CustomCB2.Font                  = 'Microsoft Sans Serif,10'
$CustomCB2.Checked				 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder2.toBackup) #Pulls checked status from Config file. XML can only store strings so when it pulls the data out it uses "[System.Convert]::ToBoolean" to convert the string to a boolean.

$RestoreButton                   = New-Object system.Windows.Forms.Button
$RestoreButton.text              = "RESTORE"
$RestoreButton.width             = 80
$RestoreButton.height            = 30
$RestoreButton.location          = New-Object System.Drawing.Point(193,182)
$RestoreButton.Font              = 'Comic Sans MS,10,style=Bold' #The best font
$RestoreButton.ForeColor         = "#4a90e2"

$BackupButton                    = New-Object system.Windows.Forms.Button
$BackupButton.text               = "BACKUP"
$BackupButton.width              = 66
$BackupButton.height             = 30
$BackupButton.location           = New-Object System.Drawing.Point(275,182)
$BackupButton.Font               = 'Comic Sans MS,10,style=Bold' #The best font
$BackupButton.ForeColor          = "#ff0000"

$BackupLocationButton            = New-Object system.Windows.Forms.Button
$BackupLocationButton.text       = "BACKUP LOCATION"
$BackupLocationButton.width      = 149
$BackupLocationButton.height     = 30
$BackupLocationButton.location   = New-Object System.Drawing.Point(193,70)
$BackupLocationButton.Font       = 'Comic Sans MS,10,style=Bold' #The best font
$BackupLocationButton.ForeColor  = "#33cc33"

$WinForm1                        = New-Object system.Windows.Forms.Form
$WinForm1.ClientSize             = '349,221'
$WinForm1.text                   = "Form"
$WinForm1.TopMost                = $false

$WinForm2                        = New-Object system.Windows.Forms.Form
$WinForm2.ClientSize             = '349,221'
$WinForm2.text                   = "Form"
$WinForm2.TopMost                = $false

#The order of this array is the order the form items will be drawn in
$Form.controls.AddRange(@($DocumentsCB,$Logo,$MusicCB,$CustomFolder1,$CustomFolder2,$CustomCB1,$DesktopCB,$VideosCB,$PicturesCB,$CustomCB2,$RestoreButton,$BackupButton,$BackupLocationButton)) 

###############
#SCHEDULER GUI#
###############

$TimeSel 						= New-Object System.Windows.Forms.Form
$TimeSel.Text 					= 'Select a time'
$TimeSel.Size 					= New-Object System.Drawing.Size(300,200)
$TimeSel.StartPosition 			= 'CenterScreen'
$TimeSel.FormBorderStyle 		= 'Fixed3D' #Disables resizing the form window
$TimeSel.MaximizeBox 			= $false #Removes Maximize button
$Timesel.MinimizeBox 			= $false #Removes Minimize button

$OKButton 						= New-Object System.Windows.Forms.Button
$OKButton.Location 				= New-Object System.Drawing.Point(75,120)
$OKButton.Size 					= New-Object System.Drawing.Size(75,23)
$OKButton.Text 					= 'OK'
$OKButton.DialogResult 			= [System.Windows.Forms.DialogResult]::OK
$TimeSel.AcceptButton 			= $OKButton
$TimeSel.Controls.Add($OKButton)

$CancelButton 					= New-Object System.Windows.Forms.Button
$CancelButton.Location 			= New-Object System.Drawing.Point(150,120)
$CancelButton.Size 				= New-Object System.Drawing.Size(75,23)
$CancelButton.Text 				= 'Cancel'
$CancelButton.DialogResult 		= [System.Windows.Forms.DialogResult]::Cancel
$TimeSel.CancelButton 			= $CancelButton
$TimeSel.Controls.Add($CancelButton)

$label 							= New-Object System.Windows.Forms.Label
$label.Location 				= New-Object System.Drawing.Point(10,20)
$label.Size 					= New-Object System.Drawing.Size(280,30)
$label.Text 					= 'Please select a time you want your daily backups to happen'
$TimeSel.Controls.Add($label)

$listBox 						= New-Object System.Windows.Forms.ListBox
$listBox.Location 				= New-Object System.Drawing.Point(10,55)
$listBox.Size 					= New-Object System.Drawing.Size(260,20)
$listBox.Height 				= 80

[void] $listBox.Items.Add('12am')
[void] $listBox.Items.Add('1am')
[void] $listBox.Items.Add('2am')
[void] $listBox.Items.Add('3am')
[void] $listBox.Items.Add('4am')
[void] $listBox.Items.Add('5am')
[void] $listBox.Items.Add('6am')
[void] $listBox.Items.Add('7am')
[void] $listBox.Items.Add('8am')
[void] $listBox.Items.Add('9am')
[void] $listBox.Items.Add('10am')
[void] $listBox.Items.Add('11am')
[void] $listBox.Items.Add('12pm')
[void] $listBox.Items.Add('1pm')
[void] $listBox.Items.Add('2pm')
[void] $listBox.Items.Add('3pm')
[void] $listBox.Items.Add('4pm')
[void] $listBox.Items.Add('5pm')
[void] $listBox.Items.Add('6pm')
[void] $listBox.Items.Add('7pm')
[void] $listBox.Items.Add('8pm')
[void] $listBox.Items.Add('9pm')
[void] $listBox.Items.Add('10pm')
[void] $listBox.Items.Add('11pm')


$TimeSel.Controls.Add($listBox)

$TimeSel.Topmost = $true

###########
#Functions#
###########

#https://stackoverflow.com/questions/25690038/how-do-i-properly-use-the-folderbrowserdialog-in-powershell
Function Get-Folder() #Defines name of function
{
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog #Creates a Folder Browser Dialog as a new object
    $foldername.Description = "Select a folder to save your Backup to:" #Sets Dialog description text
    $foldername.rootfolder = "MyComputer" #Sets the starting dir for Folder Browser
	
    if($foldername.ShowDialog() -eq 'OK') #Check's to see if "OK" button was pressed
    {
        $folder = $foldername.SelectedPath #Gets the selected path from dialog and stores it
    }
	else
	{
		$folder = "CANCEL" #Sets $folder variable to CANCEL to notify that user closed the dialog or pressed cancel
	}
    return $folder #Returns either the chosen path or "CANCEL"
}

###############
#BUTTON EVENTS#
###############

$BackupButton.Add_Click(
        {    
		#When the button is pressed the current backup settings are saved to the Config.xml file. This can be seen below. Note the booleans must be converted to strings to be stored.
		$ConfigFile.Backup.Documents.toBackup = [System.Convert]::ToString($DocumentsCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Music.toBackup = [System.Convert]::ToString($MusicCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Pictures.toBackup = [System.Convert]::ToString($PicturesCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Videos.toBackup = [System.Convert]::ToString($VideosCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Desktop.toBackup = [System.Convert]::ToString($DesktopCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.CustomFolder1.toBackup = [System.Convert]::ToString($CustomCB1.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.CustomFolder2.toBackup = [System.Convert]::ToString($CustomCB2.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.CustomFolder1.path = $CustomFolder1.text #Writes string from Textbox to ConfigFile 
		$ConfigFile.Backup.CustomFolder2.path = $CustomFolder2.text #Writes string from Textbox to ConfigFile 
		$ConfigFile.Save($ConfigFilePath) #Config file saved
		$result = $TimeSel.ShowDialog()
		if ($result -eq [System.Windows.Forms.DialogResult]::OK)
			{
				$time = $listBox.SelectedItem
				$action = New-ScheduledTaskAction -Execute $BackupScript
				$trigger =  New-ScheduledTaskTrigger -Daily -At $time
				Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Backup Script" -Description "Daily backup"
				[System.Windows.Forms.MessageBox]::Show("Backups will now be done daily at $time to $BackupLocation\Backup.zip", "WINDOWS BACKUP") #Notifies user of the change in backup location
			}
		}
	)

$RestoreButton.Add_Click(
        {    
		#When the button is pressed the current backup settings are saved to the Config.xml file. This can be seen below. Note the booleans must be converted to strings to be stored.
		$ConfigFile.Backup.Documents.toBackup = [System.Convert]::ToString($DocumentsCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Music.toBackup = [System.Convert]::ToString($MusicCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Pictures.toBackup = [System.Convert]::ToString($PicturesCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Videos.toBackup = [System.Convert]::ToString($VideosCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.Desktop.toBackup = [System.Convert]::ToString($DesktopCB.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.CustomFolder1.toBackup = [System.Convert]::ToString($CustomCB1.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.CustomFolder2.toBackup = [System.Convert]::ToString($CustomCB2.checked) #Converts boolean from Checkbox to a string to write to ConfigFile 
		$ConfigFile.Backup.CustomFolder1.path = $CustomFolder1.text #Writes string from Textbox to ConfigFile 
		$ConfigFile.Backup.CustomFolder2.path = $CustomFolder2.text #Writes string from Textbox to ConfigFile  
		$ConfigFile.Save($ConfigFilePath) #Config file saved
		&(Join-Path $PSScriptRoot '\src\Restore.ps1') #Join-Path connects the root directory with the path to the restore program so "&" can be used to execute the script.
        }
    )	 
	
#Button displays a Folder Selection dialog
$BackupLocationButton.Add_Click(
		{
			$BackupLocation = Get-Folder #Folder selection written to variable
			if($BackupLocation -eq "CANCEL") #Checks if Get-Folder returned a path or "CANCEL"
			{
				[System.Windows.Forms.MessageBox]::Show("You didn't choose a folder", "WINDOWS BACKUP") #Notifies user that they didn't select a path
			}
			else
			{
				$ConfigFile.Backup.BackupLocation = $BackupLocation #Variable written to XML file
				$ConfigFile.Save($ConfigFilePath) #Config File Saved
				[System.Windows.Forms.MessageBox]::Show("Backups will now de saved to $BackupLocation\Backup.zip", "WINDOWS BACKUP") #Notifies user of the change in backup location
			}
		}
	)

#Clicking the text box displays a Folder Selection dialog.	
$CustomFolder1.Add_Click(
		{
			$FolderDialogReturn = Get-Folder #Folder choice is written into text box
			if($FolderDialogReturn -eq "CANCEL") #Checks if Get-Folder returned a path or "CANCEL"
			{
				[System.Windows.Forms.MessageBox]::Show("You didn't choose a folder", "WINDOWS BACKUP") #Notifies user that they didn't select a path
			}
			else
			{
				$CustomFolder1.text = $FolderDialogReturn #Sets Text box text to users choice from Folder Selection Dialog
				$ConfigFile.Backup.CustomFolder1.path = $CustomFolder1.text #Choice is written to config file
				$CustomCB1.Checked = $true #Check box is set to true to add folder to backup list
				$ConfigFile.Save($ConfigFilePath) #Config file saved
			}
		}
	)

#Clicking the text box displays a Folder Selection dialog	
$CustomFolder2.Add_Click(
		{
			$FolderDialogReturn = Get-Folder #Folder choice is written into text box
			if($FolderDialogReturn -eq "CANCEL") #Checks if Get-Folder returned a path or "CANCEL"
			{
				[System.Windows.Forms.MessageBox]::Show("You didn't choose a folder", "WINDOWS BACKUP") #Notifies user that they didn't select a path
			}
			else
			{
				$CustomFolder2.text = $FolderDialogReturn #Sets Text box text to users choice from Folder Selection Dialog
				$ConfigFile.Backup.CustomFolder1.path = $CustomFolder2.text #Choice is written to config file
				$CustomCB2.Checked = $true	#Check box is set to true to add folder to backup list
				$ConfigFile.Save($ConfigFilePath) #Config file saved
			}
		}
	)
		
################
#Program Begins#
################
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	$Form.ShowDialog() #Display GUI
}
else
{
  Write-Output "Please run the Script in a Elevated Powershell."
}

