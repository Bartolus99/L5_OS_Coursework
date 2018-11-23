# Author - Joshua Button - U168860

############
#References#
############

#Copy-Item documentation https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-6
#Chase Florell Check for USB Script https://github.com/ChaseFlorell/Powershell-Snippets/blob/master/check-for-local-usb-storage-device.ps1

####################
#Load Prerequisites#
#################### 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


###########
#Functions#
###########

#https://stackoverflow.com/questions/20886243/press-any-key-to-continue 
Function pause ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

#AddBackUpFolder?DialogFunction

###############
#Progam Begins#
###############
$oReturn=[System.Windows.Forms.Messagebox]::Show("Do you want to backup your Documents Folder?","BACKUP DOUCMENTS?",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
switch ($oReturn){
    
    "OK" {
		$DocumentsBackup = $TRUE
        }
    

    "Cancel" {
		$DocumentsBackup = $FALSE
    }
}

$oReturn=[System.Windows.Forms.Messagebox]::Show("Do you want to backup your Music Folder?","BACKUP MUSIC?",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
switch ($oReturn){
    
    "OK" {
		$MusicBackup = $TRUE
        }
    

    "Cancel" {
		$MusicBackup = $FALSE
    }
}

$oReturn=[System.Windows.Forms.Messagebox]::Show("Do you want to backup your Pictures Folder?","BACKUP PICTURES?",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
switch ($oReturn){
    
    "OK" {
		$PicturesBackup = $TRUE
        }
    

    "Cancel" {
		$PicturesBackup = $FALSE
    }
}

$oReturn=[System.Windows.Forms.Messagebox]::Show("Do you want to backup your Videos Folder?","BACKUP VIDEOS?",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
switch ($oReturn){
    
    "OK" {
		$VideosBackup = $TRUE
        }
    

    "Cancel" {
		$VideosBackup = $FALSE
    }
}

$oReturn=[System.Windows.Forms.Messagebox]::Show("Do you want to backup your Desktop Folder?","BACKUP DESKTOP?",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
switch ($oReturn){
    
    "OK" {
		$DesktopBackup = $TRUE
        }
    

    "Cancel" {
		$DesktopBackup = $FALSE
    }
}

[System.Windows.Forms.Messagebox]::Show("$DocumentsBackup`n$MusicBackup`n$PicturesBackup`n$VideosBackup`n$DesktopBackup",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
#$DocumentsBackup`n$MusicBackup`n$PicturesBackup`n$VideosBackup`n$DesktopBackup

do {
  	$UsbDisk = gwmi win32_diskdrive | ?{$_.interfacetype -eq "USB"} | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} |  %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} | %{$_.deviceid} 
	if ( $UsbDisk -eq $null ) {  
		pause("Press any key to search again!")
		# DO NOT RUN THIS WITHOUT SOME SORT OF "PAUSE" function, otherwise this will loop until a USB stick is inserted.
	}
}
while ($UsbDisk -eq $null)

# After the do loop, $UsbDisk will be the name of the drive letter (example: E:)