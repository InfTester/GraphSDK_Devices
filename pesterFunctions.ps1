function user-Details {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
clear-host
Write-Host "======================REQUIRED TEST EXECUTION DETAILS================================"
Write-Host "`nHello $env:USERNAME - Please provide the following details, so they can be added to the report"
  do {
    Read-Host "`nPlesae enter your First Name or initial" -OutVariable firstName
  }
  while ($firstName Length -lt 1) 

  do {
      Read-Host "`nPlesae enter your Last Name (minimum of 2 characters)" -OutVariable lastName
  }
  while ($firstName Length -lt 2)

  do (
      Read-Host "`nPlesae enter your Team Name (minimum of 2 characters)" -OutVariable teamName
  }
  while ($teamName Length -lt 2)
Write-Host "`nSubmitting Data ...."
Start-Sleep -seconds 1
Write-Host $firstName
Start-Sleep -seconds 1
Write-Host $lastName
Start-Sleep -seconds 1
Write-Host $teamName
Start-Sleep -seconds 1
Write-Host "`nValidating ........."
Start-Sleep -seconds
Write-Host $firstname';' $lastName';' $teamName
Start-Sleep -seconds 3
Write-Host "`nInput Accepted, validation complete"
Start-Sleep -seconds 2
Write-Host "`n$firstName $lastName of the $teamName Team will be added to the finalised report"
Pause
}

function User-Agreement {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
clear-host
Write-Host "===============THIS AUTOMATION SCRIPT HAS BEEN PROVIDED BY TONY LAW, USE AT YOUR OWN RISK==================="
Write-Host "`nHello $env:USERNAME, you are about to execute a script on the local server/desktop"
Start-Sleep -seconds 3
Write-Host "`nBy continuing, you agree that you have the appropriate permissions and have authorisation to execute this script"
Start-Sleep -Milliseconds 2500
Write-Host "`If you are in doubt, Press Ctrl+C to abort`n" -BackgroundColor Green -ForegroundColor Cyan
Start-Sleep -Seconds 2.5
Pause
}

}

function mgAccess-MgSDK {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
        Write-Host "`n`n$env:USERNAME, You are now connecting to the Azure Tenant using Microsoft`n" 
        Start-Sleep -Seconds 1
        Connect-MgGraph
        $tenantID = (Get-MgOrganization).DisplayName
        Write-Host "You are now connected to $tenantID tenant"
        $mgProf = Get-MgProfile
        if (-not($mgProf.Name -eq "beta"))
        {
        Select-MgProfile -Name Beta
        Write-Host "`nInstalling Microsoft Graph Profile 'Beta', this may take a while"
        }
        Start-Sleep -Seconds 1
}


function mgWindows-UserDevice {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
$devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "Windows"}
Write-Host "`nCollecting users...."
$userDispName = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "Windows"} | Select-Object UserDisplayName -Unique 
$userDispName | ft

do {
    $user = Read-Host -Prompt "Copy and paste the 'UserDisplayName' from above and then press enter to continue"
} While ($user -notin ($devDetails).UserDisplayName) 

Start-Sleep -Seconds 1
Write-Host "`nCollecting device details...."
Start-Sleep -Seconds 1
$devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OperatingSystem, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
} While ($deviceID -notin ($devDetails).SerialNumber)
$windowsOSDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}
}

function mgAndroid-UserDevice {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
        
        $devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "android"}
        Write-Host "`nCollecting Users...."
        $userDispName = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "android"} | Select-Object UserDisplayName -Unique 
        $userDispName | ft

        do {
        $user = Read-Host -Prompt "Copy and paste the 'UserDisplayName' from above and then press enter to continue"
        } While ($user -notin ($devdetails).UserDisplayName) 

        Start-Sleep -Seconds 1
        Write-Host "`nCollecting device details...."
        Start-Sleep -Seconds 1
        $devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OsVersion | ft
        Start-Sleep -Seconds 1

        do {
        $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
        } While ($deviceID -notin ($devDetails).SerialNumber)
        $androidDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}
}


function mgIoS-UserDevice {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
$devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios"}
Write-Host "`nCollecting users...."
$userDispName = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios"} | Select-Object UserDisplayName -Unique 
$userDispName | ft

do {
    $user = Read-Host -Prompt "Copy and paste the 'UserDisplayName' from above and then press enter to continue"
} While ($user -notin ($devdetails).UserDisplayName) 

Start-Sleep -Seconds 1
Write-Host "`nCollecting device details...."
Start-Sleep -Seconds 1
$devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
} While ($deviceID -notin ($devDetails).SerialNumber)
$androidDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}
}

function mgMacOS-UserDevice {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
$devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "macOS"}
Write-Host "`nCollecting users...."
$userDispName = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "macOS"} | Select-Object UserDisplayName -Unique 
$userDispName | ft

do {
    $user = Read-Host -Prompt "Copy and paste the 'UserDisplayName' from above and then press enter to continue"
} While ($user -notin ($devdetails).UserDisplayName) 

Start-Sleep -Seconds 1
Write-Host "`nCollecting device details...."
Start-Sleep -Seconds 1
$devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
} While ($deviceID -notin ($devDetails).SerialNumber)
$androidDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}
}

function mgLinux-UserDevice {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
#>
$devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "linux"}
Write-Host "`nCollecting users...."
$userDispName = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "linux"} | Select-Object UserDisplayName -Unique 
$userDispName | ft

do {
    $user = Read-Host -Prompt "Copy and paste the 'UserDisplayName' from above and then press enter to continue"
} While ($user -notin ($devdetails).UserDisplayName) 

Start-Sleep -Seconds 1
Write-Host "`nCollecting device details...."
Start-Sleep -Seconds 1
$devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
} While ($deviceID -notin ($devDetails).SerialNumber)
$androidDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}
}
