$Title = "Microsoft Intune"
$Message = "Your device $ENV:COMPUTERNAME is managed by Microsoft Intune"
$Type = "Info"

Add-Type -AssemblyName System.Windows.Forms
$global:balmsg = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::$Type
$balmsg.BalloonTipText = $Message
$balmsg.BalloonTipTitle = $Title
$balmsg.Visible = $true
$balmsg.ShowBalloonTip(20000) 