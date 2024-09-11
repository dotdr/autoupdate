<# Auto update and reboot script 
   run every sunday at 1am
#>

$nw = get-date
$ht = hostname
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptPath
$settings = "$scriptPath\settings.ini"

if (Test-Path $settings) {
	$file = get-content -path $settings
	$file | foreach {
	  $items = $_.split(",")
	  if ($items[0] -eq "st"){$st = $items[1].trim()}
	  if ($items[0] -eq "un"){$un = $items[1].trim()}
	  if ($items[0] -eq "mailserver"){$mailserver = $items[1].trim()}
	  if ($items[0] -eq "rcvr"){$rcvr = $items[1].trim()}
	  if ($items[0] -eq "sender"){$sender = $items[1].trim()}
	}
} else {
	write-host "Not reading settings.ini because it doesnt exist" 6>> $logfile
	write-host "fatal and no-one to tell" 6>> $logfile
	exit -1
}

write-host "Started $nw" 6>> $logfile

# stop any VMs (ignorable error on no vm system)
get-vm | stop-vm -force

#get the actual updates
Set-PSWUSettings -SmtpServer $mailserver -SmtpPort 587 -SmtpSubject "PSWindowsUpdate Report - $ht" -SmtpTo $rcvr -SmtpFrom $sender
Install-WindowsUpdate -MicrosoftUpdate -SendReport -SendHistory -AcceptAll -AutoReboot -Verbose 

#just for testing when you cant get your email to work
# Send-MailMessage -from $sender -to $rcvr -smtpserver $mailserver -Subject "Monthly Reboot - $ht" -body "Completed"

$nw = get-date
write-host "Completed $nw" 6>> $logfile

#wait 60seconds for an automatic reboot, otherwise force it
start-wait -s 60
cmd /c shutdown /r /t 30 /f /y

#end
