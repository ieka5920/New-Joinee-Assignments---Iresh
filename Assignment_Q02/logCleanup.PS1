param (
    [int]$DaysToKeep = 3,
    [string]$LogDir = "C:\Users\Iresh Ekanayaka\Pictures\Logs",
    [string]$S3BucketName = "assignmentsq2",
    [string]$AWSRegion = "us-east-1"
)


# Get the current date and time
$currentDate = Get-Date

# Get all log files older than specified days
# File Age = Current Date - Last Write Time , If File Age > DaysToKeep, Then add to the filesToDelete array
$filesToDelete = Get-ChildItem $LogDir -File | Where-Object { $_.LastWriteTime -lt $currentDate.AddDays(-$DaysToKeep) }

# Initialize variables for logging
$deletedFilesLog = "$LogDir\deletedFiles.log"
$deletedFilesSize = 0
$deletedFilesList = @()

# Delete the old files and log their details, logs - file size in bytes & compleate file path to the file
foreach ($file in $filesToDelete) {
    $deletedFilesSize += $file.Length
    $deletedFilesList += $file.FullName
    Remove-Item $file.FullName -Force
}

# Calculate total disk size and freed space percentage, and rounds 2 decimal places for better readability.
$drive = Get-PSDrive -Name (Get-Item $LogDir).PSDrive.Name
$totalDiskSize = $drive.Used + $drive.Free
$freedStoragePercent = [math]::Round(($deletedFilesSize / $totalDiskSize) * 100, 2)

# Write the log file
$deletedFilesList | Out-File $deletedFilesLog
Add-Content $deletedFilesLog "Total Size of Deleted Files: $($deletedFilesSize) Bytes"
Add-Content $deletedFilesLog "Total Size of Deleted Files: $([math]::Round($deletedFilesSize / 1MB, 2)) MB"
Add-Content $deletedFilesLog "Freed Storage Percentage: $freedStoragePercent%"

# Upload the log file to S3
aws s3 cp $deletedFilesLog "s3://$S3BucketName/" --region $AWSRegion
