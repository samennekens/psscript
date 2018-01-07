#######################################################
# Powershell Script to bulk import users using a csv file.
# The script can be used for any domain and has no fixed path to a specific csv file.
# The path will be asked by the start of the script. for example: c:\scripts\importusers.csv
# If the path is not correct you will receive a warning.
#
# Editor: Sam Ennekens
#######################################################

Import-Module ActiveDirectory

$CsvLocation = Read-Host "Please enter the path to the csv file"
if(Test-Path $CsvLocation -PathType Leaf)
{ 
$Users = Import-Csv $CsvLocation -Delimiter ","
foreach ($User in $Users)
{
$domainname = (Get-ADDomain).DNSRoot
$Firstname = $User.Firstname
$Lastname = $User.Lastname
$Fullname = $User.Firstname + " " + $User.Lastname
$SAM = $User.SAM
$UPN = $User.Firstname + "." + $User.Lastname + "@" + $domainname
$Password = $User.Password
New-ADUser -Name "$Fullname" -DisplayName "$Fullname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$Firstname" -Surname "$Lastname" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true
}
}
else
{
Write-warning "$Csvlocation does not exist, please try again"
}