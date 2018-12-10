# Author - Joshua Button - U1628860

$BackupLocation		= $ConfigFile.Backup.BackupLocation #Pulls users backup location chice from XML file


Expand-Archive -LiteralPath $BackupLocation\Backup.zip -DestinationPath $RestorePath #Takes the file
New-BurntToastNotification -AppLogo $logoPath -Text "Josh and Bart's Windows Restore", "Finished restore process!" #Makes a windows notification
