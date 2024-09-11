::script to get autoreboot.zip

powershell set-executionpolicy -executionpolicy remotesigned -scope localmachine

powershell wget https://github.com/dotdr/autoupdate/autoreboot.zip -outfile autoreboot.zip
powershell expand-archive -force autoreboot.zip .

cd autoreboot

powershell unblock-file setup.ps1
powershell unblock-file autoreboot.ps1

mkdir c:\windows\autoreboot
copy *.* c:\windows\autoreboot

cd c:\windows\autoreboot
powershell .\setup.ps1
