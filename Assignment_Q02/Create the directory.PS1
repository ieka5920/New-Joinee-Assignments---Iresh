param (
    [int]$DaysToKeep = 30,
    [string]$LogDir = "C:\Users\Iresh Ekanayaka\Pictures\Logs",
    [string]$S3BucketName = "assignmentsq2",
    [string]$AWSRegion = "us-east-1"
)

# Create log directory if it doesn't exist
if (-Not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir
}

# Add sample log files (for testing purposes)
for ($i = 1; $i -le 5; $i++) {
    $sampleFile = "$LogDir\logfile_$i.log"
    if (-Not (Test-Path $sampleFile)) {
        New-Item -ItemType File -Path $sampleFile -Value "Sample log file content $i"
    }
}

