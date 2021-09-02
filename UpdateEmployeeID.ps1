$users = Import-csv C:\temp\students.csv
$OU = "OU=Students,OU=ADKRPS Users,DC=kellerrdps,DC=sch"
$logfile = "C:\temp\pslogs.txt"
$counter = 0 

if(![System.IO.File]::Exists($logfile)){
    New-Item -ItemType File -Path $logfile  -Force
}

function getUserID {
Param([Parameter(Position=0)][string]$first,[Parameter(Position=1)][string]$last)
    foreach ($user in $users)
    {
        if($first -eq $user.firstname -and $last -eq $user.surname){
            return $user.id
        }
    }
}

$usersInAD = Get-ADUser -Filter "EmployeeID -notlike '*'" -Property EmployeeID -SearchBase $OU 
foreach($user in $usersInAD){
   $firstname = $user.givenname
   $surname = $user.surname 
   $id = getUserID -first $firstname -last $surname
   if($id){
    Set-ADUser $user -employeeId $id 
    $result =  ("Added EmployeeID "+ $id+" to "+$user.UserPrincipalName)
    $result |Out-File $logfile -Append
    Write-Host $result
    $counter++
   }
}

Write-Host("Updated "+ $counter+" Users" )


