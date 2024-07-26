param (
    [string]$TaskName = "LogCleanupTask",
    [string]$ScriptPath = "C:\Users\Iresh Ekanayaka\Pictures\logCleanup.PS1",
    [string]$Schedule = "Daily",
    [string]$StartTime = "03:00AM"
)

# Define the action to run the PowerShell script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""

# Define the trigger for the scheduled task
$trigger = New-ScheduledTaskTrigger -At $StartTime -Daily

# Define the principal (current user)
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal
