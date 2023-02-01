# GraphSDK_Devices

# Microsoft Graph SDK Device Test Automation Execution Script

This Repository holds the PowerShell Microsoft Graph SDK Device Test Automation Execution Scripts.  The scripts have been provided to test a single device, which is initially identified, by specifying the user and then the serial number of the device.  The script utilises Microsoft PowerShell and the modules Microsoft Graph SDK and Pester. 

The scripts held within this repository have been thourougly tested with PowerShell Version 5.1.19041.2364, Pester Version 3.4.0 and Microsoft Graph SDK version 1.19.0.

The script will run against an a pre-connected Azure Tenant.  If a session is not established, the script will prompt the user to provide the Tenant details and enter their credentials.  If a different Tenant is to be used, the 'Disconnect-MgGraph' cmdlet should be used, prior to executing the script.

To run this script the user will require delegated access, and will authenticate using their username and password.  The user should be familiar with Microsoft Graph Scopes.  When establishing a session via the script, the user wil have to have been assigned the correct access permissions to correctly execute the scripts.  To validate the scope for the user, run 'Get-MgContext | Select-Object -ExpandProperty Scopes'.

Microsoft Graph Profile - Beta has been used for this script as it provides more fuctions and cmdlets than the default version. This will be automatically loaded when the script executes. 

### Execution Instructions
The following intstructions are run against an Andriod Device. The instructions are the same for all devices, except that you will need to change the script for the appropriate device Operating System.

#### 1.	Execute Script, as per the example within the script.
<img width="800" alt="Picture1a" src="https://github.dxc.com/storage/user/157447/files/cc7f6558-55cd-4808-a371-e81f2206c14d">

#### 2.	Once the script is executed accept the Usage notice.
 <img width="800" alt="Picture1" src="https://github.dxc.com/storage/user/157447/files/44ee7778-bb05-4ded-8680-87006e28f32f">

#### 3.	Select the user, who you would like to test their device, by copying and pasting into the Input field.
<img width="800" alt="Picture2" src="https://github.dxc.com/storage/user/157447/files/f633e69e-21bc-4575-ad0b-699920d3b984">

#### 4.	Once the device details for the user are displayed, enter the device which you would like to test, by copying and pasting the device ‘Serial number’.
 <img width="800" alt="serial" src="https://github.dxc.com/storage/user/157447/files/9458a6cd-d6db-499b-9819-8bdb91a5241f">
  
#### 5.	Once the serial number is added, press 'Enter' to execute the Pester Tests.
<img width="800" alt="Picture4" src="https://github.dxc.com/storage/user/157447/files/1361492f-3b60-4a25-aa17-ee4da3d352dc">

#### 6.	The Serial number of the System Under Test 
System Under Test is identified prior to each area of test as well as the (b) Pester Describe blocks, (c) Blocks and (d) It statements.

  ###### a. SUT Serial Number
<img width="800" alt="Picture5" src="https://github.dxc.com/storage/user/157447/files/4b5d0162-5051-4de3-b30b-ae166b5a2dfe">

  ###### b.	 Pester Describe Block
<img width="800" alt="Picture6" src="https://github.dxc.com/storage/user/157447/files/9ff1d5e8-a9b9-4e99-825c-e96ace8e8ef7">

  ###### c.	 Pester Context blocks 
<img width="800" alt="Picture7" src="https://github.dxc.com/storage/user/157447/files/a94b0182-f248-45de-89d8-dd2497f4b66a">

  ###### d.	 Pester It statement
<img width="800" alt="Picture8" src="https://github.dxc.com/storage/user/157447/files/1eef731b-160b-4fc9-9b69-b075cd32e595">

#### 7. The summary provided, will provied the following details:
  ###### a.	Test Completion with DTG of test.
  ###### b.	Time taken to execute all the tests.
  ###### c.	Tests 
  - Passed:
  - Failed:
  - Skipped:
  - Pending:
  - Inconclusive:
    
<img width="800" alt="Picture9" src="https://github.dxc.com/storage/user/157447/files/f669af90-5184-44d4-a260-a3c9ce0ecab0"> 

#### 8.	A test that passes will diplay the 'It statement' in **Green** text. No further details will be provided.

#### 9.	All Failed tests are visible in **‘Red’** text and a description of the failure is given, with the expected and actual results. 
<img width="800" alt="Picture10" src="https://github.dxc.com/storage/user/157447/files/2f3ce5c8-3d51-42d9-a6b4-da35989954f1">
