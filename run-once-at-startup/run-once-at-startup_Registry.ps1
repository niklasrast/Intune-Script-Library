$PackageName = "run-once"
$Version = "1"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force
try{
    # if running as system, local machine Key, else current user
    if($(whoami -user) -match "S-1-5-18"){$KeyPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"}
    else{$KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"}
    
    # Check if Property exist with correct version
    $PropertyName = "$PackageName - V$Version"
    $Property_existing = Get-ItemProperty $KeyPath -Name $PropertyName -ErrorAction SilentlyContinue
    if($Property_existing){


        ############################################################################################
        #   YOUR CODE TO RUN ONCE

        Write-Host "GUGUS :)"

        #   END CODE TO RUN ONCE
        ############################################################################################


        # Delete Script > currently not, cause could be needed from multiple users
        # Remove-Item -Path $MyInvocation.MyCommand.Source 

    }else{
        # script path
        $script_path = "$Path_4netIntune\Data\$PackageName.ps1"
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force

        # Create Property with script to execute
        Set-ItemProperty $KeyPath -Name $PropertyName -Value "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File `"$script_path`""
    }
}catch{
    Write-Error $_
}

Stop-Transcript