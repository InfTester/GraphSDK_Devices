<#
	.NOTES
========================================================================================================================================================
		Created on: 29.01.2023
      Last Modified: 21.01.2023 
		Created by: Tony Law
		Filename: macOSv1.1.tests.ps1
    Version: 1.1
    Test Level: System Integration
    Devices Type Test Compatibility: MacBook Pro and MacBook Air
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
    Invoke-Pester "C:\TestsScripts\macOSDeviceV1.1.tests.ps1"
    .\macOSDeviceV1.1.tests.ps1
#>

<#
macOS Devices
Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -EQ "macOS" } | Select-Object "model" -Unique
1. MacBook Pro
2. MacBook Air

$MacBookPro = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "macOS" -and $_.Model -eq "MacBook Pro"}
$MacBook Air = Get-MgDeviceManagementManagedDevice | Where-Object {$_.OperatingSystem -eq "ios" -and $_.Model -eq "MacBook Air"}

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
$devDetails | Where-Object UserDisplayName -EQ "$user" | Select-Object UserDisplayName, SerialNumber, deviceName, Model, OperatingSystem, OsVersion | ft
Start-Sleep -Seconds 1

do {
    $deviceID = Read-Host -Prompt "Copy and paste the 'Serial Number' from above and then press enter to execute SIT"
} While ($deviceID -notin ($devDetails).SerialNumber)
$macOSDevice = Get-MgDeviceManagementManagedDevice | Where-Object {$_.SerialNumber -eq $deviceID}
}

#Call the User Agreement function,
mgUser-Agreement

mgAccess-MgSDK 

mgMacOS-UserDevice

Write-Host "`n`n===================== $deviceID Hardware System Integration Test ========================n`n"
Start-Sleep -Seconds 1

Describe "`n$deviceID Hardware System Integration Test" {
    Context "$deviceID System Configuration Settings" {
        It "$deviceID Additional Properties" {
            $macOSDevice.HardwareInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Name" {
            $macOSDevice.DeviceName | Should beLike ("*Macbook*")
        }
        It "$deviceID Managed DeviceName" {
            $macOSDevice.ManagedDeviceName | Should belike ("*MacOS*")
        }
        It "$deviceID Hardware Information Serial Number length" {
            $macOSDevice.HardwareInformation.SerialNumber.length | Should be "12"
        }
        It "$deviceID Enrollment Profile Name" {
            $macOSDevice.EnrollmentProfileName | Should be $null 
        }
        It "$deviceID Hardware Information" {
            $macOSDevice.HardwareInformation | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphHardwareInformation"
        }
        It "$deviceID Device Fully Qualified Domain Name" {
            $macOSDevice.HardwareInformation.DeviceFullQualifiedDomainName | Should be $null 
        }
        It "$deviceID Device Licensing Last Error Code" {
            $macOSDevice.HardwareInformation.DeviceLicensingLastErrorCode | Should be "0"
        }
        It "$deviceID Device Licensing LastError Description" {
            $macOSDevice.HardwareInformation.DeviceLicensingLastErrorDescription | Should be $null 
        }
        It "$deviceID Device LicensingStatus" {
            $macOSDevice.HardwareInformation.DeviceLicensingStatus | Should be "unknown"
        }
        It "$deviceID Esim Identifier" {
            $macOSDevice.HardwareInformation.EsimIdentifier | Should be $null 
        } 
        It "$deviceID Hardware Information Operating System Product Type" {
            $macOSDevice.HardwareInformation.OperatingSystemProductType | Should be "0" 
        }
        It "$deviceID Hardware Information Operating System Product Type" {
            $macOSDevice.HardwareInformation.OperatingSystemProductType | Should not be "1" 
        }
        It "$deviceID Hardware Information Product Name" {
            $macOSDevice.HardwareInformation.ProductName | Should be $null 
        }
        It "$deviceID Hardware Information Resident Users Count" {
            $macOSDevice.HardwareInformation.ResidentUsersCount | Should be $null 
        }
        It "$deviceID Hardware Information Serial Number length" {
            $macOSDevice.HardwareInformation.SerialNumber.length | Should be "12"
        }
        It "$deviceID Hardware Information Shared Device Cached Users" {
            $macOSDevice.HardwareInformation.SharedDeviceCachedUsers | Should be $null
        }
        It "$deviceID Hardware Information System Management Bios Version" {
            $macOSDevice.HardwareInformation.SystemManagementBiosVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Manufacturer" {
            $macOSDevice.HardwareInformation.TpmManufacturer | Should be $null
        }
        It "$deviceID Hardware Information Tpm Specification Version" {
            $macOSDevice.HardwareInformation.TpmSpecificationVersion | Should be $null
        }
        It "$deviceID Hardware Information Tpm Version" {
            $macOSDevice.HardwareInformation.TpmVersion | Should be $null
        }
    }
    Context "$deviceID Operating System" {
        It "$deviceID Operating System " {
            $macOSDevice.OperatingSystem | Should be "macOs"
        }
        It "$deviceID OS Version " {
            $macOSDevice.OSVersion | Should be @("13.0.1 (22A400)", "13.0 (22A380)") 
        }
        It "$deviceID Hardware Information OS Build Number" {
            $macOSDevice.HardwareInformation.OSBuildNumber | Should be $null 
        }
        It "$deviceID Hardware Information Operating System Language" {
            $macOSDevice.HardwareInformation.OperatingSystemLanguage | Should be $null 
        }
        It "$deviceID Hardware Information Operating SystemEdition" {
            $macOSDevice.HardwareInformation.OperatingSystemEdition | Should be $null 
        }  
        It "$deviceID Android Security Patch Level" {
            $macOSDevice.AndroidSecurityPatchLevel | Should be ""
        }
    }
     Context "$deviceID Storage settings and ultilisation" {
        It "$deviceID Free Storage Space In Bytes" {
        $minFreeStorage = ($macOSDevice.TotalStorageSpaceInBytes)/1gb/10
        $actualFreeStorage = ($macOSDevice.FreeStorageSpaceInBytes)/1gb
            $actualFreeStorage | Should beGreaterThan $minFreeStorage
        }
        It "$deviceID Free Storage Space" {
            $macOSDevice.HardwareInformation.FreeStorageSpace | Should be "0"
        }
        It "$deviceID HardwareInformation Total Storage Space" {
            $macOSDevice.HardwareInformation.TotalStorageSpace | Should be "0"
        }
        It "$deviceID Hardware Information Total Storage Space" {
            $macOSDevice.HardwareInformation.TotalStorageSpace | Should not be "1"
        }
        It "$deviceID Total Storage Space In Bytes" {
            $macOSDevice.TotalStorageSpaceInBytes | Should be @("268435456000", "263066746880")
        }
    }
    Context "$deviceID Battery settings and ultilisation" {
         It "$deviceID Battery Charge Cycles" {
            $macOSDevice.HardwareInformation.BatteryChargeCycles | Should be "0"
        }
        It "$deviceID Battery Health Percentage" {
            $macOSDevice.HardwareInformation.BatteryHealthPercentage | Should be "0"
        }
        It "$deviceID Battery Level Percentage" {
            $macOSDevice.HardwareInformation.BatteryLevelPercentage | Should be $null 
        }
        It "$deviceID Battery Serial Number" {
            $macOSDevice.HardwareInformation.BatterySerialNumber | Should be $null 
        }
    }
    Context "$deviceID System enclosure settings and ultilisation" {
        It "$deviceID Imei count" {
          $macOSDevice.HardwareInformation.Imei.length | Should be "0"
        }
        It "$deviceID Hardware Information Manufacturer " {
            $macOSDevice.HardwareInformation.Manufacturer | Should be $null 
        }
        It "$deviceID Hardware Information Meid" {
            $macOSDevice.HardwareInformation.Meid | Should be $null 
        }
        It "$deviceID Hardware Information Model" {
            $macOSDevice.HardwareInformation.Model | Should be $null 
        }
        It "$deviceID Hardware Information Phone Number" {
            $macOSDevice.HardwareInformation.PhoneNumber | Should be $null 
        }
    }
    Context "$deviceID Network details" {
        It "$deviceID Hardware Information SubscriberCarrier" {
            $macOSDevice.HardwareInformation.SubscriberCarrier | Should be $null
        }
        It "$deviceID Cellular Technology" {
            $macOSDevice.HardwareInformation.CellularTechnology | Should be $null 
        }
        It "$deviceID Hardware Information Wifi Mac" {
            $macOSDevice.HardwareInformation.WifiMac | Should be $null
        }
        It "$deviceID WiFi Mac Address length" {
            $macOSDevice.WiFiMacAddress.length | Should be "12"
        }
        It "$deviceID Ethernet Mac Address" {
            $macOSDevice.EthernetMacAddress | Should be $null 
        }
        It "$deviceID Wired IPv4 Addresses" {
            $macOSDevice.HardwareInformation.WiredIPv4Addresses | Should be $null
        }
        It "$deviceID IP AddressV4" {
            $macOSDevice.HardwareInformation.IPAddressV4 | Should be $null 
        }
        It "$deviceID Hardware Information Subnet Address" {
            $macOSDevice.HardwareInformation.SubnetAddress | Should be $null
        }
    }
    Context "$deviceID Conditional Access" {
        It "$deviceID Activation Lock Bypass Code" {
            $macOSDevice.ActivationLockBypassCode | Should be $null
        }
        It "$deviceID Eas Activated" {
            $macOSDevice.EasActivated | Should be "False"
        }
        It "$deviceID Eas Activated" {
            $macOSDevice.EasActivated | Should not be "True"
        }
        It "$deviceID Eas Activation Date Time" {
            $macOSDevice.EasActivationDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Eas Device Id" {
            $macOSDevice.EasDeviceId.Length | Should be "16" 
        }
        It "$deviceID Eas Device Id" {
            $macOSDevice.EasDeviceId | Should belike "Appl*" 
        }
        It "$deviceID Is Supervised - Negative Test" {
            $macOSDevice.IsSupervised | Should not be "False"
        }
        It "$deviceID Is Supervised" {
            $macOSDevice.HardwareInformation.IsSupervised | Should be "False"
        }
        It "$deviceID Is Supervised - Positive Test" {
            $macOSDevice.HardwareInformation.IsSupervised | Should not be "True"
        }
        It "$deviceID Is Encrypted - Negative Test" {
            $macOSDevice.HardwareInformation.IsEncrypted | Should be "False"
        } 
        It "$deviceID Is Encrypted - Positive Test" {
            $macOSDevice.HardwareInformation.IsEncrypted | Should not be "True"
        } 
        It "$deviceID Is not JailBroken - Positive test" {
            $macOSDevice.JailBroken | Should be "False"
        }
        It "$deviceID Is not Jail Broken - Negative Test" {
            $macOSDevice.JailBroken | Should not be "True"
        }
        It "$deviceID Is not a Shared Device" {
            $macOSDevice.HardwareInformation.IsSharedDevice | Should be "False"
        }
        It "$deviceID Is Shared Device - Negative Test" {
            $macOSDevice.HardwareInformation.IsSharedDevice | Should not be "True"
        }
    }
}

Write-Host "`n`n===================== $deviceID Applications System Integration Test ========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Applications System Integration Test" {
    Context "Discovered apps" {
        It "$deviceID Auto pilot Enrolled" {
            $macOSDevice.AutopilotEnrolled | Should be "False"
        }
        It "$deviceID Auto pilot Enrolled" {
            $macOSDevice.AutopilotEnrolled | Should not be "True"
        }
        It "$deviceID Detected Applications" {
            $macOSDevice.DetectedApps.Count | Should be 0
        }
        It "$deviceID Detected Application ID" {
            $macOSDevice.DetectedApps.Id | Should be $null
        }
        It "$deviceID Detected Apps" {
            $macOSDevice.DetectedApps| Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientEnabledFeatures1"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Device Configuration" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.DeviceConfiguration | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Endpoint Protection" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.EndpointProtection | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Inventory" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.Inventory | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features Modern Apps" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.ModernApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Office Apps " {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.OfficeApps | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - ResourceAccess " {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.ResourceAccess | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Windows Update For Business" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.WindowsUpdateForBusiness | Should be $null
        }
        It "$deviceID Configuration Manager Client Enabled Features - Additional Properties" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State" {
            $macOSDevice.ConfigurationManagerClientHealthState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphConfigurationManagerClientHealthState"
        }
        It "$deviceID Configuration Manager Client Health State - Error Code" {
            $macOSDevice.ConfigurationManagerClientHealthState.ErrorCode | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Last Sync Date Time" {
            $macOSDevice.ConfigurationManagerClientHealthState.LastSyncDateTime | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Status" {
            $macOSDevice.ConfigurationManagerClientHealthStateState | Should be $null
        }
        It "$deviceID Configuration Manager Client Health State - Additional Properties" {
            $macOSDevice.ConfigurationManagerClientHealthState.AdditionalProperties.Values | Should be $null
        }  
        It "$deviceID Configuration Manager Client Information - " {
            $macOSDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Identifier" {
            $macOSDevice.ConfigurationManagerClientInformation.ClientIdentifier | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Client Version" {
            $macOSDevice.ConfigurationManagerClientInformation.ClientVersion | Should be $null
        }
        It "$deviceID Configuration Manager Client Information - Is Blocked" {
            $macOSDevice.ConfigurationManagerClientInformation.IsBlocked | Should be $null
        }
        It "$deviceID Additional Properties" {
            $macOSDevice.ConfigurationManagerClientInformation.AdditionalProperties.Values | Should be $null
        }
    }
}

Write-Host "`n`n================== $deviceID Device Compliance System Integration Test ======================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device Compliance System Integration Test" {
    Context "$deviceID meets the defined compliance integration Tests" {
        It "Compliance Grace Period Expiration Date Time" {
            $macOSDevice.ComplianceGracePeriodExpirationDateTime | Should belike "*/*/* *:*:*"
        }
        It "$deviceID Configuration Manager Client Enabled Features - Compliance Policy" {
            $macOSDevice.ConfigurationManagerClientEnabledFeatures.CompliancePolicy | Should be $null
        }
        It "$deviceID Device Compliance Policy States" {
            $macOSDevice.DeviceCompliancePolicyStates | Should be $null 
        }
        It "$deviceID Compliance State" {
            $macOSDevice.ComplianceState | Should be "Compliant"
        }
        It "$deviceID Compliance State" {
            $macOSDevice.ComplianceState | Should not be "NonCompliant"
        }
    }
}

Write-Host "`n`n================== $deviceID Device Configuration System Integration Test ===================`n"
Start-Sleep -Seconds 1
Describe "$deviceID Device configuration System Integration Test" {
    Context "$deviceID meets the defined configuration integration tests" {   
        It "$deviceID Manufacturer" {
            $macOSDevice.Manufacturer | Should be "Apple"
        }
        It "$deviceID Meid Length " {
            $macOSDevice.Meid.Length | Should be "0"
        }
        It "$deviceID Model" {
            $macOSDevice.Model | Should be @("Macbook Pro", "Macbook Air")
        }
        It "$deviceID Owner Type" {
            $macOSDevice.OwnerType | Should be "company"
        }
        It "$deviceID Remote Assistance Session Error Details" {
            $macOSDevice.RemoteAssistanceSessionErrorDetails | Should be $null 
        }
        It "$deviceID Remote Assistance Session Url" {
            $macOSDevice.RemoteAssistanceSessionUrl | Should be $null 
        }
        It "$deviceID Enrolled Date Time" {
            $macOSDevice.EnrolledDateTime | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID RequireUser Enrollment Approval" {
            $macOSDevice.RequireUserEnrollmentApproval | Should be $true
        }
        It "$deviceID Retire After Date Time" {
            $macOSDevice.RetireAfterDateTime | Should be "01/01/0001 00:00:00"
        }
        It "$deviceID Role Scope Tag Ids" {
            $macOSDevice.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Security Baseline States" {
            $macOSDevice.SecurityBaselineStates | Should be $null 
        }
        It "$deviceID Serial Number length" {
            $macOSDevice.SerialNumber.Length | Should be "12"
        }
        It "$deviceID User Display Name count " {
            $macOSDevice.UserDisplayName.count | Should be 1
        }
        It "$deviceID User Id" {
            $macOSDevice.UserId | Should belike "*-*-*-*"
        }
        It "$deviceID User Principal Name " {
            $macOSDevice.UserPrincipalName | Should belike "*@defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Additional Properties" {
            $macOSDevice.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Configuration States" {
            $macOSDevice.DeviceConfigurationStates | Should be $null 
        }
        It "$deviceID Device Enrollment Type" {
            $macOSDevice.DeviceEnrollmentType | Should be "appleBulkWithUser"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $macOSDevice.DeviceFirmwareConfigurationInterfaceManaged | Should be "False"
        }
        It "$deviceID Device Firmware Configuration Interface Managed" {
            $macOSDevice.DeviceFirmwareConfigurationInterfaceManaged | Should not be "True"
        }
        It "$deviceID Device Category" {
            $macOSDevice.DeviceCategory | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceCategory1"
        }
        It "$deviceID Device Category - Description" {
            $macOSDevice.DeviceCategory.Description | Should be $null
        }
        It "$deviceID Device Category - DisplayName" {
            $macOSDevice.DeviceCategory.DisplayName | Should be $null
        }
        It "$deviceID Device Category - Id" {
            $macOSDevice.DeviceCategory.Id | Should be $null
        }
        It "$deviceID Device Category Role Scope Tag Ids" {
            $macOSDevice.DeviceCategory.RoleScopeTagIds | Should be $null
        }
        It "$deviceID Device Category Additional Properties " {
            $macOSDevice.DeviceCategory.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Category Display Name" {
            $macOSDevice.DeviceCategoryDisplayName | Should be "Unknown"
        }
        It "$deviceID Windows Pe" {
            $macOSDevice.DeviceHealthAttestationState.WindowsPe | Should be $null
        }
        It "$deviceID Additional Properties" {
            $macOSDevice.DeviceHealthAttestationState.AdditionalProperties.Values | Should be $null
        }
        It "$deviceID Device Registration State" {
            $macOSDevice.DeviceRegistrationState | Should be "registered"
        }
        It "$deviceID Device Registration State" {
            $macOSDevice.DeviceRegistrationState | Should not be "unregistered"
        }
        It "$deviceID Device Type" {
            $macOSDevice.DeviceType | Should be "macMDM"
        }
    }
    Context "$deviceID meets the defined Mail System Integration Tests" {
        It "$deviceID Email Address" {
            $macOSDevice.EmailAddress | Should belike "*defram365e5preproduction.onmicrosoft.com"
        }
        It "$deviceID Exchange Access State" {
            $macOSDevice.ExchangeAccessState | Should be "none"
        }
        It "$deviceID Exchange Access State Reason" {
            $macOSDevice.ExchangeAccessStateReason | Should be "none"
        }
        It "$deviceID Exchange Last Successful Sync Date Time" {
            $macOSDevice.ExchangeLastSuccessfulSyncDateTime | Should be "01/01/0001 00:00:00"
        }
    }
}

Write-Host "`n`n================== $deviceID Group Membership System Integration Test =====================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Group Membership System Integration Test" {
    Context "$deviceID meets the defined Device Management Integration Test" { 
        It "$deviceID Managed Device Owner Type" {
            $macOSDevice.ManagedDeviceOwnerType | Should be "company"
        }
        It "$deviceID Management Agent" {
            $macOSDevice.ManagementAgent | Should be "mdm"
        }
        It "$deviceID Management Certificate ExpirationDate" {
            $macOSDevice.ManagementCertificateExpirationDate | Should begreaterthan (Get-Date).AddDays(-180) 
        }
        It "$deviceID ManagementFeatures" {
            $macOSDevice.ManagementFeatures | Should be "none"
        }
        It "$deviceID ManagementState" {
            $macOSDevice.ManagementState | Should be "managed"
    }
}
  Context "$deviceID meets the defined Azure Active Directory Integration tests" { 
        It "$deviceID Azure Ad Registered" {
            $macOSDevice.AzureAdRegistered | Should be "True"
        }
        It "$deviceID Azure Ad Registered" {
            $macOSDevice.AzureAdRegistered | Should not be "False"
        }
        It "$deviceID Join Type" {
            $macOSDevice.JoinType | Should be "azureADRegistered"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $macOSDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure Active Directory DeviceId" {
            $macOSDevice.AzureAdDeviceId.Length | Should be 36
        }
        It "$deviceID Azure AdDevice Id" {
            $macOSDevice.AzureAdDeviceId | Should belike "*-*-*-*"
        }
        It "$deviceID Azure AdDevice Id" {
            $macOSDevice.AzureAdDeviceId.Length | Should belike 36
        }
        It "$deviceID Android Azure Device Registration" {
            $macOSDevice.AzureADRegistered | Should be "True"
        }
        It "$deviceID Android Azure Device Registration" {
            $macOSDevice.AzureADRegistered | Should not be "False"
        }
        It "$deviceID Prefer Mdm Over Group Policy Applied Date Time" {
            $macOSDevice.PreferMdmOverGroupPolicyAppliedDateTime | Should be "01/01/0001 00:00:00"
    }
}
    Context "$deviceID meets the defined Device Integration Configuration Status tests" {
        It "$deviceID Assignment Filter Evaluation Status Details" {
            $macOSDevice.AssignmentFilterEvaluationStatusDetails | Should be $null
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $macOSDevice.BootstrapTokenEscrowed | Should be "False"
        }
        It "$deviceID Bootstrap Token Escrowed" {
            $macOSDevice.BootstrapTokenEscrowed | Should not be "True"
        }
        It "$deviceID Chassis Type" {
            $macOSDevice.ChassisType | Should be "unknown"
        }
        It "$deviceID Chrome OS Device Info" {
            $macOSDevice.ChromeOSDeviceInfo | Should be $null
        }
        It "$deviceID Cloud Pc Remote Action Results" {
            $macOSDevice.CloudPcRemoteActionResults | Should be $null
        }
        It "$deviceID Device Action Results" {
            $macOSDevice.DeviceActionResults | Should be $null
        }
    }
}

Write-Host "`n`n======================= $deviceID Security System Integration Test ==========================n`n"
Start-Sleep -Seconds 1
Describe "$deviceID Security System Integration Test" {
  Context "$deviceID meets the defined meets the defined Security Integration Tests " {
    It "$deviceID Partner Reported Threat State" {
      $macOSDevice.PartnerReportedThreatState | Should be "unknown"
        }
        It "$deviceID Windows Active Malware Count should be zero" {
            $macOSDevice.WindowsActiveMalwareCount | Should be "0"
        }
        It "$deviceID Windows Active Malware Count should be less than 1" {
            $macOSDevice.WindowsActiveMalwareCount | Should not be "1"
        }
        It "$deviceID Windows Protection State graph definition should be correctly defined" {
            $macOSDevice.WindowsProtectionState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphWindowsProtectionState"
        }
        It "$deviceID Windows Protection State Anti Malware Version should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateAntiMalwareVersion | Should be $null
        }
        It "$deviceID Windows Protection State Detected Malware State should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateDetectedMalwareState | Should be $null
        }
        It "$deviceID Windows Protection State Device State should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateDeviceState | Should be $null
        }
        It "$deviceID Windows Protection State Engine Version should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateEngineVersion | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Overdue should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateFullScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State Full Scan Required should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateFullScanRequired | Should be $null
        }
        It "$deviceID Windows Protection State Id should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateId | Should be $null
        }
        It "$deviceID Windows Protection States Virtual Machine should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStatesVirtualMachine | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan Date Time should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State Last Full Scan - Signature Version should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateLastFullScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State Last Quick Scan - Date Time should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateLastQuickScanSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Last Reported Date/Time should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateLastReportedDateTime | Should be $null
        }
        It "$deviceID Windows Protection State - Malware Protection Enabled should not be set" {
            $macOSDevice.WindowsProtectionState.WindowsProtectionStateMalwareProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Network Inspection System Enabled should not be set" {
            $macOSDevice.WindowsProtectionStateNetworkInspectionSystemEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Product Status should not be set" {
            $macOSDevice.WindowsProtectionStateProductStatus | Should be $null
        }
        It "$deviceID Windows Protection State - Quick Scan Overdue should not be set" {
            $macOSDevice.WindowsProtectionStateQuickScanOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Real Time Protection Enabled should not be set" {
            $macOSDevice.WindowsProtectionStateRealTimeProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Reboot Required should not be set" {
            $macOSDevice.WindowsProtectionStateRebootRequired | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Update Overdue should not be set" {
            $macOSDevice.WindowsProtectionStateSignatureUpdateOverdue | Should be $null
        }
        It "$deviceID Windows Protection State - Signature Version should not be set" {
            $macOSDevice.WindowsProtectionStateSignatureVersion | Should be $null
        }
        It "$deviceID Windows Protection State - Tamper Protection Enabled should not be set" {
            $macOSDevice.WindowsProtectionStateTamperProtectionEnabled | Should be $null
        }
        It "$deviceID Windows Protection State - Additional Properties should not be set" {
            $macOSDevice.WindowsProtectionStateAdditionalProperties | Should be $null
        }
        It "$deviceID Windows Remediated Malware Count should be 'Zero'" {
            $macOSDevice.WindowsRemediatedMalwareCount | Should be 0
        }
        It "$deviceID Windows Remediated Malware Count should not be more than 0" {
            $macOSDevice.WindowsRemediatedMalwareCount | Should belessthan 1
        }
        It "$deviceID Device Health Attestation State Graph Path should be correctly defined" {
            $macOSDevice.DeviceHealthAttestationState | Should be "Microsoft.Graph.PowerShell.Models.MicrosoftGraphDeviceHealthAttestationState"
        }
        It "$deviceID Attestation Identity Key should not be set" {
            $macOSDevice.DeviceHealthAttestationState.AttestationIdentityKey | Should be $null 
        }
        It "$deviceID Bit Locker Status should not be set" {
            $macOSDevice.DeviceHealthAttestationState.BitLockerStatus | Should be $null 
        }
        It "$deviceID Boot App Security Version should not be set" {
            $macOSDevice.DeviceHealthAttestationState.BootAppSecurityVersion | Should be $null 
        }
        It "$deviceID Boot Debugging should not be set" {
            $macOSDevice.DeviceHealthAttestationState.BootDebugging | Should be $null 
        }
        It "$deviceID Boot Manager Security Version should not be set" {
            $macOSDevice.DeviceHealthAttestationState.BootManagerSecurityVersion | Should be $null
        }
        It "$deviceID Boot Manager Version should not be set" {
            $macOSDevice.DeviceHealthAttestationState.BootManagerVersion | Should be $null
        }
        It "$deviceID Boot Revision List Info should not be set" {
            $macOSDevice.DeviceHealthAttestationState.BootRevisionListInfo | Should be $null
        }
        It "$deviceID Code Integrity should not be set" {
            $macOSDevice.DeviceHealthAttestationState.CodeIntegrity | Should be $null
        }
        It "$deviceID Device Health Attestation State Code Integrity Check Version should not be set" {  
            $macOSDevice.DeviceHealthAttestationState.CodeIntegrityCheckVersion | Should be $null
        }
        it "$deviceid Code Integrity Policy should not be set" {
            $macOSDevice.CodeIntegrityPolicy | Should be $null
        }
        It "$deviceID Content Namespace Url should not be set" {
            $macOSDevice.ContentNamespaceUrl | Should be $null
        }
        It "$deviceID Content Version should not be set" {
            $macOSDevice.ContentVersion | Should be $null
        }
        It "$deviceID Data Excution Policy should not be set" {
            $macOSDevice.DataExcutionPolicy | Should be $null
        }
        It "$deviceID Device Health Attestation Status should not be set" {
            $macOSDevice.DeviceHealthAttestationStatus | Should be $null
        }
        It "$deviceID Early Launch Anti Malware Driver Protection should not be set" {
            $macOSDevice.EarlyLaunchAntiMalwareDriverProtection | Should be $null
        }
        It "$deviceID Health Attestation Supported Status should not be set" {
            $macOSDevice.DeviceHealthAttestationState.HealthAttestationSupportedStatus | Should be $null
        }
        It "$deviceID Health Status Mismatch Info should not be set" {
            $macOSDevice.DeviceHealthAttestationState.HealthStatusMismatchInfo | Should be $null
        }
        It "$deviceID Issued Date Time should not be set" {
            $macOSDevice.DeviceHealthAttestationState.IssuedDateTime | Should be $null
        }
        It "$deviceID Last Update Date Time should not be set" {
            $macOSDevice.DeviceHealthAttestationState.LastUpdateDateTime | Should be $null
        }
        It "$deviceID Operating System Kernel Debugging should not be set" {
            $macOSDevice.DeviceHealthAttestationState.OperatingSystemKernelDebugging | Should be $null
        }
        It "$deviceID Operating System Rev List Info should not be set" {
            $macOSDevice.DeviceHealthAttestationState.OperatingSystemRevListInfo | Should be $null
        }
        It "$deviceID Pcr 0 should not be set" {
            $macOSDevice.DeviceHealthAttestationState.Pcr0 | Should be $null
        }
        It "$deviceID Pcr Hash Algorithm should not be set" {
            $macOSDevice.DeviceHealthAttestationState.PcrHashAlgorithm | Should be $null
        }
        It "$deviceID Reset Count should be null" {
            $macOSDevice.DeviceHealthAttestationState.ResetCount | Should be $null
        }
        It "$deviceID Restart Count should not be set" {
            $macOSDevice.DeviceHealthAttestationState.RestartCount | Should be $null
        }
        It "$deviceID Safe Mode should not be set" {
            $macOSDevice.DeviceHealthAttestationState.SafeMode | Should be $null
        }
        It "$deviceID Secure Boot should not be set" {
            $macOSDevice.DeviceHealthAttestationState.SecureBoot | Should be $null
        }
        It "$deviceID Secure Boot Configuration Policy Finger Print should not be set" {
            $macOSDevice.DeviceHealthAttestationState.SecureBootConfigurationPolicyFingerPrint | Should be $null
        }
        It "$deviceID Test Signing should not be set" {
            $macOSDevice.DeviceHealthAttestationState.TestSigning | Should be $null
        }
        It "$deviceID Tpm Version should not be set" {
            $macOSDevice.DeviceHealthAttestationState.TpmVersion  | Should be $null
        }
        It "$deviceID Virtual Secure Mode should not be set" {
            $macOSDevice.DeviceHealthAttestationState.VirtualSecureMode | Should be $null
        } 
        It "$deviceID The device IsEncrypted state should be true" {
            $macOSDevice.IsEncrypted | Should be "True"
        }
        It "$deviceID The device IsEncrypted state should not be false" {
            $macOSDevice.IsEncrypted | Should not be "False"
        }
        It "$deviceID The last sync date time should have been in the last 3 months" {
            $macOSDevice.LastSyncDateTime | Should begreaterthan (Get-Date).AddDays(-90)
        }
        It "$deviceID Lost mode state should be disabled" {
            $macOSDevice.LostModeState | Should be "disabled"
        }
        It "$deviceID Lost mode state should not be enabled" {
            $macOSDevice.LostModeState | Should not be "enabled"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Positive Test" {
            $macOSDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should be "running"
        }
        It "$deviceID Device Guard Local System Authority Credential Guard State  - Negative Test" {
            $macOSDevice.HardwareInformation.DeviceGuardLocalSystemAuthorityCredentialGuardState | Should not be "stopped"
        }
        It "$deviceID Device Guard Virtualization Based Security Hardware RequirementState" {
            $macOSDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityHardwareRequirementState | Should be "meetHardwareRequirements"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Positive Test" {
            $macOSDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should be "running"
        }
        It "$deviceID Device Guard Virtualization Based Security State - Negative Test" {
            $macOSDevice.HardwareInformation.DeviceGuardVirtualizationBasedSecurityState | Should not be "stopped"
        }
        

Write-Host "`n`n====================== $deviceID System Integration Test Complete ===========================n`n"
Start-Sleep -Seconds 1
Write-Host "Green = Tested Passed" -ForegroundColor Green
Write-Host "Red = Test Failed. See comments for details. The line number refers to the script line number which failed`n" -ForegroundColor Red 
  }
}