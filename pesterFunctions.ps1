Function Out-PieChart {
    <#
.EXAMPLES
#    3D pie chart
Get-Process | select -First 5 name, pm | Out-PieChart -PieChartTitle "Top 5 Windows processes running" -DisplayToScreen -Pie3D

#    standard pie chart
Get-Process | select -First 5 name, pm | Out-PieChart -PieChartTitle "Top 5 Windows processes running" -DisplayToScreen
Display pie chart to screen
#use switch -DisplayToScreen

Get-Process | select -First 5 name, pm | Out-PieChart -PieChartTitle "Top 5 Windows processes running" -DisplayToScreen

     #Save pie chart
Get-Process | select -First 5 name, pm | Out-PieChart -PieChartTitle "Top 5 Windows processes running" -saveImage 'E:\OneDrive\Scripting\PesterScripts\Win_Process.png'
#>

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [psobject] $inputObject,
        [Parameter()]
        [string] $PieChartTitle,
        [Parameter()]
        [int] $ChartWidth = 1000,
        [Parameter()]
        [int] $ChartHeight = 475,
        [Parameter()]
        [string[]] $NameProperty,
        [Parameter()]
        [string] $ValueProperty,
        [Parameter()]
        [switch] $Pie3D,
        [Parameter()]
        [switch] $DisplayToScreen,
        [Parameter()]
        [string] $saveImage
    )
    begin {
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization
        # Frame
        $Chart = [System.Windows.Forms.DataVisualization.Charting.Chart]@{
            Width       = $ChartWidth
            Height      = $ChartHeight
            BackColor   = 'White'
            BorderColor = 'Black'
        }
        # Body
        $null = $Chart.Titles.Add($PieChartTitle)
        $Chart.Titles[0].Font = "segoeuilight,20pt"
        $Chart.Titles[0].Alignment = "TopCenter"
        # Create Chart Area
        $ChartArea = [System.Windows.Forms.DataVisualization.Charting.ChartArea]::new()
        $ChartArea.Area3DStyle.Enable3D = $Pie3D.ToBool()
        $ChartArea.Area3DStyle.Inclination = 50
        $Chart.ChartAreas.Add($ChartArea)
        # Define Chart Area
        $null = $Chart.Series.Add("Data")
        $Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
        # Chart style
        $Chart.Series["Data"]["PieLabelStyle"] = "Outside"
        $Chart.Series["Data"]["PieLineColor"] = "Black"
        $Chart.Series["Data"]["PieDrawingStyle"] = "Concave"
        $chart.Series["Data"].IsValueShownAsLabel = $true
        $chart.series["Data"].Label = "#PERCENT\n#VALX"
        # Set ArrayList
        $XColumn = [System.Collections.ArrayList]::new()
        $yColumn = [System.Collections.ArrayList]::new()
    }
    process {
        if (-not $valueProperty) {
            $numericProperties = foreach ($property in $inputObject.PSObject.Properties) {
                if ([Double]::TryParse($property.Value, [Ref]$null)) {
                    $property.Name
                }
            }
            if (@($numericProperties).Count -eq 1) {
                $valueProperty = $numericProperties
            }
            else {
                throw 'Unable to automatically determine properties to graph'
            }
        }
        if (-not $LabelProperty) {
            if ($inputObject.PSObject.Properties.Count -eq 2) {
                $LabelProperty = $inputObject.Properties.Name -ne $valueProperty
            }
            elseif ($inputObject.PSObject.Properties.Item('Name')) {
                $LabelProperty = 'Name'
            }
            else {
                throw 'Cannot convert Data'
            }
        }
        # Bind chart columns
        $null = $yColumn.Add($InputObject.$valueProperty)
        $null = $xColumn.Add($inputObject.$LabelProperty)
    }
    end {
        # Add data to chart
        $Chart.Series["Data"].Points.DataBindXY($xColumn, $yColumn)
        # Save file
        if ($psboundparameters.ContainsKey('saveImage')) {
            try{
                if (Test-Path (Split-Path $saveImage -Parent)) {
                    $SaveImage = $pscmdlet.GetUnresolvedProviderPathFromPSPath($saveImage)
                    $Chart.SaveImage($saveImage, "png")
                } else {
                    throw 'Invalid path, the parent directory must exist'
                }
            } catch {
                throw
            }
        }
        # Display Chart to screen
        if ($DisplayToScreen.ToBool()) {
            $Form = [Windows.Forms.Form]@{
                Width           = 800
                Height          = 450
                AutoSize        = $true
                FormBorderStyle = "FixedDialog"
                MaximizeBox     = $false
                MinimizeBox     = $false
                KeyPreview      = $true
            }
            $Form.controls.add($Chart)
            $Chart.Anchor = 'Bottom, Right, Top, Left'
            $Form.Add_KeyDown({
                if ($_.KeyCode -eq "Escape") { $Form.Close() }
            })
            $Form.Add_Shown( {$Form.Activate()})
            $Form.ShowDialog() | Out-Null
        }
    }
}

#CSS codes
$header = @"
<style>
    h1 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 36px;
    }
    
    h2 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 24px;
    }
      
   table {
		font-size: 16px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 
	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}

    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
  
    #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;
    }

    .StopStatus {
        color: #ff0000;
    }
  
    .RunningStatus {
        color: #008000;
    }

</style>
"@

function Get-userDetails {

clear-host
Write-Host "======================REQUIRED TEST EXECUTION DETAILS================================"
Write-Host "`nHello $env:USERNAME - Please provide the following details, so they can be added to the report"
  do {
    Read-Host "`nPlease enter your First Name or initial" -OutVariable firstName
  }
  while ($firstName.Length -lt 1) 

  do {
    Read-Host "`nPlease enter your Last Name '(minimum of 2 characters)'" -OutVariable lastName
  }
  while ($lastName.Length -lt 2)

  do {
    Read-Host "`nPlease enter your Team Name '(minimum of 2 characters)'" -OutVariable teamName
  }
  while ($teamName.Length -lt 2)
 
Write-Host "`nSubmitting Data ...."
Start-Sleep -seconds 1
Write-Host $firstName
Start-Sleep -seconds 1
Write-Host $lastName
Start-Sleep -seconds 1
Write-Host $teamName
Start-Sleep -seconds 1
Write-Host "`nValidating ........."
Start-Sleep -seconds 3
Write-Host $firstname';' $lastName';' $teamName
Start-Sleep -seconds 3
Write-Host "`nInput Accepted, validation complete"
Start-Sleep -seconds 2
Write-Host "`n$firstName $lastName of the $teamName Team will be added to the finalised report"
Pause
}

function Out-userAgreement {
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


function start-MgSDK {
<#
Creator - Tony Law
Date - 06/06/2024
Version 0.1
Assumptions: MSGraphAPI module is installed on the device this is being run from. If not, this function will fail.
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

function add-HtmlImage {
    Param(
      [Switch]
      [bool]$IncludeImages
    )
  
    if ($IncludeImages) {
      $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
      $images = Get-ChildItem "$PSScriptRoot\*.png"
      $ImageHTML = $images | % {
        $ImageBits = [Convert]::ToBase64String((Get-Content $_ -Encoding Byte))
        "<img src=data:image/png;base64,$($ImageBits) alt='My Image'/>"
      }
  
      ConvertTo-Html -Body $style -PreContent $imageHTML |
        Out-File "$PSScriptRoot\report.html"
    }
  }

  function add-HtmlImages {
    Param(
      [Parameter()]
      [string[]]$IncludeImages
    )
  
    if ($IncludeImages) {
      $ImageHTML = $IncludeImages | % {
        $ImageBits = [Convert]::ToBase64String((Get-Content $_ -Encoding Byte))
        "<img src=data:image/png;base64,$($ImageBits) alt='My Image'/>"
      }
  
      ConvertTo-Html -Body $style -PreContent $imageHTML |
        Out-File "C:\path\to\report.html"
    }
  }
