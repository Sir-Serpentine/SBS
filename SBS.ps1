 # Set Paths
$sourcePath = "$env:USERPROFILE\Pictures\Screenshots"
$backupPath = "$env:USERPROFILE\Backups\Screenshots"

# Create backup DIR if it doesn't exist
if (-not (Test-Path -Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
}

# Grab current date for naming
$date = Get-Date -Format "MM.dd.yy"
$zipName = "Screenshots_$date.zip"
# Full path to save
$zipPath = Join-Path -Path $backupPath -ChildPath $zipName

# Cancel if backup already exists
if (Test-Path -Path $zipPath) {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)
    $node = $template.GetElementsByTagName("text")[0]
    $node.AppendChild($template.CreateTextNode("Backup failed, $zipName already exists.")) | Out-Null
    $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Screenshots")
    $notifier.Show($toast)

    exit
}

# Create backup
Compress-Archive -Path $sourcePath -DestinationPath $zipPath -Force

# Toats notif on completion 
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)
$node = $template.GetElementsByTagName("text")[0]
$node.AppendChild($template.CreateTextNode("Backup Complete: $zipName, at $backupPath")) | Out-Null
$toast = [Windows.UI.Notifications.ToastNotification]::new($template)
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Screenshots")
$notifier.Show($toast)
