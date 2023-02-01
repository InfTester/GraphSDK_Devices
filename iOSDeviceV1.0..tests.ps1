<#
	.NOTES
========================================================================================================================================================
		Created on: 15.01.2023
      Last Modified: 25.01.2023 
		Created by: Tony Law
		Filename: iosDeviceV1.0.tests.ps1
    Version: 1.0
    Test Level: System Integration
    Devices Type Test Compatibility: IOS
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
    Invoke-Pester "C:\TestsScripts\android.tests.ps1"
    .\android.tests.ps1
#>

<#
ios Devices
Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -EQ "ios" } | Select-Object "model" -Unique
1. iPad     
2. iPhone XR
3. iPhone SE
4. iPhone 11
5. iPhone 12

$iPad = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios" -and $_.Model -eq "iPad"}
$iPhoneXR = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios" -and $_.Model -eq "iPhone XR"}
$iPhoneSE = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios" -and $_.Model -eq "iPhone SE"}
$iPhone11 = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios" -and $_.Model -eq "iPhone11"}
$iPhone12 = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios" -and $_.Model -eq "iPhone12"}

#>

Write-Host "`n============= THIS PESTER AUTOMATION SCRIPT IS PROVIDED BY THE DXC TEST TEAM =============="
Write-Host "`nHello $env:USERNAME, you are now executing a Pester Test Script, which will connect to an Azure Tenant."
Start-Sleep -seconds 3
Write-Host "`nBy continuing, you agree that you have the appropriate permissions, and have been authorised to do so."
Start-Sleep -Milliseconds 2500
Write-Host "`nIf you are in any doubt, press Ctrl-C to abort!!!! You will only see this message once during script execution`n" -BackgroundColor Green
Start-Sleep -Seconds 2.5
Pause  
Write-Host "`n`n$env:USERNAME, You are now connecting to the Azure Tenant using Microsoft`n" 
Start-Sleep -Seconds 1
Connect-MgGraph 

$mgProf = Get-MgProfile
if (-not($mgProf.Name -eq "beta"))
    {
    Select-MgProfile -Name Beta
    Write-Host "`nInstalling Microsoft Graph Profile 'Beta', this may take a while"
    }

Start-Sleep -Seconds 1
$devDetails = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios"}
Write-Host "`nCollecting device details...."
Start-Sleep -Seconds 1
$devDetails | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "`nCopy and paste the 'Serial Number' from above and then press enter to execute SIT"
} While ($deviceID -notin ($devDetails).SerialNumber)
$iosDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID} 

Write-Host "`n`n===================== $deviceID Hardware System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "`n$deviceID Hardware System Integration Test" {
    Context "$deviceID System Configuration Settings" {
        It "$deviceID Additional Properties" {
            $iosDevice.HardwareInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Name" {
            $iosDevice.DeviceName | Should match "^(iPhone|iPad)-[A-Z0-9]{12,12}$"
        }
        It "$deviceID Managed DeviceName" {
            $iosDevice.ManagedDeviceName | Should match "^[a-z0-9]{8,8}-[a-z0-9]{4,4}-[a-z0-9]{4,4}-[a-z0-9]{4,4}-[a-z0-9]{12,12}_(IPad|IPhone)_[0-9]{1,2}\/[0-9]{1,2}\/20[0-9]{2,2}_[0-9]+:[0-9]+ (AM|PM)$"
        }
        It "$deviceID Hardware Information Serial Number length" {
            $iosDevice.HardwareInformation.SerialNumber.length | Should be "12"
        }
        It "$deviceID Enrollment Profile Name" {
            $iosDevice.EnrollmentProfileName | Should be $null 
        }
        It "$deviceID Hardware Information" {
            $iosDevice.HardwareInformation | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphHardwareInformation"
        }
        It "$deviceID Device Fully Qualified Domain Name" {
            $iosDevice.HardwareInformation.DeviceFullQualifiedDomainName | Should be $null 
        }
        It "$deviceID Device Licensing Last Error Code" {
            $iosDevice.HardwareInformation.DeviceLicensingLastErrorCode | Should be "0"
        }
        It "$deviceID Device Licensing LastError Description" {
            $iosDevice.HardwareInformation.DeviceLicensingLastErrorDescription | Should be $null 
        }
        It "$deviceID Device LicensingStatus" {
            $iosDevice.HardwareInformation.DeviceLicensingStatus | Should be "unknown"
        }
        It "$deviceID Esim Identifier" {
            $iosDevice.HardwareInformation.EsimIdentifier | Should be $null 
        } 
        It "$deviceID Hardware Information Operating System Product Type" {
            $iosDevice.HardwareInformation.OperatingSystemProductType | Should be "0" 
        }
        It "$deviceID Hardware Information Operating System Product Type" {
            $iosDevice.HardwareInformation.OperatingSystemProductType | Should not be "1" 
        }
        It "$deviceID Hardware Information Product Name" {
            $iosDevice.HardwareInformation.ProductName | Should be $null 
        }
        It "$deviceID Hardware Information Resident Users Count" {
            $iosDevice.HardwareInformation.ResidentUsersCount | Should be $null 
        }
        It "$deviceID Hardware Information Serial Number length" {
            $iosDevice.HardwareInformation.SerialNumber.length | Should be "12"
        }
        It "$deviceID Hardware Information Shared Device Cached Users" {
            $iosDevice.HardwareInformation.SharedDeviceCachedUsers | Should be $null
        }
        It "$deviceID Hardware Information System Management Bios Version" {
            $iosDevice.HardwareInformation.SystemManagementBiosVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Manufacturer" {
            $iosDevice.HardwareInformation.TpmManufacturer | Should be $null
        }
        It "$deviceID Hardware Information Tpm Specification Version" {
            $iosDevice.HardwareInformation.TpmSpecificationVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Version" {
            $iosDevice.HardwareInformation.TpmVersion | Should be $null
        }
    }
    Context "$deviceID Operating System" {
        It "$deviceID Operating System " {
            $iosDevice.OperatingSystem | Should be "ios"
        }
        It "$deviceID OS Version " {
            $iosDevice.OSVersion | Should be @("15.6.1", "15.7", "16.1", "16.1.1", "16.1.2", "16.2") 
        }
        It "$deviceID Hardware Information OS Build Number" {
            $iosDevice.HardwareInformation.OSBuildNumber | Should be $null 
        }
        It "$deviceID Hardware Information Operating System Language" {
            $iosDevice.HardwareInformation.OperatingSystemLanguage | Should be $null 
        }
        It "$deviceID Hardware Information Operating SystemEdition" {
            $iosDevice.HardwareInformation.OperatingSystemEdition | Should be $null 
        }  
        It "$deviceID Android Security Patch Level" {
            $iosDevice.AndroidSecurityPatchLevel | Should be ""
        }
    }
     Context "$deviceID Storage settings and ultilisation" {
        It "$deviceID Free Storage Space In Bytes" {
        $minFreeStorage = ($iosDevice.TotalStorageSpaceInBytes)/1gb/10
        $actualFreeStorage = ($iosDevice.FreeStorageSpaceInBytes)/1gb
            $actualFreeStorage | Should beGreaterThan $minFreeStorage
        }
        It "$deviceID Free Storage Space" {
            $iosDevice.HardwareInformation.FreeStorageSpace | Should be "0"
        }
        It "$deviceID HardwareInformation Total Storage Space" {
            $iosDevice.HardwareInformation.TotalStorageSpace | Should be "0"
        }
        It "$deviceID Hardware Information Total Storage Space" {
            $iosDevice.HardwareInformation.TotalStorageSpace | Should not be "1"
        }
        It "$deviceID Total Storage Space In Bytes" {
            $iosDevice.TotalStorageSpaceInBytes | Should be @("5794430976", "34359738368", "68719476736")
        }
    }
    Context "$deviceID Battery settings and ultilisation" {
         It "$deviceID Battery Charge Cycles" {
            $iosDevice.HardwareInformation.BatteryChargeCycles | Should be "0"
        }
        It "$deviceID Battery Health Percentage" {
            $iosDevice.HardwareInformation.BatteryHealthPercentage | Should be "0"
        }
        It "$deviceID Battery Level Percentage" {
            $iosDevice.HardwareInformation.BatteryLevelPercentage | Should be $null 
        }
        It "$deviceID Battery Serial Number" {
            $iosDevice.HardwareInformation.BatterySerialNumber | Should be $null 
        }
    }
    Context "$deviceID System enclosure settings and ultilisation" {
        It "$deviceID Imei count" {
          $iosDevice.HardwareInformation.Imei.length | Should be "15"
        }
        It "$deviceID Hardware Information Manufacturer " {
            $iosDevice.HardwareInformation.Manufacturer | Should be $null 
        }
        It "$deviceID Hardware Information Meid" {
            $iosDevice.HardwareInformation.Meid | Should be $null 
        }
        It "$deviceID Hardware Information Model" {
            $iosDevice.HardwareInformation.Model | Should be $null 
        }
        It "$deviceID Hardware Information Phone Number" {
            $iosDevice.HardwareInformation.PhoneNumber | Should be $null 
        }
    }
    Context "$deviceID Network details" {
        It "$deviceID Hardware Information SubscriberCarrier" {
            $iosDevice.HardwareInformation.SubscriberCarrier | Should be $null
        }
        It "$deviceID Cellular Technology" {
            $iosDevice.HardwareInformation.CellularTechnology | Should be $null 
        }
        It "$deviceID Hardware Information Wifi Mac" {
            $iosDevice.HardwareInformation.WifiMac | Should be $null
        }
        It "$deviceID WiFi Mac Address length" {
            $iosDevice.WiFiMacAddress.length | Should be "12"
        }
        It "$deviceID Ethernet Mac Address" {
            $iosDevice.EthernetMacAddress | Should be $null 
        }
        It "$deviceID Wired IPv4 Addresses" {
            $iosDevice.HardwareInformation.WiredIPv4Addresses | Should be $null
        }
        It "$deviceID IP AddressV4" {
            $iosDevice.HardwareInformation.IPAddressV4 | Should be $null 
        }
        It "$deviceID Hardware Information Subnet Address" {
            $iosDevice.HardwareInformation.SubnetAddress | Should be $null
        }
    }
    Context "$deviceID Conditional Access" {
        It "$deviceID Activation Lock Bypass Code" {
            $iosDevice.ActivationLockBypassCode | Should be $null
        }
        It "$deviceID Eas Activated" {
            $iosDevice.EasActivated | Should be "True"
        }
        It "$deviceID Eas Activated" {
            $iosDevice.EasActivated | Should not be "False"
        }
        It "$deviceID Eas Activation Date Time" {
            $iosDevice.EasActivationDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Eas Device Id" {
            $iosDevice.EasDeviceId.Length | Should be "26" 
        }
        It "$deviceID Is Supervised - Negative Test" {
            $iosDevice.IsSupervised | Should not be "False"
        }
        It "$deviceID Is Supervised" {
            $iosDevice.HardwareInformation.IsSupervised | Should be "False"
        }
        It "$deviceID Is Supervised - Positive Test" {
            $iosDevice.HardwareInformation.IsSupervised | Should not be "True"
        }
        It "$deviceID Is Encrypted - Negative Test" {
            $iosDevice.HardwareInformation.IsEncrypted | Should be "False"
        } 
        It "$deviceID Is Encrypted - Positive Test" {
            $iosDevice.HardwareInformation.IsEncrypted | Should not be "True"
        } 
        It "$deviceID Is not JailBroken - Positive test" {
            $iosDevice.JailBroken | Should be "False"
        }
        It "$deviceID Is not Jail Broken - Negative Test" {
            $iosDevice.JailBroken | Should not be "True"
        }
        It "$deviceID Is not a Shared Device" {
            $iosDevice.HardwareInformation.IsSharedDevice | Should be "False"
        }
        It "$deviceID Is Shared Device - Negative Test" {
            $iosDevice.HardwareInformation.IsSharedDevice | Should not be "True"
        }
    }
}

Write-Host "`n`n===================== $deviceID Applications System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Applications System Integration Test" {
    Context "Discovered apps" {
        It "$deviceID Auto pilot Enrolled" {
            $iosDevice.AutopilotEnrolled | Should be "False"
        }
        It "$deviceID Auto pilot Enrolled" {
            $iosDevice.AutopilotEnrolled | Should not be "True"
        }
        It "$deviceID Detected Applications" {
            $iosDevice.DetectedApps.Count | Should be 0
        }
        It "$deviceID Detected Application ID" {
            $iosDevice.DetectedApps.Id | Should be $null
        }
        It "$deviceID Detected Apps" {
            $iosDevice.DetectedApps| Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientEnabledFeatures1"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Device Configuration" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.DeviceConfiguration | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Endpoint Protection" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.EndpointProtection | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Inventory" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.Inventory | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features Modern Apps" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.ModernApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Office Apps " {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.OfficeApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - ResourceAccess " {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.ResourceAccess | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Windows Update For Business" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.WindowsUpdateForBusiness | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Additional Properties" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State" {
            $iosDevice.ConfigurationManagerClientHealthState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientHealthState"
        }
        It "$deviceID Configuration Manager Client Health State - Error Code" {
            $iosDevice.ConfigurationManagerClientHealthState.ErrorCode | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Last Sync Date Time" {
            $iosDevice.ConfigurationManagerClientHealthState.LastSyncDateTime | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Status" {
            $iosDevice.ConfigurationManagerClientHealthStateState | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Additional Properties" {
            $iosDevice.ConfigurationManagerClientHealthState.AdditionalProperties.Values | Should be $null
        }  
        It "$deviceID Configuration Manager Client Information - " {
            $iosDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Identifier" {
            $iosDevice.ConfigurationManagerClientInformation.ClientIdentifier | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Version" {
            $iosDevice.ConfigurationManagerClientInformation.ClientVersion | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Is Blocked" {
            $iosDevice.ConfigurationManagerClientInformation.IsBlocked | Should be $null
        }
        It "$deviceID Additional Properties" {
            $iosDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
    }
}

Write-Host "`n`n================== $deviceID Device Compliance System Integration Test ======================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device Compliance System Integration Test" {
    Context "$deviceID meets the defined compliance integration Tests" {
        It "Compliance Grace Period Expiration Date Time" {
            $iosDevice.ComplianceGracePeriodExpirationDateTime | Should belike "*/*/* *:*:*"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Compliance Policy" {
            $iosDevice.ConfigurationManagerClientEnabledFeatures.CompliancePolicy | Should be $null
        }
        It "$deviceID Device Compliance Policy States" {
            $iosDevice.DeviceCompliancePolicyStates | Should be $null 
        }
        It "$deviceID Compliance State" {
            $iosDevice.ComplianceState | Should be "Compliant"
        }
        It "$deviceID Compliance State" {
            $iosDevice.ComplianceState | Should not be "NonCompliant"
        }
    }
}

Write-Host "`n`n================== $deviceID Device Configuration System Integration Test ===================`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device configuration System Integration Test" {
    Context "$deviceID meets the defined configuration integration tests" {   
        It "$deviceID Manufacturer" {
            $iosDevice.Manufacturer | Should be "Apple"
        }
        It "$deviceID Meid Length " {
            $iosDevice.Meid.Length | Should be "14"
        }
        It "$deviceID Model" {
            $iosDevice.Model | Should be @("iPad", "iPhone XR", "iPhone SE", "iPhone 11", "iPhone 12")
        }
        It "$deviceID Owner Type" {
            $iosDevice.OwnerType | Should be "company"
        }
        It "$deviceID Remote Assistance Session Error Details" {
            $iosDevice.RemoteAssistanceSessionErrorDetails | Should be $null 
        }
        It "$deviceID Remote Assistance Session Url" {
            $iosDevice.RemoteAssistanceSessionUrl | Should be $null 
        }
        It "$deviceID Enrolled Date Time" {
            $iosDevice.EnrolledDateTime | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID RequireUser Enrollment Approval" {
            $iosDevice.RequireUserEnrollmentApproval | Should be $null 
        }
        It "$deviceID Retire After Date Time" {
            $iosDevice.RetireAfterDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Role Scope Tag Ids" {
            $iosDevice.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Security Baseline States" {
            $iosDevice.SecurityBaselineStates | Should be $null 
        }
        It "$deviceID Serial Number length" {
            $iosDevice.SerialNumber.Length | Should be "12"
        }
        It "$deviceID User Display Name count " {
            $iosDevice.UserDisplayName.count | Should be 1
        }
        It "$deviceID User Id" {
            $iosDevice.UserId | Should belike "*-*-*-*"
        }
        It "$deviceID User Principal Name " {
            $iosDevice.UserPrincipalName | Should belike "*@defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Additional Properties" {
            $iosDevice.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Configuration States" {
            $iosDevice.DeviceConfigurationStates | Should be $null 
        }
        It "$deviceID Device Enrollment Type" {
            $iosDevice.DeviceEnrollmentType | Should be "appleBulkWithUser"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $iosDevice.DeviceFirmwareConfigurationInterfaceManaged | Should be "False"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $iosDevice.DeviceFirmwareConfigurationInterfaceManaged | Should not be "True"
        }
        It "$deviceID Device Category" {
            $iosDevice.DeviceCategory | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceCategory1"
        }
        It "$deviceID Device Category - Description" {
            $iosDevice.DeviceCategory.Description | Should be $null
        }
        It "$deviceID Device Category - DisplayName" {
            $iosDevice.DeviceCategory.DisplayName | Should be $null
        }
        It "$deviceID Device Category - Id" {
            $iosDevice.DeviceCategory.Id | Should be $null
        }
        It "$deviceID Device Category Role Scope Tag Ids" {
            $iosDevice.DeviceCategory.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Device Category Additional Properties " {
            $iosDevice.DeviceCategory.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Category Display Name" {
            $iosDevice.DeviceCategoryDisplayName | Should be "Unknown"
        }
        It "$deviceID Windows Pe" {
            $iosDevice.DeviceHealthAttestationState.WindowsPe | Should be $null
        }
        It "$deviceID Additional Properties" {
            $iosDevice.DeviceHealthAttestationState.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Registration State" {
            $iosDevice.DeviceRegistrationState | Should be "registered"
        }
        It "$deviceID Device Registration State" {
            $iosDevice.DeviceRegistrationState | Should not be "unregistered"
        }
        It "$deviceID Device Type" {
            $iosDevice.DeviceType | Should match "^(iphone|iPad)$"
        }
    }
    Context "$deviceID meets the defined Mail System Integration Tests" {
        It "$deviceID Email Address" {
            $iosDevice.EmailAddress | Should belike "*defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Exchange Access State" {
            $iosDevice.ExchangeAccessState | Should be "none"
        }
        It "$deviceID Exchange Access State Reason" {
            $iosDevice.ExchangeAccessStateReason | Should be "none"
        }
        It "$deviceID Exchange Last Successful Sync Date Time" {
            $iosDevice.ExchangeLastSuccessfulSyncDateTime | Should be "01/01/0001 00:00:00"
        }
    }
}

Write-Host "`n`n================== $deviceID Group Membership System Integration Test =====================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Group Membership System Integration Test" {
    Context "$deviceID meets the defined Device Management Integration Test" { 
        It "$deviceID Managed Device Owner Type" {
            $iosDevice.ManagedDeviceOwnerType | Should be "company"
        }
        It "$deviceID Management Agent" {
            $iosDevice.ManagementAgent | Should be "mdm"
        }
        It "$deviceID Management Certificate ExpirationDate" {
            $iosDevice.ManagementCertificateExpirationDate | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID ManagementFeatures" {
            $iosDevice.ManagementFeatures | Should be "none"
        }
        It "$deviceID ManagementState" {
            $iosDevice.ManagementState | Should be "managed"
    }
}
  Context "$deviceID meets the defined Azure Active Directory Integration tests" { 
        It "$deviceID Azure Ad Registered" {
            $iosDevice.AzureAdRegistered | Should be "True"
        }
        It "$deviceID Azure Ad Registered" {
            $iosDevice.AzureAdRegistered | Should not be "False"
        }
        It "$deviceID Join Type" {
            $iosDevice.JoinType | Should be "azureADRegistered"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $iosDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $iosDevice.AzureAdDeviceId.Length | Should be 36
        }
        It "$deviceID Azure AdDevice Id" {
            $iosDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure AdDevice Id" {
            $iosDevice.AzureAdDeviceId.Length | Should belike 36
        }
        It "$deviceID Android Azure Device Registration" {
            $iosDevice.AzureADRegistered | Should be "True"
        }
        It "$deviceID Android Azure Device Registration" {
            $iosDevice.AzureADRegistered | Should not be "False"
        }
        It "$deviceID Prefer Mdm Over Group Policy Applied Date Time" {
            $iosDevice.PreferMdmOverGroupPolicyAppliedDateTime | Should be "01/01/0001 00:00:00"
    }
}
    Context "$deviceID meets the defined Device Integration Configuration Status tests" {
        It "$deviceID Assignment Filter Evaluation Status Details" {
            $iosDevice.AssignmentFilterEvaluationStatusDetails | Should be $null
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $iosDevice.BootstrapTokenEscrowed | Should be "False"
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $iosDevice.BootstrapTokenEscrowed | Should not be "True"
        }
        It "$deviceID Chassis Type" {
            $iosDevice.ChassisType | Should be "unknown"
        }
        It "$deviceID Chrome OS Device Info" {
            $iosDevice.ChromeOSDeviceInfo | Should be $null
        }
        It "$deviceID Cloud Pc Remote Action Results" {
            $iosDevice.CloudPcRemoteActionResults | Should be $null
        }
        It "$deviceID Device Action Results" {
            $iosDevice.DeviceActionResults | Should be $null
        }
    }
}

Write-Host "`n`n======================= $deviceID Security System Integration Test ==========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Security System Integration Test" {
  Context "$deviceID meets the defined meets the defined Security Integration Tests " {
    It "$deviceID Partner Reported Threat State" {
      $iosDevice.PartnerReportedThreatState | Should be "unknown"
        }
        It "$deviceID Windows Active Malware Count should be zero" {
            $iosDevice.WindowsActiveMalwareCount | Should be "0"
        }
        It "$deviceID Windows Active Malware Count should be less than 1" {
            $iosDevice.WindowsActiveMalwareCount | Should not be "1"
        }
        It "$deviceID Windows Protection State graph definition should be correctly defined" {
            $iosDevice.WindowsProtectionState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphWindowsProtectionState"
        }
        It "$deviceID Windows Protection State Anti Malware Version should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateAntiMalwareVersion | Should be $null
        }
        It "$deviceID Windows Protection State Detected Malware State should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateDetectedMalwareState | Should be $null
        }
        It "$deviceID Windows Protection State Device State should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateDeviceState | Should be $null
        }
        It "$deviceID Windows Protection State Engine Version should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateEngineVersion | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Overdue should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateFullScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Required should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateFullScanRequired | Should be $null
        }
        It "$deviceID Windows Protection State Id should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateId | Should be $null
        }
        It "$deviceID Windows Protection States Virtual Machine should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStatesVirtualMachine | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan Date Time should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan - Signature Version should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State Last Quick Scan - Date Time should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Last Reported Date/Time should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateLastReportedDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Malware Protection Enabled should not be set" {
            $iosDevice.WindowsProtectionState.WindowsProtectionStateMalwareProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Network Inspection System Enabled should not be set" {
            $iosDevice.WindowsProtectionStateNetworkInspectionSystemEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Product Status should not be set" {
            $iosDevice.WindowsProtectionStateProductStatus | Should be $null
        }
        It "$deviceID Windows Protection State - Quick Scan Overdue should not be set" {
            $iosDevice.WindowsProtectionStateQuickScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Real Time Protection Enabled should not be set" {
            $iosDevice.WindowsProtectionStateRealTimeProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Reboot Required should not be set" {
            $iosDevice.WindowsProtectionStateRebootRequired | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Update Overdue should not be set" {
            $iosDevice.WindowsProtectionStateSignatureUpdateOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $iosDevice.WindowsProtectionStateSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Tamper Protection Enabled should not be set" {
            $iosDevice.WindowsProtectionStateTamperProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Additional Properties should not be set" {
            $iosDevice.WindowsProtectionStateAdditionalProperties | Should be $null
        }
        It "$deviceID Windows Remediated Malware Count should be 'Zero'" {
            $iosDevice.WindowsRemediatedMalwareCount | Should be 0
        }
        It "$deviceID Windows Remediated Malware Count should not be more than 0" {
            $iosDevice.WindowsRemediatedMalwareCount | Should belessthan 1
        }
        It "$deviceID Device Health Attestation State Graph Path should be correctly defined" {
            $iosDevice.DeviceHealthAttestationState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceHealthAttestationState"
        }
        It "$deviceID Attestation Identity Key should not be set" {
            $iosDevice.DeviceHealthAttestationState.AttestationIdentityKey | Should be $null 
        }
        It "$deviceID Bit Locker Status should not be set" {
            $iosDevice.DeviceHealthAttestationState.BitLockerStatus | Should be $null 
        }
        It "$deviceID Boot App Security Version should not be set" {
            $iosDevice.DeviceHealthAttestationState.BootAppSecurityVersion | Should be $null 
        }
        It "$deviceID Boot Debugging should not be set" {
            $iosDevice.DeviceHealthAttestationState.BootDebugging | Should be $null 
        }
        It "$deviceID Boot Manager Security Version should not be set" {
            $iosDevice.DeviceHealthAttestationState.BootManagerSecurityVersion | Should be $null
        }
        It "$deviceID Boot Manager Version should not be set" {
            $iosDevice.DeviceHealthAttestationState.BootManagerVersion | Should be $null
        }
        It "$deviceID Boot Revision List Info should not be set" {
            $iosDevice.DeviceHealthAttestationState.BootRevisionListInfo | Should be $null
        }
        It "$deviceID Code Integrity should not be set" {
            $iosDevice.DeviceHealthAttestationState.CodeIntegrity | Should be $null
        }
        It "$deviceID Device Health Attestation State Code Integrity Check Version should not be set" {  
            $iosDevice.DeviceHealthAttestationState.CodeIntegrityCheckVersion | Should be $null
        }
        it "$deviceid Code Integrity Policy should not be set" {
            $iosDevice.CodeIntegrityPolicy | Should be $null
        }
        It "$deviceID Content Namespace Url should not be set" {
            $iosDevice.ContentNamespaceUrl | Should be $null
        }
        It "$deviceID Content Version should not be set" {
            $iosDevice.ContentVersion | Should be $null
        }
        It "$deviceID Data Excution Policy should not be set" {
            $iosDevice.DataExcutionPolicy | Should be $null
        }
        It "$deviceID Device Health Attestation Status should not be set" {
            $iosDevice.DeviceHealthAttestationStatus | Should be $null
        }
        It "$deviceID Early Launch Anti Malware Driver Protection should not be set" {
            $iosDevice.EarlyLaunchAntiMalwareDriverProtection | Should be $null
        }
        It "$deviceID Health Attestation Supported Status should not be set" {
            $iosDevice.DeviceHealthAttestationState.HealthAttestationSupportedStatus | Should be $null
        }
        It "$deviceID Health Status Mismatch Info should not be set" {
            $iosDevice.DeviceHealthAttestationState.HealthStatusMismatchInfo | Should be $null
        }
        It "$deviceID Issued Date Time should not be set" {
            $iosDevice.DeviceHealthAttestationState.IssuedDateTime | Should be $null
        }
        It "$deviceID Last Update Date Time should not be set" {
            $iosDevice.DeviceHealthAttestationState.LastUpdateDateTime | Should be $null
        }
        It "$deviceID Operating System Kernel Debugging should not be set" {
            $iosDevice.DeviceHealthAttestationState.OperatingSystemKernelDebugging | Should be $null
        }
        It "$deviceID Operating System Rev List Info should not be set" {
            $iosDevice.DeviceHealthAttestationState.OperatingSystemRevListInfo | Should be $null
        }
        It "$deviceID Pcr 0 should not be set" {
            $iosDevice.DeviceHealthAttestationState.Pcr0 | Should be $null
        }
        It "$deviceID Pcr Hash Algorithm should not be set" {
            $iosDevice.DeviceHealthAttestationState.PcrHashAlgorithm | Should be $null
        }
        It "$deviceID Reset Count should be null" {
            $iosDevice.DeviceHealthAttestationState.ResetCount | Should be $null
        }
        It "$deviceID Restart Count should not be set" {
            $iosDevice.DeviceHealthAttestationState.RestartCount | Should be $null
        }
        It "$deviceID Safe Mode should not be set" {
            $iosDevice.DeviceHealthAttestationState.SafeMode | Should be $null
        }
        It "$deviceID Secure Boot should not be set" {
            $iosDevice.DeviceHealthAttestationState.SecureBoot | Should be $null
        }
        It "$deviceID Secure Boot Configuration Policy Finger Print should not be set" {
            $iosDevice.DeviceHealthAttestationState.SecureBootConfigurationPolicyFingerPrint | Should be $null
        }
        It "$deviceID Test Signing should not be set" {
            $iosDevice.DeviceHealthAttestationState.TestSigning | Should be $null
        }
        It "$deviceID Tpm Version should not be set" {
            $iosDevice.DeviceHealthAttestationState.TpmVersion  | Should be $null
        }
        It "$deviceID Virtual Secure Mode should not be set" {
            $iosDevice.DeviceHealthAttestationState.VirtualSecureMode | Should be $null
        } 
        It "$deviceID The device IsEncrypted state should be true" {
            $iosDevice.IsEncrypted | Should be "True"
        }
        It "$deviceID The device IsEncrypted state should not be false" {
            $iosDevice.IsEncrypted | Should not be "False"
        }
        It "$deviceID The last sync date time should have been in the last 3 months" {
            $iosDevice.LastSyncDateTime | Should begreaterthan (Get-Date).AddDays(-90)
        }
        It "$deviceID Lost mode state should be disabled" {
            $iosDevice.LostModeState | Should be "disabled"
        }
        It "$deviceID Lost mode state should not be enabled" {
            $iosDevice.LostModeState | Should not be "enabled"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Positive Test" {
            $iosDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should be "running"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Negative Test" {
            $iosDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should not be "stopped"
        }
        It "$deviceID Device Guard Virtualization Based Security Hardware RequirementState" {
            $iosDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityHardwareRequirementState | Should be "meetHardwareRequirements"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Positive Test" {
            $iosDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should be "running"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Negative Test" {
            $iosDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should not be "stopped"
        }
        

Write-Host "`n`n====================== $deviceID System Integration Test Complete ===========================n`n"
Start-Sleep -Seconds 1
Write-Host "Green = Tested Passed" -ForegroundColor Green
Write-Host "Red = Test Failed. See comments for details. The line number refers to the script line number which failed`n" -ForegroundColor Red 
  }
}