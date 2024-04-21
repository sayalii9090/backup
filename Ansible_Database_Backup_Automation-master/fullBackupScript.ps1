$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument 'C:\Database\scripts\fullBackup.ps1'
$trigger = New-ScheduledTaskTrigger -Daily -At 00:05 
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName 'Daily_backup' -Description "Task to create backup every 5 minutes" -User 'SYSTEM' -Force 
