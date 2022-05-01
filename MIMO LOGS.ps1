<#
Author: Michael Shirazi
Date: 5/21/2020
Description: This script pulls logs from a remote windows machine and transfers it to a specified directory

#>

Write-Host "
___ ___  ____  ___ ___   ___       _       ___    ____   _____
|   T   Tl    j|   T   T /   \     | T     /   \  /    T / ___/
| _   _ | |  T | _   _ |Y     Y    | |    Y     YY   __j(   \_ 
|  \_/  | |  | |  \_/  ||  O  |    | l___ |  O  ||  T  | \__  T
|   |   | |  | |   |   ||     |    |     T|     ||  l_ | /  \ |
|   |   | j  l |   |   |l     !    |     |l     !|     | \    |
l___j___j|____jl___j___j \___/     l_____j \___/ l___,_j  \___j
"

while($true)
{

# ----- Credentials -- THESE VALUES MUST BE CUSTOMIZED ----------

$pw = Get-Content <# Filepath to your password (Or use read-host)#> | Select-Object -First 1
$un = <#Username#>
$TransferFolder = <# Destination Filepath for the logs#>

#------------------------------------------------

$location = Read-Host "What location do you want?"
$location = $location.padleft(5,'0')
$WhichMIMO = Read-Host "Is this a MIMO 1 or 2"
$NumberofLogs = Read-Host "How many days of MIMO logs do you want?"


#  If file doesn't exist then create one

    if (Test-Path ($TransferFolder + $location))
    {}
    else 
    {    mkdir ($TransferFolder + $location) }

    #  Matching the location # to the IP.            
    if(Get-Content "$TransferFolder\MIMO LISTS\$whichmimo.txt" | Select-String -pattern $location)
    {                  
        Get-Content "$TransferFolder\MIMO LISTS\$whichmimo.txt" |  Select-String -pattern $location | Out-File -FilePath "$TransferFolder\MIMO SCRIPT DATA.txt" -Width 14  
        $ipm = get-content "$TransferFolder\MIMO SCRIPT DATA.txt" | Select-String -Pattern "\d{1,3}(\.\d{1,3}).\d{1,3}"
        # Copies MIMO logs and pastes them into transfer folder   
        net use \\$ipm\c$ /user:$un $pw
        Get-ChildItem \\$ipm\c$\ <#\Log directory on remote machine\ #> | Sort-Object LastWriteTime | Select-Object -Last $NumberofLogs | Copy-Item -Destination ($TransferFolder + $location) -Recurse
        net use /delete \\$ipm\c$ | out-null
    } 
    else
    { 
        Write-Host "This is an invalid location" 
    }
} 

        