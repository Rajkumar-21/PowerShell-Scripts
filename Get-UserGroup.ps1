# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Define the path to the CSV file
$users = 'C:\Users\rajkumar\Documents\Owners.csv'

$results = Import-Csv $users | Foreach-Object {
    # Check if the Username column is defined or empty
    if (!$_.Username -or $_.Username -eq '') {
        # Output a message if the username is not defined in the CSV file
        [PSCustomObject]@{
            'Username' = 'not defined'
            'Email' = 'unknown'
            'Group' = 'unknown'
            'Status' = 'not defined in CSV file'
            'Action' = ''
        }
    } else {
        # Get the username and group name from the current row
        $username = $_.Username
        $groupName = $_.Group
        # Get the user object for the current username
        $user = Get-ADUser -Filter {SamAccountName -eq $username}
        if ($user) {
            # Get the email address of the user
            $email = $user.EmailAddress
            $isMember = [bool](Get-ADGroupMember -Identity $groupName -Recursive | Where-Object { $_.SamAccountName -eq $user.SamAccountName })

            # Output the results
            if ($isMember) {
                [PSCustomObject]@{
                    'Username' = $username
                    'Email' = $email
                    'Group' = $groupName
                    'Status' = 'Present'
                }
            } else {
                [PSCustomObject]@{
                    'Username' = $username
                    'Email' = $email
                    'Group' = $groupName
                    'Status' = 'Not Present'
                }
            }
        } else {
            [PSCustomObject]@{
                'Username' = $username
                'Email' = 'unknown'
                'Group' = $groupName
                'Status' = 'unknown'
            }
        }
    }
}

$results | Export-Csv -Path 'C:\Users\rajkumar\Documents\access\OwnersReport.csv' -NoTypeInformation