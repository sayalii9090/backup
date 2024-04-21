$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument 'C:\Database\scripts\diffBackup.ps1'
$trigger = New-ScheduledTaskTrigger -Once -At 01:00 -RepetitionInterval (New-TimeSpan -Hours 1)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName 'Hourly_backup' -Description "Task to create backup every 5 minutes" -User 'SYSTEM' -Force
