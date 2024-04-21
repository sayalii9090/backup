# Set variables
$region = "us-east-1"
$bucketName = "allcaretherapies-db-backup"
#$DBlist = @('PTNotes','slpcore','slpnotes','slpschool', 'SQL2008R2_784047_hha','thia')
$DBlist = @('thia')
$Prod = 'Testing'
$backupDirectory = "D:\Test\"
$Type = "Differential"
$awsPath = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
$instance = "XXXXXXXX\SQLEXPRESS"
$date = Get-Date -Format yyyy-MM-dd_HH-mm-ss

# Check for backup files older than 3 days and delete them
Get-ChildItem $backupDirectory -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-3)} | Remove-Item
#Add-Content -Path E:\SQLBackup\Diff\output_Diff_$date.log -Value "Differentials database backup activities started on $date `n" 

$emailSubject = "Test Differentials backup status at " + $date
#$emailBodySuccess = "List of Databases backup completed successfully `n"
$emailBodyFail = "`n `n List of Databases backup upload failed"
$emaildbfail = "`n `n List of Database creation failed `n"

# Perform full database backup
ForEach ($databaseName in $DBlist)
{
    #Add-Content -Path D:\Test\output_Diff_$date.log -Value "*********************************************************** `n" 
   # Add-Content -Path D:\Test\Diff\output_Diff_$date.log -Value "Backup started for DB $databaseName" 

    $backupFile = $backupDirectory + $databaseName + "_" + $date + ".dif"
    $awsfile = $databaseName + "_" + $date + ".dif"

    sqlcmd -S $instance -Q "BACKUP DATABASE [$databaseName] TO DISK='$backupFile' WITH DIFFERENTIAL" -U pas -P Pass@1234 >> "D:\Test\output_Diff_$date.log"

    if($LastExitCode -eq 0) {

        Write-Host "Backup created successfully"

        #Add-Content -Path D:\SQLBackup\Diff\output_Diff_$date.log -Value "Successfully backup created for $databaseName"
        $errorinbackup = $false


    } else {

        Write-Host "Backup creation failed"

        #Add-Content -Path D:\SQLBackup\Diff\output_Diff_$date.log -Value "Failed to create backup for $databaseName"

        $emaildbfail = $emaildbfail + "`n" + $databaseName + "`n"

        $errorinbackup = $true

    }

    # Upload backup file to S3

    #Add-Content -Path E:\SQLBackup\Diff\output_Diff_$date.log -Value "`n $databaseName backup upload to s3 initiated `n"

    & $awsPath s3 cp $backupFile s3://$bucketName/$prod/$databaseName/$Type/$awsfile --region $region

    # Verify backup file has been successfully uploaded to S3
    if($LastExitCode -eq 0) {
        Write-Host "Backup file uploaded successfully"
        #Add-Content -Path E:\SQLBackup\Diff\output_Diff_$date.log -Value "Successfully uploaded $databaseName backup to s3"
       #$emailBodySuccess = $emailBodySuccess + " `n " +  $databaseName + "`n"
       $errorinbackup = $false

    } else {
        Write-Host "Error uploading backup file"
       # Add-Content -Path E:\SQLBackup\Diff\output_Diff_$date.log -Value "Successfully uploaded $databaseName backup to s3"
       $emailBodyFail = $emailBodyFail  + "`n" + $databaseName + "`n"
	   $errorinbackup = $true
    }
   # Add-Content -Path E:\SQLBackup\Diff\output_Diff_$date.log -Value "*********************************************************** `n" 
}

if ($errorinbackup){
  ### SEnding Email communication
  D:\Test\kk\sendEmail.ps1 $emailSubject $emailBodyFail $emaildbfail
}
   # Add-Content -Path E:\SQLBackup\Diff\output_Diff_$date.log -Value "Differentials database backup activities completed" 