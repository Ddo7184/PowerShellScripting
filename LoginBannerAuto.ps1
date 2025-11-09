# LOGINBANNER AUTO
#
# David Do, tested on Windows Server 2019, and VSCode 
#
#
# This is a simple .ps1 script that automates the creation of a login banner on an endpoint level.
#
# I will be working to implement PowerShell automation for login banners on a domain level with GPOs and 
# eventually add this or the GPO version of it to a catch all script that can be launched to knock #out the simpler injects.
#
# Please test and verify the script can function correctly with PowerShell ISE(Admin) in a non-production environment.
# If the script breaks, please inform me of what happened, preferrably with screenshots of errors.

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name legalnoticecaption -Value "AUTHORIZED USE ONLY"

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name legalnoticetext -Value "This system is for authorized use only. Unauthorized access is prohibited and may be subject to monitoring and prosecution. By using this system, you consent to such monitoring."

gpupdate /force
