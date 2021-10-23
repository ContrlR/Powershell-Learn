# First Powershell scripting exersises

write-host 'Hello World!'
$date = read-host -prompt 'What is today's date?'
$name = read-host -prompt 'What is your name?'

write-host "Today is $date  and is the beginning of $name's journey on becoming a powershell expert."

pause

$PI = 3.14
write-host "An estimted value of `$PI is $PI"

pause

New-Item -ItemType "file" -Value 'Write-Host "Hello, welcome back" -foregroundcolor Green ' -Path $Profile.CurrentUserCurrentHost -Force
