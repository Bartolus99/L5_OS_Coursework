# Author - Joshua Button - U1628860

############
#REFERENCES#
############
#https://redmondmag.com/articles/2016/01/15/for-each-loop-in-powershell.aspx - FOR EACH LOOP

#Retrieve users Restore choices fron Config.xml
$DocumentsRestore		     = [System.Convert]::ToBoolean($ConfigFile.Backup.Documents.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$MusicRestore				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Music.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$CustomRestore1			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder1.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$CustomRestore2			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder2.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$DesktopRestore 				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Desktop.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$VideosRestore				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Videos.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$PicturesRestore 			 = [System.Convert]::ToBoolean($ConfigFile.Backup.Pictures.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

#Retrieve folder paths
$CustomPath1                 = $ConfigFile.Backup.CustomFolder1.path #Pulls custom folder string from XML file
$CustomPath2                 = $ConfigFile.Backup.CustomFolder2.path #Pulls custom folder string from XML file
$DocumentsPath 				 = [environment]::getfolderpath("mydocuments")
$MusicPath 					 = [environment]::getfolderpath("mymusic")
$DesktopPath 				 = [environment]::getfolderpath("desktop")
$VideosPath 				 = [environment]::getfolderpath("myvideos")
$PicturesPath 				 = [environment]::getfolderpath("mypictures")

#Create array for looping through folders to Restore. Odd items are the users choice to Restore the folder or not, even items are the folder paths.
$toRestoreList 				 = @($DocumentsRestore, $DocumentsPath, 
								$MusicRestore, $MusicPath,
								$PicturesRestore, $PicturesPath,
								$VideosRestore, $VideosPath,
								$DesktopRestore, $DesktopPath,
								$CustomRestore1, $CustomPath1,
								$CustomRestore2, $CustomPath2
								) 

$RestoreTrue = $false #Sets our Restore Identifier to false
foreach ($item in $toRestoreList) #Loops through our array and each loop holds the current item as $item so the same operation is done to each item
{
	if ($item -eq $true) #Waiting for user choices equal to true to pass through. 
	{
		$RestoreTrue = $true #When a userchoice true comes throguh we set $RestoreTrue to true so we know the next path needs to be backed up
	}
	if ($item -ne $true -and $item -ne $false) #Checks if $item is a path. If it is a boolean it will skip over this
	{
		if ($RestoreTrue -eq $true) #Checks if a userchoice has been true
		{
			clear
			Uncompress-Archive -Path $item -Update -DestinationPath $item"\Restore.zip" #BacksUp the path passed from the array into a zip file
			$RestoreTrue = $false #Sets the flag back to false ready for the next userchoice check
			New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Restore", "$item finished backing up!" #Makes a windows notification
		}
	}
}