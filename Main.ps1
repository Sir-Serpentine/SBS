# Set Paths
$sourcePath = "$env:USERPROFILE\Pictures\Screenshots"
$backupPath = "$env:USERPROFILE\Backups\Screenshots"

# Does the destination directory exist?
if (-Not (Test-Path -Path $backupPath)) {
    # Create the destination directory if it does not exist
    New-Item -ItemType Directory -Path $backupPath | Out-Null
}

# Create file with current date and time
$date = Get-Date -Format "MM.dd.yy"
$zipName = "Screenshots_$date.zip"
# Full path for the zip file
$zipPath = Join-Path -Path $backupPath -ChildPath $zipName

# Cancel if the zip file already exists
if (Test-Path -Path $zipPath) {
    exit
}

# Create da backup
Compress-Archive -Path $sourcePath -DestinationPath $zipPath -Force

# Send a windows notification on completion 
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)
$node = $template.GetElementsByTagName("text")[0]
$node.AppendChild($template.CreateTextNode("Backup Complete: $zipName")) | Out-Null
$toast = [Windows.UI.Notifications.ToastNotification]::new($template)
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Screenshots")
$notifier.Show($toast)
