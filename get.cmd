::script to get autoreboot.zip

powershell set-executionpolicy -executionpolicy remotesigned -scope localmachine

powershell wget https://github.com/dotdr/autoupdate/raw/main/autoreboot.ps1 -outfile autoreboot.ps1
powershell wget https://github.com/dotdr/autoupdate/raw/main/setup.ps1 -outfile setup.ps1
powershell wget https://github.com/dotdr/autoupdate/raw/main/startproc.cmd -outfile startproc.cmd

powershell unblock-file setup.ps1
powershell unblock-file autoreboot.ps1

mkdir c:\windows\autoreboot
copy *.* c:\windows\autoreboot

cd c:\windows\autoreboot
powershell .\setup.ps1
