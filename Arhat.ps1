<#
#
# ARHAT
#
# David Do, tested on Windows Server 2019, and VSCode
#
# This is a rough script that is aimed to automate the account hardening section of the Windows killchain for CCDC 2025-26.
# The script works to locally create a HotWork account, and disable any accounts that could be used by threat actors.
# May be retired when I figure out how to push provisoned admin accounts and disable default accounts for the Windows side.
#
# Please test and verify the script can function correctly with PowerShell ISE(Admin) in a non-production environment.
# If the script breaks, please inform me of what happened, preferrably with screenshots of errors.
#
# HotWork Passwords (Feel free to change these when necessary or at your leisure)
#
# AD/DNS: M3tr0-AD-DN$
# Web: M3tr0-W3b
# FTP: M3tr0-4TP
# Workstation: M3tr0-F-W@ll
#
#
#
#
##########################      ____
#########################      /    \
########################      /  ()  \
#######################      |   __   |
######################        \ (__) /
#####################          \____/
####################
###################            __|__
##################            /     \
#################            |  ___  |
################             | |   | |
###############              | |   | |
##############               | |   | |
#############                | |   | |
############                 | |   | |
###########                 /  |   |  \
##########                 /   |   |   \
#########                 /    |   |    \
########                _/     |   |     \_
#######              _/       /     \       \_
######             _/        /       \        \_
#####            /__________/_________\__________\
####                 _/_/_/             \_\_\_
###                 (_____)             (_____)
##                   /   \               /   \
#                   /_____\             /_____\
#
# Arhats are enlightened wanderers, ascetics who’ve mastered both spirit and discipline through years of solitude.
# They possess an aura of serene intensity, able to quell conflict with wisdom or channel fierce inner power when threatened.
# Often depicted in meditation or still vigilance, an Arhat stands as a living bridge between mortal struggle and transcendent peace.
#
#>

Write-Host "Welcome to Arhat, Metro State's account hardening automation for CCDC.`n" -ForegroundColor Magenta
Write-Host "**Make sure you are running this script in a PowerShell or PowerSHell ISE window, and as an Administrator**`n" -ForegroundColor DarkYellow
Write-Host "Enter 'Administrator' or 'HotWork' depending on which account you are currently logged in through.`n" -ForegroundColor White

$RoleValid = $false

while (-not $RoleValid) {
    $Role = Read-Host "Enter your user account name here ('Administrator' or 'HotWork')"

    switch ($Role) {
        "Administrator" {
            $RoleValid = $true
            Write-Host "`nYou selected: Administrator" -ForegroundColor Cyan

            $EndpointValid = $false
            while (-not $EndpointValid) {

                $Endpoint = Read-Host "What is your machine used for?`nEnter 'AD-DNS', 'WEB-SRV', 'FTP-SRV', or 'FW-GUI'"

                switch ($Endpoint) {

                    "AD-DNS" {
                        Write-Host "`nCreating HotWork account for Active Directory Server..." -ForegroundColor White
                        net user HotWork "M3tr0-AD-DN$" /add /passwordreq:yes
                        Write-Host "`nHotWork account created." -ForegroundColor White

                        Write-Host "`nAdding HotWork account to Domain Admins group..." -ForegroundColor White
                        net group "Domain Admins" HotWork /add
                        Write-Host "`nHotWork account added." -ForegroundColor White
                        Write-Host "`nPlease log out of the Administrator account to log in with`nthe HotWork account to run the 'HotWork' option of this script."

                        $EndpointValid = $true
                    }

                    "WEB-SRV" {
                        Write-Host "`nCreating HotWork account for Web Server..." -ForegroundColor White
                        net user HotWork "M3tr0-W3b" /add /passwordreq:yes
                        Write-Host "`nHotWork account created." -ForegroundColor White

                        Write-Host "`nAdding HotWork account to Administrators group..." -ForegroundColor White
                        net localgroup "Administrators" HotWork /add
                        Write-Host "`nHotWork account added." -ForegroundColor White
                        Write-Host "`nPlease log out of the Administrator account to log in with`nthe HotWork account to run the 'HotWork' option of this script."

                        $EndpointValid = $true
                    }

                    "FTP-SRV" {
                        Write-Host "`nCreating HotWork account for FTP Server..." -ForegroundColor White
                        net user HotWork "M3tr0-4TP" /add /passwordreq:yes
                        Write-Host "`nHotWork account created." -ForegroundColor White

                        Write-Host "`nAdding HotWork account to Administrators group..." -ForegroundColor White
                        net localgroup "Administrators" HotWork /add
                        Write-Host "`nHotWork account added." -ForegroundColor White
                        Write-Host "`nPlease log out of the Administrator account to log in with`nthe HotWork account to run the 'HotWork' option of this script."

                        $EndpointValid = $true
                    }

                    "FW-GUI" {
                        Write-Host "`nCreating HotWork account for Firewall Workstation..." -ForegroundColor White
                        net user HotWork "M3tr0-F-W@ll" /add /passwordreq:yes
                        Write-Host "`nHotWork account created." -ForegroundColor White

                        Write-Host "`nAdding HotWork account to Administrators group..." -ForegroundColor White
                        net localgroup "Administrators" HotWork /add
                        Write-Host "`nHotWork account added." -ForegroundColor White
                        Write-Host "`nPlease log out of the Administrator account to log in with`nthe HotWork account to run the 'HotWork' option of this script."

                        $EndpointValid = $true
                    }

                    default {
                        Write-Host "`nInvalid selection. Please enter 'AD-DNS', 'WEB-SRV', 'FTP-SRV', or 'FW-GUI'." -ForegroundColor Red
                    }
                }
            }
        }

        "HotWork" {
            $RoleValid = $true
            Write-Host "`nYou selected: HotWork" -ForegroundColor Cyan

            Write-Host "`nDisabling Administrator Acount..." -ForegroundColor White
            net user Administrator "M3tr0-Un@cc3ssib13"
            Rename-LocalUser -Name "Administrator" -NewName "DefaultHotWork"
            net user DefaultHotWork /active:no
            Write-Host "Administrator Account Disabled." -ForegroundColor Green

            Write-Host "`nDisabling Guest Account and othe Accounts that may be suspicious..." -ForegroundColor White
            $Keep = "krbtgt","HotWork"

            Get-LocalUser | 
            Where-Object { $Keep -notcontains $_.Name } | 
            Disable-LocalUser

            Write-Host "`nAccounts disabled. If certain accounts need to be used, re-enable them manually." -ForegroundColor White

            Get-LocalUser | Where-Object Enabled | Select-Object Name,Enabled

        }

        default {
            Write-Host "`nInvalid selection. Please type 'Administrator' or 'HotWork'." -ForegroundColor Red
        }
    }
}



