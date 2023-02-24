@echo off 

:: Aliases

DOSKEY alias=code %USERPROFILE%\.dotfiles\.aliases.cmd
DOSKEY ls=dir /B $*

DOSKEY intra=cd C:\Development\sites\psomas-intranet
DOSKEY api=cd C:\Development\sites\psomas-api 
DOSKEY play=cd C:\Development\playground
DOSKEY sites=cd C:\Development\sites
