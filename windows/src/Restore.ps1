# Author Joshua Button - U1628860 - www.JoshuaButton.co.uk
# Co-Author Bartosz Stasik - U1730148

####################
#Load Prerequisites#
#################### 
$BackupLocation		= $ConfigFile.Backup.BackupLocation #Pulls users backup location choice from XML file
$BackupFilePath		= Join-Path $ConfigFile.Backup.BackupLocation '\Backup.zip'

###########
#Functions#
###########
#https://stackoverflow.com/questions/25690038/how-do-i-properly-use-the-folderbrowserdialog-in-powershell
Function Get-Folder($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select where to restore your files to:"
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "Ok")
    {
        $folder += $foldername.SelectedPath
    }
	else
	{
		$folder = "CANCEL"
	}
    return $folder
}

###############
#Progam Begins#
###############
$RestorePath = Get-Folder #
if($RestorePath -eq "CANCEL")
{
		[System.Windows.Forms.MessageBox]::Show("You didn't choose a folder", "WINDOWS BACKUP")
}
else
{
	If(test-path $BackupFilePath) #Checks if Backup.zip exhists in the location specified in Config.xml
	{
		Expand-Archive -Force -LiteralPath $BackupFilePath -DestinationPath $RestorePath\RestoredFiles #Unzips backup.zip to users choosen location from Folder Dialgo
		New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Restore", "Finished restore process!" #Makes a windows notification
	}
	else
	{
		[System.Windows.Forms.MessageBox]::Show("$BackupFilePath does not exhist. Use the ""Backup Location"" button to choose the folder containing Backup.zip", "WINDOWS BACKUP")
	}
}