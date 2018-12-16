# Author Joshua Button - U1628860 - www.JoshuaButton.co.uk
# Co-Author Bartosz Stasik - U1730148

###########
#References#
###########

#https://stackoverflow.com/questions/25690038/how-do-i-properly-use-the-folderbrowserdialog-in-powershell

####################
#Load Prerequisites#
#################### 
$BackupFilePath		= Join-Path $ConfigFile.Backup.BackupLocation '\Backup.zip' #gets backup location from config.xml and appends file name using Join-Path

###########
#Functions#
###########

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

################
#Program Begins#
################
$RestorePath = Get-Folder #Calls Folder Browser Dialog Function
if($RestorePath -eq "CANCEL") #Checks if Folder Browser Dialog returned a path or if user canceled
{
		[System.Windows.Forms.MessageBox]::Show("You didn't choose a folder", "WINDOWS BACKUP") #Notifies user that they canceled
}
else
{
	If(test-path $BackupFilePath) #Checks if Backup.zip exists in the location specified in Config.xml
	{
		Expand-Archive -Force -LiteralPath $BackupFilePath -DestinationPath $RestorePath\RestoredFiles #Unzips backup.zip to users chosen location from Folder Dialog
		New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Restore", "Finished restore process!" #Makes a windows notification
	}
	else
	{
		[System.Windows.Forms.MessageBox]::Show("$BackupFilePath does not exist. Use the ""Backup Location"" button to choose the folder containing Backup.zip", "WINDOWS BACKUP") #Notifies user that Backup.zip does not exist. This will happen when Backup location is changed and then a backup isn't run before trying to restore from the location so the program can not find Backup.zip in the directory specified
	}
}
