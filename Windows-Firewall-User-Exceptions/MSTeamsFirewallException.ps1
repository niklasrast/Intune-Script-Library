<#
    .SYNOPSIS 
    Windows 10 Software packaging wrapper

    .DESCRIPTION
    Install:   C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\Update-TeamsFWRule.ps1 -Force
    
    .ENVIRONMENT
    PowerShell 5.0
    
    .AUTHOR
    Niklas Rast
    https://msendpointmgr.com/2020/03/29/managing-microsoft-teams-firewall-requirements-with-intune/
#>

#Requires -Version 3
#Requires -Runasadministrator

$ErrorActionPreference = "SilentlyContinue"
$logPath = join-path -path $($env:LOCALAPPDATA) -ChildPath "\Temp\Install-MSOneDriveFirewallException.log"

#Test if registry folder exists
if ($true -ne (test-Path -Path "HKLM:\SOFTWARE\CUSTOMER")) {
    New-Item -Path "HKLM:\SOFTWARE\" -Name "CUSTOMER" -Force
}

#Enable forced rule creation, to cleanup any rules the user might have made, and set the standards imposed by this script (suggested setting $True).
$Force = $True

Function Get-LoggedInUserProfile() {
    try {  
       $loggedInUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object username -ExpandProperty username
       $username = ($loggedInUser -split "\\")[1]

       $userProfile = Get-ChildItem (Join-Path -Path $env:SystemDrive -ChildPath 'Users') | Where-Object Name -Like "$username*" | Select-Object -First 1      
    } catch [Exception] {   
       $Message = "Unable to find logged in users profile folder. User is not logged on to the primary session: $_"
       Throw $Message      
    }
    return $userProfile
}

Function Set-TeamsFWRule($ProfileObj) {
# Setting up the inbound firewall rule required for optimal Microsoft Teams screensharing within a LAN.
    
    Write-Verbose "Identified the current user as: $($ProfileObj.Name)" -Verbose
    $progPath = Join-Path -Path $ProfileObj.FullName -ChildPath "AppData\Local\Microsoft\Teams\Current\Teams.exe"

    if ((Test-Path $progPath) -or ($Force)) {
        if ($Force) {          
            #Force parameter given - attempting to remove any potential pre-existing rules.  
            Write-Verbose "Force switch set: Purging any pre-existing rules." -Verbose  
            Get-NetFirewallApplicationFilter -Program $progPath -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue

            #Register package in registry
            New-Item -Path "HKLM:\SOFTWARE\CUSTOMER\" -Name "Microsoft-TeamsFirewallException"
            New-ItemProperty -Path "HKLM:\SOFTWARE\CUSTOMER\Microsoft-TeamsFirewallException" -Name $ProfileObj.FullName -PropertyType "String" -Value $progPath -Force            
        }
        
        if (-not (Get-NetFirewallApplicationFilter -Program $progPath -ErrorAction SilentlyContinue)) {
            $ruleName = "Teams.exe for user $($ProfileObj.Name)"
            Write-Verbose "Adding Firewall rule: $ruleName" -Verbose
            New-NetFirewallRule -DisplayName "$ruleName" -Direction Inbound -Profile Domain -Program $progPath -Action Allow -Protocol Any
            New-NetFirewallRule -DisplayName "$ruleName" -Direction Inbound -Profile Public,Private -Program $progPath -Action Block -Protocol Any

            #Register package in registry
            New-Item -Path "HKLM:\SOFTWARE\CUSTOMER\" -Name "Microsoft-TeamsFirewallException"
            New-ItemProperty -Path "HKLM:\SOFTWARE\CUSTOMER\Microsoft-TeamsFirewallException" -Name $ProfileObj.FullName -PropertyType "String" -Value $progPath -Force
        } else {
            Write-Verbose "Rule already exists!" -Verbose  
        }
    } else {

       $Message = "Teams not found in $progPath - use the force parameter to override."
       Throw "$Message"
    }   
}

Start-Transcript $logPath -Force

#Add rule to WFAS
Try {   
    Write-Output "Adding inbound Firewall rule for the currently logged in user."
    #Combining the two function in order to set the Teams Firewall rule for the logged in user
    Set-TeamsFWRule -ProfileObj (Get-LoggedInUserProfile)
    #Copy log file to users own temp directory.
    Copy-Item -Path $logPath -Destination (Join-Path -Path (Get-LoggedInUserProfile).FullName -ChildPath "AppData\Local\Temp\") -Force

} catch [Exception] {  
    #Something whent wrong and we should tell the log.
    $Message = "There was an issue during the config: $_"
    Write-Output "$Message"
    exit 1

} Finally {
    Stop-Transcript
}
