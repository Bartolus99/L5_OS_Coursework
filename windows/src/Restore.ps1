# Author Joshua Button - U1628860 - www.JoshuaButton.co.uk
# Co-Author Bartosz Stasik - U1730148

############
#REFERENCES#
############

#https://stackoverflow.com/questions/25690038/how-do-i-properly-use-the-folderbrowserdialog-in-powershell

####################
#Load Prerequisites#
#################### 
$BackupFolder		= $ConfigFile.Backup.BackupLocation #gets backup location from config.xml
$WildcardPath 		= $BackupFolder + "*.backup"

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

#####
#GUI#
#####
$RestoreSelect 					= New-Object System.Windows.Forms.Form
$RestoreSelect.Text 			= 'Select a time'
$RestoreSelect.Size 			= New-Object System.Drawing.Size(300,200)
$RestoreSelect.StartPosition 	= 'CenterScreen'
$RestoreSelect.FormBorderStyle 	= 'Fixed3D' #Disables resizing the form window
$RestoreSelect.MaximizeBox 		= $false #Removes Maximize button
$Timesel.MinimizeBox 			= $false #Removes Minimize button

$OKButton 						= New-Object System.Windows.Forms.Button
$OKButton.Location 				= New-Object System.Drawing.Point(75,120)
$OKButton.Size 					= New-Object System.Drawing.Size(75,23)
$OKButton.Text 					= 'OK'
$OKButton.DialogResult 			= [System.Windows.Forms.DialogResult]::OK
$RestoreSelect.AcceptButton 			= $OKButton
$RestoreSelect.Controls.Add($OKButton)

$CancelButton 					= New-Object System.Windows.Forms.Button
$CancelButton.Location 			= New-Object System.Drawing.Point(150,120)
$CancelButton.Size 				= New-Object System.Drawing.Size(75,23)
$CancelButton.Text 				= 'Cancel'
$CancelButton.DialogResult 		= [System.Windows.Forms.DialogResult]::Cancel
$RestoreSelect.CancelButton 			= $CancelButton
$RestoreSelect.Controls.Add($CancelButton)
$label 							= New-Object System.Windows.Forms.Label
$label.Location 				= New-Object System.Drawing.Point(10,20)
$label.Size 					= New-Object System.Drawing.Size(280,30)
$label.Text 					= 'Here is a list of all your backups'
$RestoreSelect.Controls.Add($label)

$listBox 						= New-Object System.Windows.Forms.ListBox
$listBox.Location 				= New-Object System.Drawing.Point(10,55)
$listBox.Size 					= New-Object System.Drawing.Size(260,20)
$listBox.Height 				= 80




$RestoreSelect.Controls.Add($listBox)

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
	If(test-path $WildcardPath) #Checks if any *.backup files exist in the location specified in Config.xml
	{
		$ListOfBackups = Get-ChildItem -Path $WildcardPath
		for ($i = 0; $i -lt $ListOfBackups.Count ; $i++) {
			[void] $listBox.Items.Add($ListOfBackups[$i])
		}
		$RestoreSelect.ShowDialog()
		$RestoreChoice = $listBox.SelectedItem
		$parent = [System.IO.Path]::GetTempPath()
		$name = [System.IO.Path]::GetRandomFileName()
		New-Item -ItemType Directory -Path (Join-Path $parent $name)
		$TempFolder = Join-Path $parent $name 
		$TempPath = Join-Path $TempFolder "restore.zip"
		Copy-Item $RestoreChoice -Destination $TempPath
		Expand-Archive -Force -LiteralPath $TempPath -DestinationPath $RestorePath\RestoredFiles
		
		New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Restore", "Finished restore process!" #Makes a windows notification
	}
	else
	{
		[System.Windows.Forms.MessageBox]::Show("$BackupFilePath does not exist. Use the ""Backup Location"" button to choose the folder containing Backup.zip", "WINDOWS BACKUP") #Notifies user that Backup.zip does not exist. This will happen when Backup location is changed and then a backup isn't run before trying to restore from the location so the program can not find Backup.zip in the directory specified
	}
}
