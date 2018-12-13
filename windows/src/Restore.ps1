# Author Joshua Button - U1628860 - www.JoshuaButton.co.uk
# Co-Author Bartosz Stasik

####################
#Load Prerequisites#
#################### 
$BackupLocation		= $ConfigFile.Backup.BackupLocation #Pulls users backup location choice from XML file

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

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

###############
#Progam Begins#
###############
$RestorePath = Get-Folder
Expand-Archive -LiteralPath $BackupLocation\Backup.zip -DestinationPath $RestorePath\RestoredFiles #Takes the file
New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Restore", "Finished restore process!" #Makes a windows notification
