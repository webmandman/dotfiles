@echo off 

:: HOW TO LOAD AT STARTUP
:: 1. edit registry: Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Process
:: 2. Add a new String Value record
:: 3. Name should be: AutoRun
:: 4. Data should be: %USERPROFILE%\.dotfiles\.aliases.cmd 
:: Everytime CMD startups it will run this call, effectively calling every command in it.

:: Aliases

DOSKEY alias=code %USERPROFILE%\.dotfiles\.aliases.cmd
DOSKEY ls=dir /B $*

DOSKEY intra=cd C:\Development\sites\psomas-intranet
DOSKEY income=cd C:\Development\sites\psomas-intranet\incomestatements-evolution\reports\customCombiningReact\customCompareReact
DOSKEY api=cd C:\Development\sites\psomas-api 
DOSKEY play=cd C:\Development\playground
DOSKEY sites=cd C:\Development\sites
DOSKEY home=cd C:\users\daniel.mejia

DOSKEY nup=wsl -d NixOS
DOSKEY ndown=wdl -t NixOS 
