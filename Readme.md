### Display Active Users without employeeID
`Get-ADUser -Filter "(EmployeeID -notlike '*') -AND  Enabled -eq 'true'" -Property EmployeeID | Select Name, EmployeeId`
