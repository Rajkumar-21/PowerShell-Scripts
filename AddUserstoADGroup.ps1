# Import active directory module for running AD cmdlets
Import-Module activedirectory
Start-Transcript -path C:\Users\Documents\VMADUsers\Log\log.txt -append
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv 'C:\Users\Documents\users.csv'



#Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers)
{
    #Read user data from each field in each row and assign the data to a variable as below
        
    $Username     = $User.AD_Username
    $email      = $User.user_Email
    $Group     = $User.AD_Security_Group

    #Check to see if the user already exists in AD
    if (Get-ADUser -F {SamAccountName -eq $Username})
    {
         #If user does exist, give a warning
         Add-ADGroupMember -Identity $Group -Member $Username -Verbose
         write-host "username:$Username Group:$Group"
    }
    else
    {
        $results=[PSCustomObject]@{
                AD_Username = $Username
                user_Email=$email
                AD_Security_Group = $Group
                AccountStatus="Forbidden"
            }     
    }
}


Stop-Transcript
