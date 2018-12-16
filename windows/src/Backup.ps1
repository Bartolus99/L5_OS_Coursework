# Author Joshua Button - U1628860 - www.JoshuaButton.co.uk
# Co-Author Bartosz Stasik - U1730148

############
#REFERENCES#
############

#https://redmondmag.com/articles/2016/01/15/for-each-loop-in-powershell.aspx - FOR EACH LOOP

####################
#Load Prerequisites#
#################### 

#Retrieve users backup choices from Config.xml
$DocumentsBackup		     = [System.Convert]::ToBoolean($ConfigFile.Backup.Documents.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$MusicBackup				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Music.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$CustomBackup1			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder1.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$CustomBackup2			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder2.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$DesktopBackup 				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Desktop.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$VideosBackup				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Videos.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$PicturesBackup 			 = [System.Convert]::ToBoolean($ConfigFile.Backup.Pictures.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

#Retrieve folder paths
$BackupLocation				 = $ConfigFile.Backup.BackupLocation #Pulls users backup location choice from XML file
$CustomPath1                 = $ConfigFile.Backup.CustomFolder1.path #Pulls custom folder string from XML file
$CustomPath2                 = $ConfigFile.Backup.CustomFolder2.path #Pulls custom folder string from XML file
$DocumentsPath 				 = [environment]::getfolderpath("mydocuments") #Gets my documents path from envvariable
$MusicPath 					 = [environment]::getfolderpath("mymusic") #Gets my music path from envvariable
$DesktopPath 				 = [environment]::getfolderpath("desktop") #Gets desktop path from envvariable
$VideosPath 				 = [environment]::getfolderpath("myvideos") #Gets my videos path from envvariable
$PicturesPath 				 = [environment]::getfolderpath("mypictures") #Gets my pictures path from envvariable

#Create array for looping through folders to backup. Odd items are the users choice to backup the folder or not, even items are the folder paths.
$toBackUpList 				 = @($DocumentsBackup, $DocumentsPath, 
								$MusicBackup, $MusicPath,
								$PicturesBackup, $PicturesPath,
								$VideosBackup, $VideosPath,
								$DesktopBackup, $DesktopPath,
								$CustomBackup1, $CustomPath1,
								$CustomBackup2, $CustomPath2
								) 

################
#Program Begins#
################
$backupTrue = $false #Sets our Backup Identifier "Flag" to false
foreach ($item in $toBackUpList) #Loops through array and during each loop holds the current item as $item so the same operation is done to each item
{
	if ($item -eq $true) #Waiting for a user choice equal to true: A user
	{
		$backupTrue = $true #When a user choice true comes through we set $backupTrue to true so we know the next path needs to be backed up
	}
	if ($item -ne $true -and $item -ne $false) #Checks if $item is a path. If it is a boolean it will skip over this
	{
		if ($backupTrue -eq $true) #Checks if a user choice has been true
		{
			Compress-Archive -Path $item -Update -DestinationPath $BackupLocation\Backup.zip #BacksUp the path passed from the array into a zip file
			$backupTrue = $false #Sets the flag back to false ready for the next user choice check
			New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Backup", "$item finished backing up!" #Makes a windows notification
		}
	}
}
