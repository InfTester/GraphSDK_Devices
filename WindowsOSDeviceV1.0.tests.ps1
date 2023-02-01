<#
	.NOTES
========================================================================================================================================================
		Created on: 21.01.2023
      Last Modified: 21.01.2023 
		Created by: Tony Law
		Filename: windowsOSDevicev1.0.tests.ps1
    Version: 0.1
    Test Level: System Integration
    Devices Type Test Compatibility: 
        Latitude 5330                      
        Cloud PC Enterprise 2vCPU/8GB/128GB
        Virtual Machine                    
        Latitude 5320                      
        Latitude 5300                      
        Latitude 3490                      
        Latitude 7480                      
        OptiPlex 5060                      
        VMware7,1                          
        Latitude 7210 2-in-1               
        20FES4GM01                         
        Latitude 5290 2-in-1   
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
    Invoke-Pester "C:\TestsScripts\windowsOSDevicev1.0.tests.ps1"
    .\windowsOSDevicev1.0.tests.ps1
#>

<#
Windows Devices
Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -EQ "Windows" } | Select-Object "model" -Unique     
1. Latitude 5330                      
2. Cloud PC Enterprise 2vCPU/8GB/128GB
3. Virtual Machine                    
4. Latitude 5320                      
5. Latitude 5300                      
6. Latitude 3490                      
7. Latitude 7480                      
8. OptiPlex 5060                      
9. VMware7,1                          
10. Latitude 7210 2-in-1               
11. 20FES4GM01                         
12. Latitude 5290 2-in-1 
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

<#
function mgWindows-UserDevice {
#Creator - Tony Law

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
#>

mgUser-Agreement

mgAccess-MgSDK

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
$devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OperatingSystem, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
    } While ($deviceID -notin ($devDetails).SerialNumber)
    $windowsOSDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}

Write-Host "`n`n===================== $deviceID Hardware System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "`n$deviceID Hardware System Integration Test" -Tags Hardware, SIT {
    Context "$deviceID System Configuration Settings" {
        It "$deviceID Additional Properties" {
            $windowsOSDevice.HardwareInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Name" {
             $dname = $windowsOSDevice.SerialNumber   
            $windowsOSDevice.DeviceName | Should belike *$dname
        }
        It "$deviceID Device Name" {
            $windowsOSDevice.DeviceName | Should belike @("*$dname")
             $dname = $windowsOSDevice.SerialNumber   
        }

        It "$deviceID Managed Device Name" {
            $windowsOSDevice.ManagedDeviceName | Should belike @("*Windows*")
        }
        It "$deviceID Hardware Information Serial Number length" {
            $windowsOSDevice.HardwareInformation.SerialNumber.length | Should be @("7", "8")
        }
        It "$deviceID Enrollment Profile Name" {
            $windowsOSDevice.EnrollmentProfileName | Should be $null 
        }
        It "$deviceID Hardware Information" {
            $windowsOSDevice.HardwareInformation | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphHardwareInformation"
        }
        It "$deviceID Device Fully Qualified Domain Name" {
            $windowsOSDevice.HardwareInformation.DeviceFullQualifiedDomainName | Should be $null 
        }
        It "$deviceID Device Licensing Last Error Code" {
            $windowsOSDevice.HardwareInformation.DeviceLicensingLastErrorCode | Should be "0"
        }
        It "$deviceID Device Licensing LastError Description" {
            $windowsOSDevice.HardwareInformation.DeviceLicensingLastErrorDescription | Should be $null 
        }
        It "$deviceID Device LicensingStatus" {
            $windowsOSDevice.HardwareInformation.DeviceLicensingStatus | Should be "unknown"
        }
        It "$deviceID Esim Identifier" {
            $windowsOSDevice.HardwareInformation.EsimIdentifier | Should be $null 
        } 
        It "$deviceID Hardware Information Operating System Product Type" {
            $windowsOSDevice.HardwareInformation.OperatingSystemProductType | Should be "0" 
        }
        It "$deviceID Hardware Information Operating System Product Type" {
            $windowsOSDevice.HardwareInformation.OperatingSystemProductType | Should not be "1" 
        }
        It "$deviceID Hardware Information Product Name" {
            $windowsOSDevice.HardwareInformation.ProductName | Should be $null 
        }
        It "$deviceID Hardware Information Resident Users Count" {
            $windowsOSDevice.HardwareInformation.ResidentUsersCount | Should be $null 
        }
        It "$deviceID Hardware Information Serial Number length" {
            $windowsOSDevice.HardwareInformation.SerialNumber.length | Should be @("7", "8")
        }
        It "$deviceID Hardware Information Shared Device Cached Users" {
            $windowsOSDevice.HardwareInformation.SharedDeviceCachedUsers | Should be $null
        }
        It "$deviceID Hardware Information System Management Bios Version" {
            $windowsOSDevice.HardwareInformation.SystemManagementBiosVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Manufacturer" {
            $windowsOSDevice.HardwareInformation.TpmManufacturer | Should be $null
        }
        It "$deviceID Hardware Information Tpm Specification Version" {
            $windowsOSDevice.HardwareInformation.TpmSpecificationVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Version" {
            $windowsOSDevice.HardwareInformation.TpmVersion | Should be $null
        }
    }

    Context "$deviceID Operating System"  {
        It "$deviceID Operating System " {
            $windowsOSDevice.OperatingSystem | Should be "Windows"
        }
        It "$deviceID OS Version " {
            $windowsOSDevice.OSVersion | Should be @("10.0.19044.2130", "10.0.19045.2364", "10.0.19045.2486", "10.0.19045.2006",`
 "10.0.22621.819", "10.0.19044.2251", "10.0.19045.2311", "10.0.19042.1110", "10.0.18363.2274", "10.0.18363.1977", "10.0.19044.1826",`
  "10.0.19044.2006", "10.0.19042.2130", "10.0.19044.1889", "10.0.19044.1288")
        }
        It "$deviceID Hardware Information OS Build Number" {
            $windowsOSDevice.HardwareInformation.OSBuildNumber | Should be $null 
        }
        It "$deviceID Hardware Information Operating System Language" {
            $windowsOSDevice.HardwareInformation.OperatingSystemLanguage | Should be $null 
        }
        It "$deviceID Hardware Information Operating SystemEdition" {
            $windowsOSDevice.HardwareInformation.OperatingSystemEdition | Should be $null 
        }  
        It "$deviceID Android Security Patch Level" {
            $windowsOSDevice.AndroidSecurityPatchLevel | Should be ""
        }
    }

     Context "$deviceID Storage settings and ultilisation" {
        It "$deviceID Free Storage Space In Bytes" {
        $minFreeStorage = ($windowsOSDevice.TotalStorageSpaceInBytes)/1gb/10
        $actualFreeStorage = ($windowsOSDevice.FreeStorageSpaceInBytes)/1gb
            $actualFreeStorage | Should beGreaterThan $minFreeStorage
        }
        It "$deviceID Free Storage Space" {
            $windowsOSDevice.HardwareInformation.FreeStorageSpace | Should be "0"
        }
        It "$deviceID HardwareInformation Total Storage Space" {
            $windowsOSDevice.HardwareInformation.TotalStorageSpace | Should be "0"
        }
        It "$deviceID Hardware Information Total Storage Space" {
            $windowsOSDevice.HardwareInformation.TotalStorageSpace | Should not be "1"
        }
        It "$deviceID Total Storage Space In Bytes" {
#            $windowsOSDevice.TotalStorageSpaceInBytes | Should be @("255379636224","127368429568", "255461425152","255371247616")
            $windowsOSDevice.TotalStorageSpaceInBytes/1gb | Should be @("118*", "119*", "235*", "236*", "237*", "238*")
        }
    }
    Context "$deviceID Battery settings and ultilisation" {
         It "$deviceID Battery Charge Cycles" {
            $windowsOSDevice.HardwareInformation.BatteryChargeCycles | Should be "0"
        }
        It "$deviceID Battery Health Percentage" {
            $windowsOSDevice.HardwareInformation.BatteryHealthPercentage | Should be "0"
        }
        It "$deviceID Battery Level Percentage" {
            $windowsOSDevice.HardwareInformation.BatteryLevelPercentage | Should be $null 
        }
        It "$deviceID Battery Serial Number" {
            $windowsOSDevice.HardwareInformation.BatterySerialNumber | Should be $null 
        }
    }
    Context "$deviceID System enclosure settings and ultilisation" {
        It "$deviceID Imei count" {
          $windowsOSDevice.HardwareInformation.Imei.length | Should be "0"
        }
        It "$deviceID Hardware Information Manufacturer " {
            $windowsOSDevice.HardwareInformation.Manufacturer | Should be $null 
        }
        It "$deviceID Hardware Information Meid" {
            $windowsOSDevice.HardwareInformation.Meid | Should be $null 
        }
        It "$deviceID Hardware Information Model" {
            $windowsOSDevice.HardwareInformation.Model | Should be $null 
        }
        It "$deviceID Hardware Information Phone Number" {
            $windowsOSDevice.HardwareInformation.PhoneNumber | Should be $null 
        }
    }
    Context "$deviceID Network details" {
        It "$deviceID Hardware Information SubscriberCarrier" {
            $windowsOSDevice.HardwareInformation.SubscriberCarrier | Should be $null
        }
        It "$deviceID Cellular Technology" {
            $windowsOSDevice.HardwareInformation.CellularTechnology | Should be $null 
        }
        It "$deviceID Hardware Information Wifi Mac" {
            $windowsOSDevice.HardwareInformation.WifiMac | Should be $null
        }
        It "$deviceID WiFi Mac Address length" {
            $windowsOSDevice.WiFiMacAddress.length | Should be @("0", "12")
        }
        It "$deviceID Ethernet Mac Address" {
            $windowsOSDevice.EthernetMacAddress | Should be $null 
        }
        It "$deviceID Wired IPv4 Addresses" {
            $windowsOSDevice.HardwareInformation.WiredIPv4Addresses | Should be $null
        }
        It "$deviceID IP AddressV4" {
            $windowsOSDevice.HardwareInformation.IPAddressV4 | Should be $null 
        }
        It "$deviceID Hardware Information Subnet Address" {
            $windowsOSDevice.HardwareInformation.SubnetAddress | Should be $null
        }
    }
    Context "$deviceID Conditional Access" {
        It "$deviceID Activation Lock Bypass Code" {
            $windowsOSDevice.ActivationLockBypassCode | Should be $null
        }
        It "$deviceID Eas Activated" {
            $windowsOSDevice.EasActivated | Should be "True"
        }
        It "$deviceID Eas Activated" {
            $windowsOSDevice.EasActivated | Should not be "False"
        }
        It "$deviceID Eas Activation Date Time" {
            $windowsOSDevice.EasActivationDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Eas Device Id Length" {
            $windowsOSDevice.EasDeviceId.Length | Should be @("16", "32")
        }
        It "$deviceID Is Supervised - Negative Test" {
            $windowsOSDevice.IsSupervised | Should not be "False"
        }
        It "$deviceID Is Supervised" {
            $windowsOSDevice.HardwareInformation.IsSupervised | Should be "False"
        }
        It "$deviceID Is Supervised - Positive Test" {
            $windowsOSDevice.HardwareInformation.IsSupervised | Should not be "True"
        }
        It "$deviceID Is Encrypted - Negative Test" {
            $windowsOSDevice.HardwareInformation.IsEncrypted | Should be "False"
        } 
        It "$deviceID Is Encrypted - Positive Test" {
            $windowsOSDevice.HardwareInformation.IsEncrypted | Should not be "True"
        } 
        It "$deviceID Is not JailBroken - Positive test" {
            $windowsOSDevice.JailBroken | Should be "False"
        }
        It "$deviceID Is not Jail Broken - Negative Test" {
            $windowsOSDevice.JailBroken | Should not be "True"
        }
        It "$deviceID Is not a Shared Device" {
            $windowsOSDevice.HardwareInformation.IsSharedDevice | Should be "False"
        }
        It "$deviceID Is Shared Device - Negative Test" {
            $windowsOSDevice.HardwareInformation.IsSharedDevice | Should not be "True"
        }
    }
}

Write-Host "`n`n===================== $deviceID Applications System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Applications System Integration Test" {
    Context "Discovered apps" {
        It "$deviceID Auto pilot Enrolled" {
            $windowsOSDevice.AutopilotEnrolled | Should be "True"
        }
        It "$deviceID Auto pilot Enrolled" {
            $windowsOSDevice.AutopilotEnrolled | Should not be "False"
        }
        It "$deviceID Detected Applications" {
            $windowsOSDevice.DetectedApps.Count | Should be 0
        }
        It "$deviceID Detected Application ID" {
            $windowsOSDevice.DetectedApps.Id | Should be $null
        }
        It "$deviceID Detected Apps" {
            $windowsOSDevice.DetectedApps| Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientEnabledFeatures1"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Device Configuration" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.DeviceConfiguration | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Endpoint Protection" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.EndpointProtection | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Inventory" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.Inventory | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features Modern Apps" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.ModernApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Office Apps " {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.OfficeApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - ResourceAccess " {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.ResourceAccess | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Windows Update For Business" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.WindowsUpdateForBusiness | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Additional Properties" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State" {
            $windowsOSDevice.ConfigurationManagerClientHealthState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientHealthState"
        }
        It "$deviceID Configuration Manager Client Health State - Error Code" {
            $windowsOSDevice.ConfigurationManagerClientHealthState.ErrorCode | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Last Sync Date Time" {
            $windowsOSDevice.ConfigurationManagerClientHealthState.LastSyncDateTime | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Status" {
            $windowsOSDevice.ConfigurationManagerClientHealthStateState | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Additional Properties" {
            $windowsOSDevice.ConfigurationManagerClientHealthState.AdditionalProperties.Values | Should be $null
        }  
        It "$deviceID Configuration Manager Client Information - " {
            $windowsOSDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Identifier" {
            $windowsOSDevice.ConfigurationManagerClientInformation.ClientIdentifier | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Version" {
            $windowsOSDevice.ConfigurationManagerClientInformation.ClientVersion | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Is Blocked" {
            $windowsOSDevice.ConfigurationManagerClientInformation.IsBlocked | Should be $null
        }
        It "$deviceID Additional Properties" {
            $windowsOSDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
    }
}

Write-Host "`n`n================== $deviceID Device Compliance System Integration Test ======================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device Compliance System Integration Test" {
    Context "$deviceID meets the defined compliance integration Tests" {
        It "Compliance Grace Period Expiration Date Time" {
            $windowsOSDevice.ComplianceGracePeriodExpirationDateTime | Should belike "*/*/* *:*:*"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Compliance Policy" {
            $windowsOSDevice.ConfigurationManagerClientEnabledFeatures.CompliancePolicy | Should be $null
        }
        It "$deviceID Device Compliance Policy States" {
            $windowsOSDevice.DeviceCompliancePolicyStates | Should be $null 
        }
        It "$deviceID Compliance State" {
            $windowsOSDevice.ComplianceState | Should be "Compliant"
        }
        It "$deviceID Compliance State" {
            $windowsOSDevice.ComplianceState | Should not be "NonCompliant"
        }
    }
}

Write-Host "`n`n================== $deviceID Device Configuration System Integration Test ===================`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device configuration System Integration Test" {
    Context "$deviceID meets the defined configuration integration tests" {   
        It "$deviceID Manufacturer" {
            $windowsOSDevice.Manufacturer | Should be @("Dell Inc.", "Lenovo")
        }
        It "$deviceID Meid Length " {
            $windowsOSDevice.Meid.Length | Should be "0"
        }
        It "$deviceID Model" {
            $windowsOSDevice.Model | Should be @(
            "Latitude 5330", 
            "Cloud PC Enterprise 2vCPU/8GB/128GB",
            "Virtual Machine", 
            "Latitude 5320",
            "Latitude 5300", 
            "Latitude 3490", 
            "Latitude 7480", 
            "OptiPlex 5060", 
            "VMware7,1", 
            "Latitude 7210 2-in-1", 
            "20FES4GM01", 
            "Latitude 5290 2-in-1")
            }
        It "$deviceID Owner Type" {
            $windowsOSDevice.OwnerType | Should be "company"
        }
        It "$deviceID Remote Assistance Session Error Details" {
            $windowsOSDevice.RemoteAssistanceSessionErrorDetails | Should be $null 
        }
        It "$deviceID Remote Assistance Session Url" {
            $windowsOSDevice.RemoteAssistanceSessionUrl | Should be $null 
        }
        It "$deviceID Enrolled Date Time" {
            $windowsOSDevice.EnrolledDateTime | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID RequireUser Enrollment Approval" {
            $windowsOSDevice.RequireUserEnrollmentApproval | Should be $true
        }
        It "$deviceID Retire After Date Time" {
            $windowsOSDevice.RetireAfterDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Role Scope Tag Ids" {
            $windowsOSDevice.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Security Baseline States" {
            $windowsOSDevice.SecurityBaselineStates | Should be $null 
        }
        It "$deviceID Serial Number length" {
            $windowsOSDevice.SerialNumber.Length | Should be @("7", "8")
        }
        It "$deviceID User Display Name count " {
            $windowsOSDevice.UserDisplayName.count | Should be 1
        }
        It "$deviceID User Id" {
            $windowsOSDevice.UserId | Should belike "*-*-*-*"
        }
        It "$deviceID User Principal Name " {
            $windowsOSDevice.UserPrincipalName | Should belike "*@defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Additional Properties" {
            $windowsOSDevice.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Configuration States" {
            $windowsOSDevice.DeviceConfigurationStates | Should be $null 
        }
        It "$deviceID Device Enrollment Type" {
            $windowsOSDevice.DeviceEnrollmentType | Should be "windowsAzureADJoin"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $windowsOSDevice.DeviceFirmwareConfigurationInterfaceManaged | Should be "False"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $windowsOSDevice.DeviceFirmwareConfigurationInterfaceManaged | Should not be "True"
        }
        It "$deviceID Device Category" {
            $windowsOSDevice.DeviceCategory | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceCategory1"
        }
        It "$deviceID Device Category - Description" {
            $windowsOSDevice.DeviceCategory.Description | Should be $null
        }
        It "$deviceID Device Category - DisplayName" {
            $windowsOSDevice.DeviceCategory.DisplayName | Should be $null
        }
        It "$deviceID Device Category - Id" {
            $windowsOSDevice.DeviceCategory.Id | Should be $null
        }
        It "$deviceID Device Category Role Scope Tag Ids" {
            $windowsOSDevice.DeviceCategory.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Device Category Additional Properties " {
            $windowsOSDevice.DeviceCategory.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Category Display Name" {
            $windowsOSDevice.DeviceCategoryDisplayName | Should be "Unknown"
        }
        It "$deviceID Windows Pe" {
            $windowsOSDevice.DeviceHealthAttestationState.WindowsPe | Should be $null
        }
        It "$deviceID Additional Properties" {
            $windowsOSDevice.DeviceHealthAttestationState.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Registration State" {
            $windowsOSDevice.DeviceRegistrationState | Should be "registered"
        }
        It "$deviceID Device Registration State" {
            $windowsOSDevice.DeviceRegistrationState | Should not be "unregistered"
        }
        It "$deviceID Device Type" {
            $windowsOSDevice.DeviceType | Should be "windowsRT"
        }
    }
    Context "$deviceID meets the defined Mail System Integration Tests" {
        It "$deviceID Email Address" {
            $windowsOSDevice.EmailAddress | Should belike "*defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Exchange Access State" {
            $windowsOSDevice.ExchangeAccessState | Should be "none"
        }
        It "$deviceID Exchange Access State Reason" {
            $windowsOSDevice.ExchangeAccessStateReason | Should be "none"
        }
        It "$deviceID Exchange Last Successful Sync Date Time" {
            $windowsOSDevice.ExchangeLastSuccessfulSyncDateTime | Should be "01/01/0001 00:00:00"
        }
    }
}

Write-Host "`n`n================== $deviceID Group Membership System Integration Test =====================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Group Membership System Integration Test" {
    Context "$deviceID meets the defined Device Management Integration Test" { 
        It "$deviceID Managed Device Owner Type" {
            $windowsOSDevice.ManagedDeviceOwnerType | Should be "company"
        }
        It "$deviceID Management Agent" {
            $windowsOSDevice.ManagementAgent | Should be "mdm"
        }
        It "$deviceID Management Certificate ExpirationDate" {
            $windowsOSDevice.ManagementCertificateExpirationDate | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID ManagementFeatures" {
            $windowsOSDevice.ManagementFeatures | Should be "none"
        }
        It "$deviceID ManagementState" {
            $windowsOSDevice.ManagementState | Should be "managed"
    }
}
  Context "$deviceID meets the defined Azure Active Directory Integration tests" { 
        It "$deviceID Azure Ad Registered" {
            $windowsOSDevice.AzureAdRegistered | Should be "True"
        }
        It "$deviceID Azure Ad Registered" {
            $windowsOSDevice.AzureAdRegistered | Should not be "False"
        }
        It "$deviceID Join Type" {
            $windowsOSDevice.JoinType | Should be "azureADJoined"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $windowsOSDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $windowsOSDevice.AzureAdDeviceId.Length | Should be 36
        }
        It "$deviceID Azure AdDevice Id" {
            $windowsOSDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure AdDevice Id" {
            $windowsOSDevice.AzureAdDeviceId.Length | Should belike 36
        }
        It "$deviceID Android Azure Device Registration" {
            $windowsOSDevice.AzureADRegistered | Should be "True"
        }
        It "$deviceID Android Azure Device Registration" {
            $windowsOSDevice.AzureADRegistered | Should not be "False"
        }
        It "$deviceID Prefer Mdm Over Group Policy Applied Date Time" {
            $windowsOSDevice.PreferMdmOverGroupPolicyAppliedDateTime | Should be "01/01/0001 00:00:00"
        }
    }
    Context "$deviceID meets the defined Device Integration Configuration Status tests" {
        It "$deviceID Assignment Filter Evaluation Status Details" {
            $windowsOSDevice.AssignmentFilterEvaluationStatusDetails | Should be $null
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $windowsOSDevice.BootstrapTokenEscrowed | Should be "False"
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $windowsOSDevice.BootstrapTokenEscrowed | Should not be "True"
        }
        It "$deviceID Chassis Type" {
            $windowsOSDevice.ChassisType | Should be "unknown"
        }
        It "$deviceID Chrome OS Device Info" {
            $windowsOSDevice.ChromeOSDeviceInfo | Should be $null
        }
        It "$deviceID Cloud Pc Remote Action Results" {
            $windowsOSDevice.CloudPcRemoteActionResults | Should be $null
        }
        It "$deviceID Device Action Results" {
            $windowsOSDevice.DeviceActionResults | Should be $null
        }
    }
}

Write-Host "`n`n======================= $deviceID Security System Integration Test ==========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Security System Integration Test" {
  Context "$deviceID meets the defined meets the defined Security Integration Tests " {
    It "$deviceID Partner Reported Threat State" {
      $windowsOSDevice.PartnerReportedThreatState | Should be "unknown"
        }
        It "$deviceID Windows Active Malware Count should be zero" {
            $windowsOSDevice.WindowsActiveMalwareCount | Should be "0"
        }
        It "$deviceID Windows Active Malware Count should be less than 1" {
            $windowsOSDevice.WindowsActiveMalwareCount | Should not be "1"
        }
        It "$deviceID Windows Protection State graph definition should be correctly defined" {
            $windowsOSDevice.WindowsProtectionState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphWindowsProtectionState"
        }
        It "$deviceID Windows Protection State Anti Malware Version should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateAntiMalwareVersion | Should be $null
        }
        It "$deviceID Windows Protection State Detected Malware State should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateDetectedMalwareState | Should be $null
        }
        It "$deviceID Windows Protection State Device State should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateDeviceState | Should be $null
        }
        It "$deviceID Windows Protection State Engine Version should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateEngineVersion | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Overdue should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateFullScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Required should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateFullScanRequired | Should be $null
        }
        It "$deviceID Windows Protection State Id should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateId | Should be $null
        }
        It "$deviceID Windows Protection States Virtual Machine should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStatesVirtualMachine | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan Date Time should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan - Signature Version should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State Last Quick Scan - Date Time should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Last Reported Date/Time should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateLastReportedDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Malware Protection Enabled should not be set" {
            $windowsOSDevice.WindowsProtectionState.WindowsProtectionStateMalwareProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Network Inspection System Enabled should not be set" {
            $windowsOSDevice.WindowsProtectionStateNetworkInspectionSystemEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Product Status should not be set" {
            $windowsOSDevice.WindowsProtectionStateProductStatus | Should be $null
        }
        It "$deviceID Windows Protection State - Quick Scan Overdue should not be set" {
            $windowsOSDevice.WindowsProtectionStateQuickScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Real Time Protection Enabled should not be set" {
            $windowsOSDevice.WindowsProtectionStateRealTimeProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Reboot Required should not be set" {
            $windowsOSDevice.WindowsProtectionStateRebootRequired | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Update Overdue should not be set" {
            $windowsOSDevice.WindowsProtectionStateSignatureUpdateOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $windowsOSDevice.WindowsProtectionStateSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Tamper Protection Enabled should not be set" {
            $windowsOSDevice.WindowsProtectionStateTamperProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Additional Properties should not be set" {
            $windowsOSDevice.WindowsProtectionStateAdditionalProperties | Should be $null
        }
        It "$deviceID Windows Remediated Malware Count should be 'Zero'" {
            $windowsOSDevice.WindowsRemediatedMalwareCount | Should be 0
        }
        It "$deviceID Windows Remediated Malware Count should not be more than 0" {
            $windowsOSDevice.WindowsRemediatedMalwareCount | Should belessthan 1
        }
        It "$deviceID Device Health Attestation State Graph Path should be correctly defined" {
            $windowsOSDevice.DeviceHealthAttestationState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceHealthAttestationState"
        }
        It "$deviceID Attestation Identity Key should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.AttestationIdentityKey | Should be $null 
        }
        It "$deviceID Bit Locker Status should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.BitLockerStatus | Should be $null 
        }
        It "$deviceID Boot App Security Version should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.BootAppSecurityVersion | Should be $null 
        }
        It "$deviceID Boot Debugging should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.BootDebugging | Should be $null 
        }
        It "$deviceID Boot Manager Security Version should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.BootManagerSecurityVersion | Should be $null
        }
        It "$deviceID Boot Manager Version should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.BootManagerVersion | Should be $null
        }
        It "$deviceID Boot Revision List Info should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.BootRevisionListInfo | Should be $null
        }
        It "$deviceID Code Integrity should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.CodeIntegrity | Should be $null
        }
        It "$deviceID Device Health Attestation State Code Integrity Check Version should not be set" {  
            $windowsOSDevice.DeviceHealthAttestationState.CodeIntegrityCheckVersion | Should be $null
        }
        it "$deviceid Code Integrity Policy should not be set" {
            $windowsOSDevice.CodeIntegrityPolicy | Should be $null
        }
        It "$deviceID Content Namespace Url should not be set" {
            $windowsOSDevice.ContentNamespaceUrl | Should be $null
        }
        It "$deviceID Content Version should not be set" {
            $windowsOSDevice.ContentVersion | Should be $null
        }
        It "$deviceID Data Excution Policy should not be set" {
            $windowsOSDevice.DataExcutionPolicy | Should be $null
        }
        It "$deviceID Device Health Attestation Status should not be set" {
            $windowsOSDevice.DeviceHealthAttestationStatus | Should be $null
        }
        It "$deviceID Early Launch Anti Malware Driver Protection should not be set" {
            $windowsOSDevice.EarlyLaunchAntiMalwareDriverProtection | Should be $null
        }
        It "$deviceID Health Attestation Supported Status should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.HealthAttestationSupportedStatus | Should be $null
        }
        It "$deviceID Health Status Mismatch Info should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.HealthStatusMismatchInfo | Should be $null
        }
        It "$deviceID Issued Date Time should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.IssuedDateTime | Should be $null
        }
        It "$deviceID Last Update Date Time should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.LastUpdateDateTime | Should be $null
        }
        It "$deviceID Operating System Kernel Debugging should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.OperatingSystemKernelDebugging | Should be $null
        }
        It "$deviceID Operating System Rev List Info should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.OperatingSystemRevListInfo | Should be $null
        }
        It "$deviceID Pcr 0 should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.Pcr0 | Should be $null
        }
        It "$deviceID Pcr Hash Algorithm should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.PcrHashAlgorithm | Should be $null
        }
        It "$deviceID Reset Count should be null" {
            $windowsOSDevice.DeviceHealthAttestationState.ResetCount | Should be $null
        }
        It "$deviceID Restart Count should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.RestartCount | Should be $null
        }
        It "$deviceID Safe Mode should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.SafeMode | Should be $null
        }
        It "$deviceID Secure Boot should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.SecureBoot | Should be $null
        }
        It "$deviceID Secure Boot Configuration Policy Finger Print should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.SecureBootConfigurationPolicyFingerPrint | Should be $null
        }
        It "$deviceID Test Signing should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.TestSigning | Should be $null
        }
        It "$deviceID Tpm Version should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.TpmVersion  | Should be $null
        }
        It "$deviceID Virtual Secure Mode should not be set" {
            $windowsOSDevice.DeviceHealthAttestationState.VirtualSecureMode | Should be $null
        } 
        It "$deviceID The device IsEncrypted state should be true" {
            $windowsOSDevice.IsEncrypted | Should be "True"
        }
        It "$deviceID The device IsEncrypted state should not be false" {
            $windowsOSDevice.IsEncrypted | Should not be "False"
        }
        It "$deviceID The last sync date time should have been in the last 3 months" {
            $windowsOSDevice.LastSyncDateTime | Should begreaterthan (Get-Date).AddDays(-90)
        }
        It "$deviceID Lost mode state should be disabled" {
            $windowsOSDevice.LostModeState | Should be "disabled"
        }
        It "$deviceID Lost mode state should not be enabled" {
            $windowsOSDevice.LostModeState | Should not be "enabled"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Positive Test" {
            $windowsOSDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should be "running"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Negative Test" {
            $windowsOSDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should not be "stopped"
        }
        It "$deviceID Device Guard Virtualization Based Security Hardware RequirementState" {
            $windowsOSDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityHardwareRequirementState | Should be "meetHardwareRequirements"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Positive Test" {
            $windowsOSDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should be "running"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Negative Test" {
            $windowsOSDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should not be "stopped"
        }     

Write-Host "`n`n====================== $deviceID System Integration Test Complete ===========================n`n"
Start-Sleep -Seconds 1
Write-Host "Green = Tested Passed" -ForegroundColor Green
Write-Host "Red = Test Failed. See comments for details. The line number refers to the script line number which failed`n" -ForegroundColor Red 
  }
}