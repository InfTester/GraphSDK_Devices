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
#
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
