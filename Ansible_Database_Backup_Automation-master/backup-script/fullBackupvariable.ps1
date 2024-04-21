$region = "ap-south-1"
$username = "sa"
$password = "pass!90"
$date = Get-Date -Format yyyy-MM-dd_HH-mm-ss
$hostname = hostname
$localLogPath = "C:\Database\Logs\output_Full_$date.log"
$bucketName = "ansible-project-db-backup"
$DBlist = [DB_name]
$env = 'Production'
$backupDirectory = "C:\Database\Backup\"
$Type = "Full"
$instance = "$hostname\SQLEXPRESS"
$awsPath = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
#$emailScriptPath = "C:\Database\scripts\sendEmail.ps1"
$emailSubject = "Full backup status of server $hostname at " + $date
$emailBodySuccess = "List of Databases backup completed successfully `n"
$emaildbfail = "`nList of Database creation failed"
$emailBodyFail = "`n`nList of Databases upload failed"


