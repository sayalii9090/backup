. C:\Database\scripts\differentialBackupvariable.ps1


# Check for the backup file older than 3 days and delete them
Get-ChildItem $backupDirectory -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-3)} | Remove-Item
New-Item -Path $localLogPath -ItemType File
Add-Content -Path $localLogPath -Value "Backup activity started $date `n"

# Perform full database backup
ForEach ($databaseName in $DBlist)
{
Add-Content -Path $localLogPath -Value "*********************************************************** `n" 
Add-Content -Path $localLogPath -Value "Backup started for DB $databaseName `n" 

$backupFile = $backupDirectory + $databaseName + "_" + $date + ".dif"
$awsfile = $databaseName + "_" + $date + ".dif"

sqlcmd -S $instance -Q "BACKUP DATABASE [$databaseName] TO DISK='$backupFile' WITH DIFFERENTIAL" -U $username -P $password >> $localLogPath

if(Test-Path $backupFile) {

Write-Host "Backup created successfully"
Add-Content -Path $localLogPath -Value "`nSuccessfully backup created for $databaseName"
$errorinbackup = $false

} else 
{

Write-Host "Backup creation failed"

Add-Content -Path $localLogPath -Value "`nFailed to create backup for $databaseName"

$emaildbfail = $emaildbfail + "`n" + $databaseName + "`n"

$errorinbackup = $true

}

# Upload backup file to S3
Add-Content -Path $localLogPath -Value "`n----------------------------------------------------------" 
Add-Content -Path $localLogPath -Value "`n$databaseName backup upload to s3 initiated on $date" 


& $awsPath s3 cp $backupFile s3://$bucketName/$env/$hostname/$databaseName/$Type/$awsfile --region $region

# Verify backup file has been successfully uploaded to S3
if($LastExitCode -eq 0) {
Write-Host "Backup file uploaded successfully"
Add-Content -Path $localLogPath -Value "`nSuccessfully uploaded $databaseName backup to s3"
Add-Content -Path $localLogPath -Value "*********************************************************** `n"
$emailBodySuccess = $emailBodySuccess + " `n " +  $databaseName + "`n"
$errorinbackup = $false
} else {
Write-Host "Error uploading backup file"
Add-Content -Path $localLogPath -Value "`nFailed to uploaded $databaseName backup to s3"
Add-Content -Path $localLogPath -Value "*********************************************************** `n"
$emailBodyFail = $emailBodyFail  + "`n" + $databaseName + "`n"
$errorinbackup = $true
}
}

if ($errorinbackup){
# Sending Email communication
C:\Database\scripts\sendEmail.ps1 $emailSubject $emaildbfail $emailBodyFail
} 


