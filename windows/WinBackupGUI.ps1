# Author - Joshua Button - U168860

############
#References#
############

#Copy-Item documentation https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-6
#Chase Florell Check for USB Script https://github.com/ChaseFlorell/Powershell-Snippets/blob/master/check-for-local-usb-storage-device.ps1
#BurntToast Win10 Toast Notification Powershell Module https://github.com/Windos/BurntToast
#Forms Checkbox https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.checkbox?view=netframework-4.7.2

####################
#Load Prerequisites#
#################### 
[Net.ServicePointManager]::SecurityProtocol::Tls12 #Powershell uses TLS1.0 by default. This is now deprecated and many public webpages will not allow 1.0 request so we force Powershell to use 1.2
Install-Module -Name BurntToast #This install's a Powershell module for Win10 Notification creation

$ConfigFilePath = Join-Path $PSScriptRoot '\src\Config.xml' #Sets Folder for Config file to be stored in. 

$BackupFilePath = Join-Path $PSScriptRoot '\src\Backup.ps1' #Sets Path for Backup Script

$RestoreFilePath = Join-Path $PSScriptRoot '\src\Restore.ps1' #Sets Path for Restore Script

#Workaround for powershell not accepting relative paths for images. 
$logoPath = Join-Path $PSScriptRoot '\src\WinBackupLogo.png' #$PSScriptRoot gets the root directory path and then Join-Path apppends it to the file name.

#Tests to see if ConfigFile.xml exhists. If it doesn't; it will downlaod it from GitHub.
If(!(test-path $ConfigFilePath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/ConfigBackup.xml" -OutFile $ConfigFilePath
}

#Tests to see if Backup.ps1 exhists. If it doesn't; it will downlaod it from GitHub.
If(!(test-path $BackupFilePath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/Backup.ps1" -OutFile $ConfigFilePath
}

#Tests to see if Restore.ps1 exhists. If it doesn't; it will downlaod it from GitHub.
If(!(test-path $BackupFilePath)) 
{
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Bartolus99/L5_OS_Coursework/master/windows/src/Backup.ps1" -OutFile $ConfigFilePath
}

#Tests to see if WinBackupLogo.png exhists. If it doesn't; it will downlaod it from GitHub.
If(!(test-path $logoPath)) 
{
	Invoke-WebRequest -Uri "https://github.com/Bartolus99/L5_OS_Coursework/blob/master/windows/src/WinBackupLogo.png?raw=true" -OutFile $logoPath
}



[xml]$ConfigFile = Get-Content -path $ConfigFilePath #Pulls Config file and reads it ready to be queried

###########
#BUILD GUI#
###########
# This form was created using POSHGUI.com  a free online gui designer for PowerShell and then edited

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '349,221'
$Form.text                       = "Windows Backup Script - By Josh and Bart"
$Form.TopMost                    = $false
$Form.FormBorderStyle 			 = 'Fixed3D' #Disables resizing the form
$Form.MaximizeBox 				 = $false #Removes Maximize button
$Form.MinimizeBox 				 = $false #Removes Minimize button

$DocumentsCB                     = New-Object system.Windows.Forms.CheckBox
$DocumentsCB.text                = "Documents"
$DocumentsCB.AutoSize            = $false
$DocumentsCB.width               = 95
$DocumentsCB.height              = 20
$DocumentsCB.location            = New-Object System.Drawing.Point(21,70)
$DocumentsCB.Font                = 'Microsoft Sans Serif,10'
$DocumentsCB.Checked		     = [System.Convert]::ToBoolean($ConfigFile.Backup.Documents.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

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
$MusicCB.Checked				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Music.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$CustomFolder1                   = New-Object system.Windows.Forms.TextBox
$CustomFolder1.multiline         = $false
$CustomFolder1.text              = $ConfigFile.Backup.CustomFolder1.path #Pulls custom folder string from XML file
$CustomFolder1.width             = 120
$CustomFolder1.height            = 20
$CustomFolder1.location          = New-Object System.Drawing.Point(34,170)
$CustomFolder1.Font              = 'Microsoft Sans Serif,10'

$CustomFolder2                   = New-Object system.Windows.Forms.TextBox
$CustomFolder2.multiline         = $false
$CustomFolder2.text              = $ConfigFile.Backup.CustomFolder2.path #Pulls custom folder string from XML file
$CustomFolder2.width             = 120
$CustomFolder2.height            = 20
$CustomFolder2.location          = New-Object System.Drawing.Point(34,190)
$CustomFolder2.Font              = 'Microsoft Sans Serif,10'

$CustomCB1                       = New-Object system.Windows.Forms.CheckBox
$CustomCB1.AutoSize              = $false
$CustomCB1.width                 = 95
$CustomCB1.height                = 20
$CustomCB1.location              = New-Object System.Drawing.Point(21,170)
$CustomCB1.Font                  = 'Microsoft Sans Serif,10'
$CustomCB1.Checked			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder1.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$DesktopCB                       = New-Object system.Windows.Forms.CheckBox
$DesktopCB.text                  = "Desktop"
$DesktopCB.AutoSize              = $false
$DesktopCB.width                 = 95
$DesktopCB.height                = 20
$DesktopCB.location              = New-Object System.Drawing.Point(21,150)
$DesktopCB.Font                  = 'Microsoft Sans Serif,10'
$DesktopCB.Checked 				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Desktop.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$VideosCB                        = New-Object system.Windows.Forms.CheckBox
$VideosCB.text                   = "Videos"
$VideosCB.AutoSize               = $false
$VideosCB.width                  = 95
$VideosCB.height                 = 20
$VideosCB.location               = New-Object System.Drawing.Point(21,130)
$VideosCB.Font                   = 'Microsoft Sans Serif,10'
$VideosCB.Checked				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Videos.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$PicturesCB                      = New-Object system.Windows.Forms.CheckBox
$PicturesCB.text                 = "Pictures"
$PicturesCB.AutoSize             = $false
$PicturesCB.width                = 95
$PicturesCB.height               = 20
$PicturesCB.location             = New-Object System.Drawing.Point(21,110)
$PicturesCB.Font                 = 'Microsoft Sans Serif,10'
$PicturesCB.Checked 			 = [System.Convert]::ToBoolean($ConfigFile.Backup.Pictures.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$CustomCB2                       = New-Object system.Windows.Forms.CheckBox
$CustomCB2.AutoSize              = $false
$CustomCB2.width                 = 95
$CustomCB2.height                = 20
$CustomCB2.location              = New-Object System.Drawing.Point(21,190)
$CustomCB2.Font                  = 'Microsoft Sans Serif,10'
$CustomCB2.Checked				 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder2.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$RestoreButton                   = New-Object system.Windows.Forms.Button
$RestoreButton.text              = "RESTORE"
$RestoreButton.width             = 80
$RestoreButton.height            = 30
$RestoreButton.location          = New-Object System.Drawing.Point(193,182)
$RestoreButton.Font              = 'Comic Sans MS,10,style=Bold'
$RestoreButton.ForeColor         = "#4a90e2"

$BackupButton                    = New-Object system.Windows.Forms.Button
$BackupButton.text               = "BACKUP"
$BackupButton.width              = 66
$BackupButton.height             = 30
$BackupButton.location           = New-Object System.Drawing.Point(275,182)
$BackupButton.Font               = 'Comic Sans MS,10,style=Bold'
$BackupButton.ForeColor          = "#ff0000"

$WinForm1                        = New-Object system.Windows.Forms.Form
$WinForm1.ClientSize             = '349,221'
$WinForm1.text                   = "Form"
$WinForm1.TopMost                = $false

$WinForm2                        = New-Object system.Windows.Forms.Form
$WinForm2.ClientSize             = '349,221'
$WinForm2.text                   = "Form"
$WinForm2.TopMost                = $false


$Form.controls.AddRange(@($DocumentsCB,$Logo,$MusicCB,$CustomFolder1,$CustomFolder2,$CustomCB1,$DesktopCB,$VideosCB,$PicturesCB,$CustomCB2,$RestoreButton,$BackupButton))

###########
#Functions#
###########

#https://stackoverflow.com/questions/20886243/press-any-key-to-continue 
Function pause ($message)
{
    Write-Host "$message" -ForegroundColor Yellow
    $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

###############
#BUTTON EVENTS#
###############

$BackupButton.Add_Click(
        {    
		#When the button is pressed the current backup settings are saved to the Config.xml file. This can be seen below. Note the booleans must be convereted to strings to be stored.
		$ConfigFile.Backup.Documents.toBackup = [System.Convert]::ToString($DocumentsCB.checked)
		$ConfigFile.Backup.Music.toBackup = [System.Convert]::ToString($MusicCB.checked)
		$ConfigFile.Backup.Pictures.toBackup = [System.Convert]::ToString($PicturesCB.checked)
		$ConfigFile.Backup.Videos.toBackup = [System.Convert]::ToString($VideosCB.checked)
		$ConfigFile.Backup.Desktop.toBackup = [System.Convert]::ToString($DesktopCB.checked)
		$ConfigFile.Backup.CustomFolder1.toBackup = [System.Convert]::ToString($CustomCB1.checked)
		$ConfigFile.Backup.CustomFolder2.toBackup = [System.Convert]::ToString($CustomCB2.checked)
		$ConfigFile.Backup.CustomFolder1.path = $CustomFolder1.text  
		$ConfigFile.Backup.CustomFolder2.path = $CustomFolder2.text  
		$ConfigFile.Save($ConfigFilePath)
		&(Join-Path $PSScriptRoot '\src\Backup.ps1')
		}
    )

$RestoreButton.Add_Click(
        {    
		$ConfigFile.Backup.Documents.toBackup = [System.Convert]::ToString($DocumentsCB.checked)
		$ConfigFile.Backup.Music.toBackup = [System.Convert]::ToString($MusicCB.checked)
		$ConfigFile.Backup.Pictures.toBackup = [System.Convert]::ToString($PicturesCB.checked)
		$ConfigFile.Backup.Videos.toBackup = [System.Convert]::ToString($VideosCB.checked)
		$ConfigFile.Backup.Desktop.toBackup = [System.Convert]::ToString($DesktopCB.checked)
		$ConfigFile.Backup.CustomFolder1.toBackup = [System.Convert]::ToString($CustomCB1.checked)
		$ConfigFile.Backup.CustomFolder2.toBackup = [System.Convert]::ToString($CustomCB2.checked)
		$ConfigFile.Backup.CustomFolder1.path = $CustomFolder1.text  
		$ConfigFile.Backup.CustomFolder2.path = $CustomFolder2.text  
		$ConfigFile.Save($ConfigFilePath)
		&(Join-Path $PSScriptRoot '\src\Restore.ps1')
        }
    )	
	
###############
#Progam Begins#
###############
$Form.ShowDialog()

#DIALOG BOX
#[System.Windows.Forms.Messagebox]::Show("$DocumentsBackup`n$MusicBackup`n$PicturesBackup`n$VideosBackup`n$DesktopBackup",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
#
#USB DRIVE CHECK CODE##
#
#do {
#  	$UsbDisk = gwmi win32_diskdrive | ?{$_.interfacetype -eq "USB"} | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} |  %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} | %{$_.deviceid} 
#	if ( $UsbDisk -eq $null ) {  
#		pause("Press any key to search again!")
#		# DO NOT RUN THIS WITHOUT SOME SORT OF "PAUSE" function, otherwise this will loop until a USB stick is inserted.
#	}
#}
#while ($UsbDisk -eq $null)
#
# After the do loop, $UsbDisk will be the name of the drive letter (example: E:)