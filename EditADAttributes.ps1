#Update OU
$OU = "OU=Staff,OU=ADKRPS Users,DC=kellerrdps,DC=sch"
$logfile = "C:\temp\pslogs.txt"


if(![System.IO.File]::Exists($logfile)){
    New-Item -ItemType File -Path $logfile  -Force
}


function replaceUPN{
    Param($replaceWith)
    $users = Get-ADUser -Filter {UserPrincipalName -Like "* *"} -SearchBase $OU
    foreach($user in $users){
        Set-ADUser $user -userPrincipalName ($user.UserPrincipalName -replace '\s+',$replaceWith)
        $result =  ("Replaced UPN " + $user.UserPrincipalName + " with "+  ($user.UserPrincipalName -replace '\s+',"$replaceWith"))
        $result |Out-File $logfile -Append
    }
}

function replaceSAM{
    Param($replaceWith)
    $users = Get-ADUser -Filter {SamAccountName -Like "* *"} -SearchBase $OU | Select -ExpandProperty 'SamAccountName'
    foreach($user in $users){
        Set-ADUser $user -SamAccountName ($user -replace '\s+', $replaceWith)
        $result =  ("Replaced UPN " + $user + " with "+  ($user  -replace '\s+',"$replaceWith"))
        $result |Out-File $logfile -Append
    }
}

function updateGivenName{
     $users = Get-ADUser -Filter {-not(surname -like "*")} -SearchBase $OU
     foreach($user in $users){
        Set-ADUser $user -Surname $user.SamAccountName
        $result =  ("Updated Surname " + $user.surname + " with "+  $user.SamAccountName)
        $result |Out-File $logfile -Append
     }   
}

function updateFirstName{
    $users = Get-ADUser -Filter {-not(givenname -like "*")} -SearchBase $OU
     foreach($user in $users){
        Set-ADUser $user -givenname $user.SamAccountName
        $result =  ("Updated GivenName " + $user.givenname + " with "+ $user.SamAccountName)
        $result |Out-File $logfile -Append
     }
}

#UPN firstname.lastname@domainname
#Replaces space in ADUser UPN with specified character
#replaceUPN "." 

#Replaces space in ADUser SAM with specified character
#replaceSAM "." 

#Replaces ADUser surname with SAMAccountName
#updateGivenName

#Replaces ADUser firstname with SAMAccountName
#updateFirstName
