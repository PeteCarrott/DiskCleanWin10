# show  free disk space
$diskSpace = [ScriptBlock]::Create({
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" |
    Select-Object Size,FreeSpace

    $free = [Math]::Round($Disk.Freespace / 1GB)
    Write-Host "Free Disk Space: $free GB"
})

#Specify what to clean via registry values
$regSage = [ScriptBlock]::Create({
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -Name StateFlags0420 -Value 2
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files' -Name StateFlags0420 -Value 2
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin' -Name StateFlags0420 -Value 2
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files' -Name StateFlags0420 -Value 2
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files' -Name StateFlags0420 -Value 2
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files' -Name StateFlags0420 -Value 2
})


Invoke-Command -ScriptBlock $diskSpace
Invoke-Command -ScriptBlock $regSage

Write-Host "Running disk cleanup, this might take a while, please wait..." -ForegroundColor Yellow

Start-Process cleanmgr.exe -ArgumentList "/sagerun:0420" -Wait

Invoke-Command -ScriptBlock $diskSpace
