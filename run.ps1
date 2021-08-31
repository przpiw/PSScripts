$users = Get-ADUser -Filter {UserPrincipalName -Like "* *"} -SearchBase "OU=Disability Unit,OU=Staff,OU=ADKRPS Users,DC=kellerrdps,DC=sch"
foreach($user in $users){ Set-ADUser $user -userPrincipalName ($user.UserPrincipalName -replace '\s+',"")}
