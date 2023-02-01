<#
	.NOTES
========================================================================================================================================================
		Created on: 15.01.2023
      Last Modified: 25.01.2023 
		Created by: Tony Law
        Contributor: John Standen
		Filename: android.testsV1.1.ps1
    Version: 1.1
    Test Level: System Integration
    Device Type Under Test: Android
========================================================================================================================================================
  .SYNOPSIS
		Automated Pester script to validate System Integration settings have been applied correctly to the device under test and that the device is 
    integrated with the intended endpoints.	
  .DESCRIPTION
    This script has been produced to conduct automated integration testing of an Android Smart Device, using the Windows Pester Automation Framework, 
    and the Microsoft Graph API, to collate real-time Azure data.
		This script will use Pester to validate the following areas:
      1. Hardware System Integration Test
        a. System
        b. Operating System
        c. Storage
        d. Battery
        e. System enclosure
        f. Network details
        g. Network service
        h. Conditional Access
      2. Applications System Integration Test
        a. Discovered apps
        b. App Configuration
        c. Managed Apps
      3. Device Compliance System Integration Test
      4. Device configuration System Integration Test
      5. Group Membership System Integration Test
      6. Security System Integration Test

    For each of the above areas, a Pester Scaffold Script will be provided. This works in an hierarchy, with the following attributes.
    1. Describe Block - Provides a high-level description of the area being tested and the test level. i.e., Describe "Hardware System Integration Test"
    2. Context Block - This optional field contains the sub test component and the test condition statement. i.e., Context "Device1 Operating System Settings"
    The individual settings are identified within each It statement, within the Context Blocks. 

  .SCRIPT REQUIREMENTS
    1. Contain a notes section. - Complete
    2. Create Pester Scaffold script.
      a. Describe Block(s) - To include the test level and description.
      b. Context Block(s) - To include the test condition and description.
      c. It statements - To include the test case and description.
      d. Test Assertion - Evaluate the actual values against the expected values.
        i.e., 1 + 1 | Should be 2
          1 + 2 | Should not be 3
    3. Provide the tester a list of available devices ID's for the Device Type Under Test. 
    4. Provide a user input field for the device id.
    5. Include the required commands which connects the user to Microsoft Graph.
    6. Provide evidence of the captured settings - This will not include the expected results as they will be present in this script. 
    
  .EXAMPLE
    Invoke-Pester "C:\TestsScripts\androidV1.0.tests.ps1"
    .\androidV1.0.tests.ps1
#>

<#
Android Phone
Samsung Models   
-----   
1. SM-G950F
2. SM-X700 
3. SM-G780G

Variables
$SMG950F = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "android" -and $_.Model -eq "SM-G950F"}
$SMX700 = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "android" -and $_.Model -eq "SM-X700"}
$SMG780G = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "android" -and $_.Model -eq "SM-G780G"}
#>

<# ---TESTS RAN-----
====================== RF8T311T20E System Integration Test Complete 01/23/2023 11:25:04===========================
Green = Tested Passed
Red = Test Failed. See comments for details. The line number refers to the script line number which failed
Tests completed in 94.43s
Passed: 217 Failed: 4 Skipped: 0 Pending: 0 Inconclusive: 0

    [-] RF8T311T20E Compliance State 10ms
      Expected: {Compliant}
      But was:  {noncompliant}
      444:             $androidDevice.ComplianceState | Should be "Compliant"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 444
    [-] RF8T311T20E Compliance State 18ms
      Expected: value was {noncompliant}, but should not have been the same
      447:             $androidDevice.ComplianceState | Should not be "NonCompliant"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 447
  Context RF8T311T20E meets the defined Azure Active Directory Integration tests
    [-] RF8T311T20E Azure Ad Registered 172ms
      Expected: {True}
      But was:  {}
      591:             $androidDevice.AzureAdRegistered | Should be "True"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 591
    
    [+] RF8T311T20E Azure Ad Registered 19ms
    [-] RF8T311T20E Android Azure Device Registration 7ms
      Expected: {True}
      But was:  {}
      612:             $androidDevice.AzureADRegistered | Should be "True"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 612

====================== R52T706VZTZ System Integration Test Complete 01/23/2023 14:12:30===========================
Green = Tested Passed
Red = Test Failed. See comments for details. The line number refers to the script line number which failed
Tests completed in 66.78s
Passed: 217 Failed: 4 Skipped: 0 Pending: 0 Inconclusive: 0
   
    [-] R52T706VZTZ Imei count 350ms
      Expected: {15}
      But was:  {0}
      270:           $androidDevice.HardwareInformation.Imei.length | Should be "15"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 270

    [-] R52T706VZTZ Compliance State 32ms
      Expected: {Compliant}
      But was:  {noncompliant}
      450:             $androidDevice.ComplianceState | Should be "Compliant"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 450
    [-] R52T706VZTZ Compliance State 48ms
      Expected: value was {noncompliant}, but should not have been the same
      453:             $androidDevice.ComplianceState | Should not be "NonCompliant"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 453
   
    [-] R52T706VZTZ Meid Length  28ms
      Expected: {14}
      But was:  {0}
      466:             $androidDevice.Meid.Length | Should be "14"
      at <ScriptBlock>, C:\Users\tlaw8\OneDrive - DXC Production\Scripting\GraphAPI\GraphDevices\androidV1.0.tests.ps1: line 466


#>

function mgUser-Agreement {
#Creator - Tony Law
Clear-Host
Write-Host "`n============= THIS PESTER AUTOMATION SCRIPT IS PROVIDED BY THE DXC TEST TEAM =============="
Write-Host "`nHello $env:USERNAME, you are now executing a Pester Test Script, which will connect to an Azure Tenant."
Start-Sleep -seconds 3
Write-Host "`nBy continuing, you agree that you have the appropriate permissions, and have been authorised to do so."
Start-Sleep -Milliseconds 2500
Write-Host "`nIf you are in any doubt, press Ctrl-C to abort!!!! You will only see this message once during script execution`n" -BackgroundColor Green
Start-Sleep -Seconds 2.5
Pause  
}

function mgAccess-MgSDK {
#Creator - Tony Law
      
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

function mgAndroid-UserDevice {
#Creator - Tony Law
        
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

function mgWindows-UserDevice {
#Creator - Tony Law

$devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "Windows"}
Write-Host "`nCollecting users...."
$userDispName = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "Windows"} | Select-Object UserDisplayName -Unique 
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
#Creator - Tony Law
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
#Creator - Tony Law
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
#Creator - Tony Law
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



mgUser-Agreement
mgAccess-MgSDK
mgandroid-UserDevice

Write-Host "`n`n===================== $deviceID Hardware System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "`n$deviceID Hardware System Integration Test" {
    Context "$deviceID System Configuration Settings" {
        It "$deviceID Additional Properties" {
            $androidDevice.HardwareInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Name" {
            $androidDevice.DeviceName | Should belike "*AndroidEnterprise*"
        }
        It "$deviceID Managed DeviceName" {
            $androidDevice.ManagedDeviceName | Should belike "*AndroidEnterprise*"
        }
        It "$deviceID Hardware Information Serial Number length" {
            $androidDevice.HardwareInformation.SerialNumber.length | Should be "11"
        }
        It "$deviceID Enrollment Profile Name" {
            $androidDevice.EnrollmentProfileName | Should be $null 
        }
        It "$deviceID Hardware Information" {
            $androidDevice.HardwareInformation | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphHardwareInformation"
        }
        It "$deviceID Device Fully Qualified Domain Name" {
            $androidDevice.HardwareInformation.DeviceFullQualifiedDomainName | Should be $null 
        }
        It "$deviceID Device Licensing Last Error Code" {
            $androidDevice.HardwareInformation.DeviceLicensingLastErrorCode | Should be "0"
        }
        It "$deviceID Device Licensing LastError Description" {
            $androidDevice.HardwareInformation.DeviceLicensingLastErrorDescription | Should be $null 
        }
        It "$deviceID Device LicensingStatus" {
            $androidDevice.HardwareInformation.DeviceLicensingStatus | Should be "unknown"
        }
        It "$deviceID Esim Identifier" {
            $androidDevice.HardwareInformation.EsimIdentifier | Should be $null 
        } 
        It "$deviceID Hardware Information Operating System Product Type" {
            $androidDevice.HardwareInformation.OperatingSystemProductType | Should be "0" 
        }
        It "$deviceID Hardware Information Operating System Product Type" {
            $androidDevice.HardwareInformation.OperatingSystemProductType | Should not be "1" 
        }
        It "$deviceID Hardware Information Product Name" {
            $androidDevice.HardwareInformation.ProductName | Should be $null 
        }
        It "$deviceID Hardware Information Resident Users Count" {
            $androidDevice.HardwareInformation.ResidentUsersCount | Should be $null 
        }
        It "$deviceID Hardware Information Serial Number length" {
            $androidDevice.HardwareInformation.SerialNumber.length | Should be "11"
        }
        It "$deviceID Hardware Information Shared Device Cached Users" {
            $androidDevice.HardwareInformation.SharedDeviceCachedUsers | Should be $null
        }
        It "$deviceID Hardware Information System Management Bios Version" {
            $androidDevice.HardwareInformation.SystemManagementBiosVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Manufacturer" {
            $androidDevice.HardwareInformation.TpmManufacturer | Should be $null
        }
        It "$deviceID Hardware Information Tpm Specification Version" {
            $androidDevice.HardwareInformation.TpmSpecificationVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Version" {
            $androidDevice.HardwareInformation.TpmVersion | Should be $null
        }
    }
    Context "$deviceID Operating System" {
        It "$deviceID Operating System " {
            $androidDevice.OperatingSystem | Should belike "Android*"
        }
        It "$deviceID OS Version " {
            $androidDevice.OSVersion | Should be @("9", "12", "13")
        }
        It "$deviceID Hardware Information OS Build Number" {
            $androidDevice.HardwareInformation.OSBuildNumber | Should be $null 
        }
        It "$deviceID Hardware Information Operating System Language" {
            $androidDevice.HardwareInformation.OperatingSystemLanguage | Should be $null 
        }
        It "$deviceID Hardware Information Operating SystemEdition" {
            $androidDevice.HardwareInformation.OperatingSystemEdition | Should be $null 
        }    
        It "$deviceID Android Security Patch Level" {
            $androidDevice.AndroidSecurityPatchLevel | Should be @("2022-10-01", "2022-12-01", "2021-04-01")
        }
    }
     Context "$deviceID Storage settings and ultilisation" {
        It "$deviceID Free Storage Space In Bytes" {
            $androidDevice.FreeStorageSpaceInBytes | Should be 0
        }
        It "$deviceID Free Storage Space" {
            $androidDevice.HardwareInformation.FreeStorageSpace | Should be "0"
        }
        It "$deviceID HardwareInformation Total Storage Space" {
            $androidDevice.HardwareInformation.TotalStorageSpace | Should be "0"
        }
        It "$deviceID Hardware Information Total Storage Space" {
            $androidDevice.HardwareInformation.TotalStorageSpace | Should not be "1"
        }
        It "$deviceID Total Storage Space In Bytes" {
            $androidDevice.TotalStorageSpaceInBytes | Should be @("5848956928", "5794430976", "4408213504", "5214568448")
        }
    }
    Context "$deviceID Battery settings and ultilisation" {
         It "$deviceID Battery Charge Cycles" {
            $androidDevice.HardwareInformation.BatteryChargeCycles | Should be "0"
        }
        It "$deviceID Battery Health Percentage" {
            $androidDevice.HardwareInformation.BatteryHealthPercentage | Should be "0"
        }
        It "$deviceID Battery Level Percentage" {
            $androidDevice.HardwareInformation.BatteryLevelPercentage | Should be $null 
        }
        It "$deviceID Battery Serial Number" {
            $androidDevice.HardwareInformation.BatterySerialNumber | Should be $null 
        }
    }
    Context "$deviceID System enclosure settings and ultilisation" {
        It "$deviceID Imei count" {
          $androidDevice.HardwareInformation.Imei.length | Should be "15"
        }
        It "$deviceID Hardware Information Manufacturer " {
            $androidDevice.HardwareInformation.Manufacturer | Should be $null 
        }
        It "$deviceID Hardware Information Meid" {
            $androidDevice.HardwareInformation.Meid | Should be $null 
        }
        It "$deviceID Hardware Information Model" {
            $androidDevice.HardwareInformation.Model | Should be $null 
        }
        It "$deviceID Hardware Information Phone Number" {
            $androidDevice.HardwareInformation.PhoneNumber | Should be $null 
        }
    }
    Context "$deviceID Network details" {
        It "$deviceID Hardware Information SubscriberCarrier" {
            $androidDevice.HardwareInformation.SubscriberCarrier | Should be $null
        }
        It "$deviceID Cellular Technology" {
            $androidDevice.HardwareInformation.CellularTechnology | Should be $null 
        }
        It "$deviceID Hardware Information Wifi Mac" {
            $androidDevice.HardwareInformation.WifiMac | Should be $null
        }
        It "$deviceID WiFi Mac Address length" {
            $androidDevice.WiFiMacAddress.length | Should be "12"
        }
        It "$deviceID Ethernet Mac Address" {
            $androidDevice.EthernetMacAddress | Should be $null 
        }
        It "$deviceID Wired IPv4 Addresses" {
            $androidDevice.HardwareInformation.WiredIPv4Addresses | Should be $null
        }
        It "$deviceID IP AddressV4" {
            $androidDevice.HardwareInformation.IPAddressV4 | Should be $null 
        }
        It "$deviceID Hardware Information Subnet Address" {
            $androidDevice.HardwareInformation.SubnetAddress | Should be $null
        }
    }
    Context "$deviceID Conditional Access" {
        It "$deviceID Activation Lock Bypass Code" {
            $androidDevice.ActivationLockBypassCode | Should be $null
        }
        It "$deviceID Eas Activated" {
            $androidDevice.EasActivated | Should be "False"
        }
        It "$deviceID Eas Activated" {
            $androidDevice.EasActivated | Should not be "True"
        }
        It "$deviceID Eas Activation Date Time" {
            $androidDevice.EasActivationDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Eas Device Id" {
            $androidDevice.EasDeviceId | Should be "" 
        }
        It "$deviceID Is Supervised" {
            $androidDevice.HardwareInformation.IsSupervised | Should be "False"
        }
        It "$deviceID Is Supervised - Negative Test" {
            $androidDevice.IsSupervised | Should be "False"
        }
        It "$deviceID Is Supervised - Positive Test" {
            $androidDevice.HardwareInformation.IsSupervised | Should not be "True"
        }
        It "$deviceID Is Encrypted - Negative Test" {
            $androidDevice.HardwareInformation.IsEncrypted | Should be "False"
        } 
        It "$deviceID Is Encrypted - Positive Test" {
            $androidDevice.HardwareInformation.IsEncrypted | Should not be "True"
        } 
        It "$deviceID Is not JailBroken - Positive test" {
            $androidDevice.JailBroken | Should be @("False", "Unknown")
        }
        It "$deviceID Is not Jail Broken - Negative Test" {
            $androidDevice.JailBroken | Should not be "True"
        }
        It "$deviceID Is not a Shared Device" {
            $androidDevice.HardwareInformation.IsSharedDevice | Should be "False"
        }
        It "$deviceID Is Shared Device - Negative Test" {
            $androidDevice.HardwareInformation.IsSharedDevice | Should not be "True"
        }
    }
}

Write-Host "`n`n===================== $deviceID Applications System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Applications System Integration Test" {
    Context "Discovered apps" {
        It "$deviceID Auto pilot Enrolled" {
            $androidDevice.AutopilotEnrolled | Should be "False"
        }
        It "$deviceID Auto pilot Enrolled" {
            $androidDevice.AutopilotEnrolled | Should not be "True"
        }
        It "$deviceID Detected Applications" {
            $androidDevice.DetectedApps.Count | Should be 0
        }
        It "$deviceID Detected Application ID" {
            $androidDevice.DetectedApps.Id | Should be $null
        }
        It "$deviceID Detected Apps" {
            $androidDevice.DetectedApps| Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientEnabledFeatures1"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Device Configuration" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.DeviceConfiguration | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Endpoint Protection" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.EndpointProtection | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Inventory" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.Inventory | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features Modern Apps" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.ModernApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Office Apps " {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.OfficeApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - ResourceAccess " {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.ResourceAccess | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Windows Update For Business" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.WindowsUpdateForBusiness | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Additional Properties" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State" {
            $androidDevice.ConfigurationManagerClientHealthState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientHealthState"
        }
        It "$deviceID Configuration Manager Client Health State - Error Code" {
            $androidDevice.ConfigurationManagerClientHealthState.ErrorCode | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Last Sync Date Time" {
            $androidDevice.ConfigurationManagerClientHealthState.LastSyncDateTime | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Status" {
            $androidDevice.ConfigurationManagerClientHealthStateState | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Additional Properties" {
            $androidDevice.ConfigurationManagerClientHealthState.AdditionalProperties.Values | Should be $null
        }  
        It "$deviceID Configuration Manager Client Information - " {
            $androidDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Identifier" {
            $androidDevice.ConfigurationManagerClientInformation.ClientIdentifier | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Version" {
            $androidDevice.ConfigurationManagerClientInformation.ClientVersion | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Is Blocked" {
            $androidDevice.ConfigurationManagerClientInformation.IsBlocked | Should be $null
        }
        It "$deviceID Additional Properties" {
            $androidDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
    }
}

Write-Host "`n`n================== $deviceID Device Compliance System Integration Test ======================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device Compliance System Integration Test" {
    Context "$deviceID meets the defined compliance integration Tests" {
        It "Compliance Grace Period Expiration Date Time" {
            $androidDevice.ComplianceGracePeriodExpirationDateTime | Should belike "*/*/* *:*:*"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Compliance Policy" {
            $androidDevice.ConfigurationManagerClientEnabledFeatures.CompliancePolicy | Should be $null
        }
        It "$deviceID Device Compliance Policy States" {
            $androidDevice.DeviceCompliancePolicyStates | Should be $null 
        }
        It "$deviceID Compliance State" {
            $androidDevice.ComplianceState | Should be "Compliant"
        }
        It "$deviceID Compliance State" {
            $androidDevice.ComplianceState | Should not be "NonCompliant"
        }
    }
}

Write-Host "`n`n================== $deviceID Device Configuration System Integration Test ===================`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device configuration System Integration Test" {
    Context "$deviceID meets the defined configuration integration tests" {   
        It "$deviceID Manufacturer" {
            $androidDevice.Manufacturer | Should be "samsung"
        }
        It "$deviceID Meid Length " {
            $androidDevice.Meid.Length | Should be "14"
        }
        It "$deviceID Model" {
            $androidDevice.Model | Should be @("SM-G950F", "SM-X700", "SM-G780G")
        }
        It "$deviceID Owner Type" {
            $androidDevice.OwnerType | Should be "company"
        }
        It "$deviceID Remote Assistance Session Error Details" {
            $androidDevice.RemoteAssistanceSessionErrorDetails | Should be $null 
        }
        It "$deviceID Remote Assistance Session Url" {
            $androidDevice.RemoteAssistanceSessionUrl | Should be $null 
        }
        It "$deviceID Enrolled Date Time" {
            $androidDevice.EnrolledDateTime | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID RequireUser Enrollment Approval" {
            $androidDevice.RequireUserEnrollmentApproval | Should be $null 
        }
        It "$deviceID Retire After Date Time" {
            $androidDevice.RetireAfterDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Role Scope Tag Ids" {
            $androidDevice.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Security Baseline States" {
            $androidDevice.SecurityBaselineStates | Should be $null 
        }
        It "$deviceID Serial Number length" {
            $androidDevice.SerialNumber.Length | Should be "11"
        }
        It "$deviceID User Display Name count " {
            $androidDevice.UserDisplayName.count | Should be 1
        }
        It "$deviceID User Id" {
            $androidDevice.UserId | Should belike "*-*-*-*"
        }
        It "$deviceID User Principal Name " {
            $androidDevice.UserPrincipalName | Should belike "*@defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Additional Properties" {
            $androidDevice.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Configuration States" {
            $androidDevice.DeviceConfigurationStates | Should be $null 
        }
        It "$deviceID Device Enrollment Type" {
            $androidDevice.DeviceEnrollmentType | Should be "androidEnterpriseFullyManaged"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $androidDevice.DeviceFirmwareConfigurationInterfaceManaged | Should be "False"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $androidDevice.DeviceFirmwareConfigurationInterfaceManaged | Should not be "True"
        }
        It "$deviceID Device Category" {
            $androidDevice.DeviceCategory | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceCategory1"
        }
        It "$deviceID Device Category - Description" {
            $androidDevice.DeviceCategory.Description | Should be $null
        }
        It "$deviceID Device Category - DisplayName" {
            $androidDevice.DeviceCategory.DisplayName | Should be $null
        }
        It "$deviceID Device Category - Id" {
            $androidDevice.DeviceCategory.Id | Should be $null
        }
        It "$deviceID Device Category Role Scope Tag Ids" {
            $androidDevice.DeviceCategory.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Device Category Additional Properties " {
            $androidDevice.DeviceCategory.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Category Display Name" {
            $androidDevice.DeviceCategoryDisplayName | Should be "Unknown"
        }
        It "$deviceID Windows Pe" {
            $androidDevice.DeviceHealthAttestationState.WindowsPe | Should be $null
        }
        It "$deviceID Additional Properties" {
            $androidDevice.DeviceHealthAttestationState.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Registration State" {
            $androidDevice.DeviceRegistrationState | Should be "registered"
        }
        It "$deviceID Device Registration State" {
            $androidDevice.DeviceRegistrationState | Should not be "unregistered"
        }
        It "$deviceID Device Type" {
            $androidDevice.DeviceType | Should be "androidEnterprise"
        }
    }
    Context "$deviceID meets the defined Mail System Integration Tests" {
        It "$deviceID Email Address" {
            $androidDevice.EmailAddress | Should belike "*defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Exchange Access State" {
            $androidDevice.ExchangeAccessState | Should be "none"
        }
        It "$deviceID Exchange Access State Reason" {
            $androidDevice.ExchangeAccessStateReason | Should be "none"
        }
        It "$deviceID Exchange Last Successful Sync Date Time" {
            $androidDevice.ExchangeLastSuccessfulSyncDateTime | Should be "01/01/0001 00:00:00"
        }
    }
}

Write-Host "`n`n================== $deviceID Group Membership System Integration Test =====================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Group Membership System Integration Test" {
    Context "$deviceID meets the defined Device Management Integration Test" { 
        It "$deviceID Managed Device Owner Type" {
            $androidDevice.ManagedDeviceOwnerType | Should be "company"
        }
        It "$deviceID Management Agent" {
            $androidDevice.ManagementAgent | Should be "googleCloudDevicePolicyController"
        }
        It "$deviceID Management Certificate ExpirationDate" {
            $androidDevice.ManagementCertificateExpirationDate | Should be "01/01/0001 00:00:00" 
        }
        It "$deviceID ManagementFeatures" {
            $androidDevice.ManagementFeatures | Should be "none"
        }
        It "$deviceID ManagementState" {
            $androidDevice.ManagementState | Should be "managed"
    }
}
  Context "$deviceID meets the defined Azure Active Directory Integration tests" { 
        It "$deviceID Azure Ad Registered" {
            $androidDevice.AzureAdRegistered | Should be "True"
        }
        It "$deviceID Azure Ad Registered" {
            $androidDevice.AzureAdRegistered | Should not be "False"
        }
        It "$deviceID Join Type" {
            $androidDevice.JoinType | Should be "azureADRegistered"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $androidDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $androidDevice.AzureAdDeviceId.Length | Should be 36
        }
        It "$deviceID Azure AdDevice Id" {
            $androidDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure AdDevice Id" {
            $androidDevice.AzureAdDeviceId.Length | Should belike 36
        }
        It "$deviceID Android Azure Device Registration" {
            $androidDevice.AzureADRegistered | Should be "True"
        }
        It "$deviceID Android Azure Device Registration" {
            $androidDevice.AzureADRegistered | Should not be "False"
        }
        It "$deviceID Prefer Mdm Over Group Policy Applied Date Time" {
            $androidDevice.PreferMdmOverGroupPolicyAppliedDateTime | Should be "01/01/0001 00:00:00"
    }
}
    Context "$deviceID meets the defined Device Integration Configuration Status tests" {
        It "$deviceID Assignment Filter Evaluation Status Details" {
            $androidDevice.AssignmentFilterEvaluationStatusDetails | Should be $null
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $androidDevice.BootstrapTokenEscrowed | Should be "False"
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $androidDevice.BootstrapTokenEscrowed | Should not be "True"
        }
        It "$deviceID Chassis Type" {
            $androidDevice.ChassisType | Should be "unknown"
        }
        It "$deviceID Chrome OS Device Info" {
            $androidDevice.ChromeOSDeviceInfo | Should be $null
        }
        It "$deviceID Cloud Pc Remote Action Results" {
            $androidDevice.CloudPcRemoteActionResults | Should be $null
        }
        It "$deviceID Device Action Results" {
            $androidDevice.DeviceActionResults | Should be $null
        }
    }
}

Write-Host "`n`n======================= $deviceID Security System Integration Test ==========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Security System Integration Test" {
  Context "$deviceID meets the defined meets the defined Security Integration Tests " {
    It "$deviceID Partner Reported Threat State" {
      $androidDevice.PartnerReportedThreatState | Should be "unknown"
        }
        It "$deviceID Windows Active Malware Count should be zero" {
            $androidDevice.WindowsActiveMalwareCount | Should be "0"
        }
        It "$deviceID Windows Active Malware Count should be less than 1" {
            $androidDevice.WindowsActiveMalwareCount | Should not be "1"
        }
        It "$deviceID Windows Protection State graph definition should be correctly defined" {
            $androidDevice.WindowsProtectionState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphWindowsProtectionState"
        }
        It "$deviceID Windows Protection State Anti Malware Version should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateAntiMalwareVersion | Should be $null
        }
        It "$deviceID Windows Protection State Detected Malware State should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateDetectedMalwareState | Should be $null
        }
        It "$deviceID Windows Protection State Device State should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateDeviceState | Should be $null
        }
        It "$deviceID Windows Protection State Engine Version should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateEngineVersion | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Overdue should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateFullScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Required should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateFullScanRequired | Should be $null
        }
        It "$deviceID Windows Protection State Id should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateId | Should be $null
        }
        It "$deviceID Windows Protection States Virtual Machine should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStatesVirtualMachine | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan Date Time should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan - Signature Version should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State Last Quick Scan - Date Time should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Last Reported Date/Time should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateLastReportedDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Malware Protection Enabled should not be set" {
            $androidDevice.WindowsProtectionState.WindowsProtectionStateMalwareProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Network Inspection System Enabled should not be set" {
            $androidDevice.WindowsProtectionStateNetworkInspectionSystemEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Product Status should not be set" {
            $androidDevice.WindowsProtectionStateProductStatus | Should be $null
        }
        It "$deviceID Windows Protection State - Quick Scan Overdue should not be set" {
            $androidDevice.WindowsProtectionStateQuickScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Real Time Protection Enabled should not be set" {
            $androidDevice.WindowsProtectionStateRealTimeProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Reboot Required should not be set" {
            $androidDevice.WindowsProtectionStateRebootRequired | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Update Overdue should not be set" {
            $androidDevice.WindowsProtectionStateSignatureUpdateOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $androidDevice.WindowsProtectionStateSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Tamper Protection Enabled should not be set" {
            $androidDevice.WindowsProtectionStateTamperProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Additional Properties should not be set" {
            $androidDevice.WindowsProtectionStateAdditionalProperties | Should be $null
        }
        It "$deviceID Windows Remediated Malware Count should be 'Zero'" {
            $androidDevice.WindowsRemediatedMalwareCount | Should be 0
        }
        It "$deviceID Windows Remediated Malware Count should not be more than 0" {
            $androidDevice.WindowsRemediatedMalwareCount | Should belessthan 1
        }
        It "$deviceID Device Health Attestation State Graph Path should be correctly defined" {
            $androidDevice.DeviceHealthAttestationState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceHealthAttestationState"
        }
        It "$deviceID Attestation Identity Key should not be set" {
            $androidDevice.DeviceHealthAttestationState.AttestationIdentityKey | Should be $null 
        }
        It "$deviceID Bit Locker Status should not be set" {
            $androidDevice.DeviceHealthAttestationState.BitLockerStatus | Should be $null 
        }
        It "$deviceID Boot App Security Version should not be set" {
            $androidDevice.DeviceHealthAttestationState.BootAppSecurityVersion | Should be $null 
        }
        It "$deviceID Boot Debugging should not be set" {
            $androidDevice.DeviceHealthAttestationState.BootDebugging | Should be $null 
        }
        It "$deviceID Boot Manager Security Version should not be set" {
            $androidDevice.DeviceHealthAttestationState.BootManagerSecurityVersion | Should be $null
        }
        It "$deviceID Boot Manager Version should not be set" {
            $androidDevice.DeviceHealthAttestationState.BootManagerVersion | Should be $null
        }
        It "$deviceID Boot Revision List Info should not be set" {
            $androidDevice.DeviceHealthAttestationState.BootRevisionListInfo | Should be $null
        }
        It "$deviceID Code Integrity should not be set" {
            $androidDevice.DeviceHealthAttestationState.CodeIntegrity | Should be $null
        }
        It "$deviceID Device Health Attestation State Code Integrity Check Version should not be set" {  
            $androidDevice.DeviceHealthAttestationState.CodeIntegrityCheckVersion | Should be $null
        }
        it "$deviceid Code Integrity Policy should not be set" {
            $androidDevice.CodeIntegrityPolicy | Should be $null
        }
        It "$deviceID Content Namespace Url should not be set" {
            $androidDevice.ContentNamespaceUrl | Should be $null
        }
        It "$deviceID Content Version should not be set" {
            $androidDevice.ContentVersion | Should be $null
        }
        It "$deviceID Data Excution Policy should not be set" {
            $androidDevice.DataExcutionPolicy | Should be $null
        }
        It "$deviceID Device Health Attestation Status should not be set" {
            $androidDevice.DeviceHealthAttestationStatus | Should be $null
        }
        It "$deviceID Early Launch Anti Malware Driver Protection should not be set" {
            $androidDevice.EarlyLaunchAntiMalwareDriverProtection | Should be $null
        }
        It "$deviceID Health Attestation Supported Status should not be set" {
            $androidDevice.DeviceHealthAttestationState.HealthAttestationSupportedStatus | Should be $null
        }
        It "$deviceID Health Status Mismatch Info should not be set" {
            $androidDevice.DeviceHealthAttestationState.HealthStatusMismatchInfo | Should be $null
        }
        It "$deviceID Issued Date Time should not be set" {
            $androidDevice.DeviceHealthAttestationState.IssuedDateTime | Should be $null
        }
        It "$deviceID Last Update Date Time should not be set" {
            $androidDevice.DeviceHealthAttestationState.LastUpdateDateTime | Should be $null
        }
        It "$deviceID Operating System Kernel Debugging should not be set" {
            $androidDevice.DeviceHealthAttestationState.OperatingSystemKernelDebugging | Should be $null
        }
        It "$deviceID Operating System Rev List Info should not be set" {
            $androidDevice.DeviceHealthAttestationState.OperatingSystemRevListInfo | Should be $null
        }
        It "$deviceID Pcr 0 should not be set" {
            $androidDevice.DeviceHealthAttestationState.Pcr0 | Should be $null
        }
        It "$deviceID Pcr Hash Algorithm should not be set" {
            $androidDevice.DeviceHealthAttestationState.PcrHashAlgorithm | Should be $null
        }
        It "$deviceID Reset Count should be null" {
            $androidDevice.DeviceHealthAttestationState.ResetCount | Should be $null
        }
        It "$deviceID Restart Count should not be set" {
            $androidDevice.DeviceHealthAttestationState.RestartCount | Should be $null
        }
        It "$deviceID Safe Mode should not be set" {
            $androidDevice.DeviceHealthAttestationState.SafeMode | Should be $null
        }
        It "$deviceID Secure Boot should not be set" {
            $androidDevice.DeviceHealthAttestationState.SecureBoot | Should be $null
        }
        It "$deviceID Secure Boot Configuration Policy Finger Print should not be set" {
            $androidDevice.DeviceHealthAttestationState.SecureBootConfigurationPolicyFingerPrint | Should be $null
        }
        It "$deviceID Test Signing should not be set" {
            $androidDevice.DeviceHealthAttestationState.TestSigning | Should be $null
        }
        It "$deviceID Tpm Version should not be set" {
            $androidDevice.DeviceHealthAttestationState.TpmVersion  | Should be $null
        }
        It "$deviceID Virtual Secure Mode should not be set" {
            $androidDevice.DeviceHealthAttestationState.VirtualSecureMode | Should be $null
        } 
        It "$deviceID The device IsEncrypted state should be true" {
            $androidDevice.IsEncrypted | Should be "True"
        }
        It "$deviceID The device IsEncrypted state should not be false" {
            $androidDevice.IsEncrypted | Should not be "False"
        }
        It "$deviceID The last sync date time should have been in the last 3 months" {
            $androidDevice.LastSyncDateTime | Should begreaterthan (Get-Date).AddDays(-90)
        }
        It "$deviceID Lost mode state should be disabled" {
            $androidDevice.LostModeState | Should be "disabled"
        }
        It "$deviceID Lost mode state should not be enabled" {
            $androidDevice.LostModeState | Should not be "enabled"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Positive Test" {
            $androidDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should be "running"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Negative Test" {
            $androidDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should not be "stopped"
        }
        It "$deviceID Device Guard Virtualization Based Security Hardware RequirementState" {
            $androidDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityHardwareRequirementState | Should be "meetHardwareRequirements"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Positive Test" {
            $androidDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should be "running"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Negative Test" {
            $androidDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should not be "stopped"
        }

$date = ((Get-Date).ToUniversalTime())       
Write-Host "`n`n============= $deviceID System Integration Test Complete on $date================`n"
Start-Sleep -Seconds 1
Write-Host "Green = Tested Passed" -ForegroundColor Green
Write-Host "Red = Test Failed. See comments for details. The line number refers to the script line number which failed" -ForegroundColor Red 
  }
}