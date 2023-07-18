<#
    .SYNOPSIS 
    Azure Backend-System Test
    
    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\Test-MicrosoftEndpointNetworks.ps1
    
    .ENVIRONMENT
    PowerShell 5.0
    
    .AUTHOR
    Niklas Rast
    Inspired by https://github.com/mmelkersen/EndpointManager/blob/main/MEM%20URL%20Test/Test-MicrosoftEndpointNetworks.ps1
#>


function Test-MicrosoftEndpointNetworks {
    [CmdletBinding()]
    param (
    [parameter(Mandatory=$true)]
    $ComputerNames,$Ports,$TestArea,
    [parameter(Mandatory=$false)]
    $Urls)

    #================================================
    #   Initialize
    #================================================
    $console = $host.ui.rawui
    $console.BackgroundColor = "Black"
    $console.ForegroundColor = "White"
    $console.WindowTitle = 'Test-MicrosoftEndpointNetworks'
    $console.BufferSize = New-Object System.Management.Automation.Host.size(2000,2000)
    #=======================================================================
    $Global:ProgressPreference = 'SilentlyContinue'

    Write-Host -ForegroundColor DarkGray '========================================================================='
    Write-Host -ForegroundColor Cyan "$TestArea"
    
    foreach ($ComputerName in $ComputerNames){
        foreach ($Port in $Ports){
            try {
                if (Test-NetConnection -ComputerName $ComputerName -Port $Port -InformationLevel Quiet -ErrorAction Stop -WarningAction 'Continue') {
                    Write-Host -ForegroundColor DarkCyan "PASS: $ComputerName [Port: $Port]"
                }
                else {
                    Write-Host ""
                    Write-Host "Script version: 1.0"
                    Write-Host -ForegroundColor Red "Overall verdict: FAIL $Uri"
                    Write-Host -ForegroundColor DarkGray '========================================================================='
                    Write-Host "Press any key to continue..."
                    #$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    #Exit 1
                }
            }
            catch {}
            finally {}
        }
    }

    foreach ($Uri in $Urls){
        try {
            if ($null = Invoke-WebRequest -Uri $Uri -Method Head -UseBasicParsing -ErrorAction Stop) {
                Write-Host -ForegroundColor DarkCyan "PASS: $Uri"
            }
            else {
            }
        }
        catch {
            Write-Host "Script version: 1.0"
            Write-Host -ForegroundColor Red "Overall verdict: FAIL $Uri"
            Write-Host -ForegroundColor DarkGray '========================================================================='
            Write-Host "Press any key to continue..."
            #$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            #Exit 1
        }
    }
    #=======================================================================
    #   Complete
    #=======================================================================
    Write-Host -ForegroundColor DarkGray '========================================================================='
    $Global:ProgressPreference = 'Continue'
}

Start-Transcript -Path C:\MSEndpointtest.txt -Append

    #=======================================================================
    #   PowerShell Gallery
    #=======================================================================
    Test-MicrosoftEndpointNetworks -ComputerNames "powershellgallery.com" -Ports "443" -TestArea "PowerShell Gallery"

    #=======================================================================
    #   Windows Update
    #   https://docs.microsoft.com/en-US/windows/deployment/update/windows-update-troubleshooting
    #=======================================================================
    Test-MicrosoftEndpointNetworks -ComputerNames "emdl.ws.microsoft.com","dl.delivery.mp.microsoft.com" -Ports "80" -TestArea "Windows Update"

    #=======================================================================
    #   Windows Autopilot Deployment Service
    #=======================================================================
    #Test-MicrosoftEndpointNetworks -ComputerNames "cs.dds.microsoft.com","login.live.com","ztd.dds.microsoft.com" -Ports "443" -TestArea "Windows Autopilot Deployment Service"

    #=======================================================================
    #   Autopilot self-Deploying mode and Autopilot pre-provisioning
    #=======================================================================
    #Test-MicrosoftEndpointNetworks -ComputerNames "ekop.intel.com","ekcert.spserv.microsoft.com","ftpm.amd.com" -Ports "443" -TestArea "Autopilot self-Deploying mode and Autopilot pre-provisioning"

    #=======================================================================
    #   Intune
    #   https://docs.microsoft.com/en-us/mem/intune/fundamentals/network-bandwidth-use
    #   https://docs.microsoft.com/en-us/mem/intune/fundamentals/intune-endpoints#network-requirements-for-powershell-scripts-and-win32-apps
    #=======================================================================
    Test-MicrosoftEndpointNetworks -ComputerNames "naprodimedatapri.azureedge.net","naprodimedatasec.azureedge.net","naprodimedatahotfix.azureedge.net","euprodimedatapri.azureedge.net","euprodimedatasec.azureedge.net","euprodimedatahotfix.azureedge.net","approdimedatapri.azureedge.net","approdimedatasec.azureedge.net","approdimedatahotfix.azureedge.net" -Ports "443" -TestArea "Intune Network requirements for PowerShell scripts and Win32 apps"

    #=======================================================================
    #   Intune
    #   https://docs.microsoft.com/en-us/mem/intune/fundamentals/network-bandwidth-use
    #   https://docs.microsoft.com/en-us/mem/intune/fundamentals/intune-endpoints#access-for-managed-devices
    #=======================================================================
    Test-MicrosoftEndpointNetworks -ComputerNames "login.microsoftonline.com","config.office.com","graph.windows.net","enterpriseregistration.windows.net","portal.manage.microsoft.com","m.manage.microsoft.com","fef.msuc03.manage.microsoft.com","wip.mam.manage.microsoft.com","mam.manage.microsoft.com" -Ports "443" -TestArea "Intune Access for managed devices"
    
  
    #=======================================================================
    #   Azure Active Directory | Office 365 IP Address and URL web service
    #   https://docs.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-ip-web-service?view=o365-worldwide
    #=======================================================================
    Test-MicrosoftEndpointNetworks -ComputerNames "teams.microsoft.com","smtp.office365.com","security.microsoft.com","provisioningapi.microsoftonline.com","protection.office.com","passwordreset.microsoftonline.com","outlook.office365.com","outlook.office.com","office.live.com","nexus.microsoftonline-p.com","login-us.microsoftonline.com","loginex.microsoftonline.com","logincert.microsoftonline.com","login.windows.net","login.microsoftonline-p.com","login.microsoftonline.com","login.microsoft.com","graph.windows.net","graph.microsoft.com","device.login.microsoftonline.com","compliance.microsoft.com","companymanager.microsoftonline.com","clientconfig.microsoftonline-p.net","broadcast.skype.com","becws.microsoftonline.com","autologon.microsoftazuread-sso.com","api.passwordreset.microsoftonline.com","adminwebservice.microsoftonline.com","accounts.accesscontrol.windows.net","account.office.net","account.activedirectory.windowsazure.com","teams.microsoft.com","skypeforbusiness.com","sharepoint.com","security.microsoft.com","protection.outlook.com","protection.office.com","portal.cloudappsecurity.com","outlook.office.com","online.office.com","officeapps.live.com","msidentity.com","msftidentity.com","mail.protection.outlook.com","lync.com","compliance.microsoft.com","broadcast.skype.com" -Ports "443" -TestArea "Office 365 IP Address and URL Web Service"


    #=======================================================================
    #   Windows Activation
    #   https://support.microsoft.com/en-us/topic/windows-activation-or-validation-fails-with-error-code-0x8004fe33-a9afe65e-230b-c1ed-3414-39acd7fddf52
    #=======================================================================
    Test-MicrosoftEndpointNetworks -ComputerNames "validation-v2.sls.microsoft.com","validation.sls.microsoft.com","purchase.mp.microsoft.com","purchase.md.mp.microsoft.com","login.live.com","licensing.md.mp.microsoft.com","licensing.mp.microsoft.com","go.microsoft.com","displaycatalog.md.mp.microsoft.com","displaycatalog.mp.microsoft.com","activation-v2.sls.microsoft.com","activation.sls.microsoft.com" -Ports "443" -TestArea "Windows Activation" -Urls "http://crl.microsoft.com/pki/crl/products/MicProSecSerCA_2007-12-04.crl"

    #=======================================================================
    #   Exit Script
    #=======================================================================
    if (!($host.name -match "ISE")) {
        Write-Host -ForegroundColor DarkGray '========================================================================='
        Write-Host ""
        Write-Host "Script Finalized"
        Write-Host "Script version: 1.0"
    }
    else {
        Exit 0
    }
Stop-Transcript