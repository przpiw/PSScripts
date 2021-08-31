$users = Get-ADUser -Filter {UserPrincipalName -Like "* *"} -SearchBase ",OU=Staff,OU=myOU,DC=domain,DC=com"
foreach($user in $users){ Set-ADUser $user -userPrincipalName ($user.UserPrincipalName -replace '\s+',"")}
