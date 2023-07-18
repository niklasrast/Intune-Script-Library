$TeamsURL = "https://rastcloud.webhook.office.com/webhookb2/c403d423-f063-4691-824a-3909d4d8c836@001e7d98-ae46-4cb0-9102-14b239c9d206/IncomingWebhook/0747539b63ef4963bf5797416b1a0641/cb549d03-c044-42e5-b15e-70d0bfd26ccb"
$JSONBody = [PSCustomObject][Ordered]@{
    "@type"      = "MessageCard"
    "@context"   = "http://schema.org/extensions"
    "summary"    = "PowerShell Notification Service"
    "themeColor" = '1683E0'
    "title"      = "Message from $ENV:COMPUTERNAME"
    "text"       = "Hello, this is an automated message."
}

$TeamMessageBody = ConvertTo-Json $JSONBody -Depth 100
Invoke-RestMethod -Uri $TeamsURL -Method Post -Body $TeamMessageBody -ContentType 'application/json' | Out-Null
