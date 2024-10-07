<# setup script for auto updates and reboot #>


## functions
function get-input{
	param($prompt, $default)
	
	$tmp = read-host -prompt $prompt 
	if (($tmp -eq $null) -or ($tmp -eq '')) {
		$tmp = $default
	}
	return $tmp
	
}


## begins
# install nuget and windowsupdate
Install-Module PSWindowsUpdate -Confirm:$false

$ht = hostname
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptPath
$settings = "$scriptPath\settings.ini"
$settingsold = "$scriptPath\settings.old"

if (Test-Path $settings) {
	Copy-Item -path $settings -destination $settingsold
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
	write-host "Not reading settings.ini because it doesnt exist"
}

$st = get-input "Start time eg 01:00? ($st)" $st
$un = get-input  "Username? ($un)" $un
$pw = get-input  "Password? " $pw

$mailserver = get-input "Mailserver? ($mailserver)" $mailserver
$rcvr = get-input  "Receiver? ($rcvr)" $rcvr
$sender = get-input "Sender? ($sender)" $sender

set-content -Path $settings -Value "st, $st"
add-content -Path $settings -Value "un, $un"
add-content -Path $settings -Value "mailserver, $mailserver"
add-content -Path $settings -Value "rcvr, $rcvr"
add-content -Path $settings -Value "sender, $sender"

schtasks /delete /tn "Monthly Reboot" /f
schtasks /create /sc monthly /mo first /d SUN /m * /st $st /rl highest /tn "Monthly Reboot" /tr $scriptPath\start.cmd /ru "$un" /rp "$pw"

$yn = read-host -prompt "Run the task now?"

if ($yn -eq "y" -or $yn -eq "Y") {
	schtasks /run /tn "Monthly Reboot"
	write-host "Task has been started - waiting for status"
	Start-Sleep -Seconds 5
	schtasks /query /tn "Monthly Reboot"
}
write-host "Setup complete"
