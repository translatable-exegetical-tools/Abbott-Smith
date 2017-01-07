@echo off
rem 
rem  A-S_Common_Scan_Omissions.bat
rem 

set xmlpath=C:\xampp\htdocs\Abbott-Smith
cd %xmlpath%
set xmlname=abbott-smith.tei.xml
set xmlfile=%xmlpath%\%xmlname%

set ucompare="%ProgramFiles%\IDM Computer Solutions\UltraCompare\uc.com" -ne -t 
set ucompareout= -o 

set fccompare=fc /n /l 
set fccompareout=manually replace "compareout" with simple redirection - greater than sign

set compare=%fcccompare%
set compareout=%ucompareout%
set browse=notepad


rem " acc " should be " acc. "
rem " acc," should be " acc.,"
rem " acc)" should be " acc.)"

perl -pi.old -e "s/\s+acc(?<p>[(\s+|\,|\))])/ acc.\1/g" "%xmlfile%" 

del %xmlname%.acc >nul 2>nul
del %xmlname%.acc.out >nul 2>nul
ren %xmlname%.old %xmlname%.acc
%compare% %xmlname% %xmlname%.acc > %xmlname%.acc.out
del %xmlname%.acc >nul 2>nul
echo +++++++++++++++++++++++++++++++++++++++++++++++++
echo +++++++++ Exit %browse% to continue
echo +++++++++++++++++++++++++++++++++++++++++++++++++
%browse% %xmlname%.acc.out

:do_l
rem " in l)" should be " in l.)"

perl -pi.old -e "s/\s+l\)/ l.\)/g" "%xmlfile%" 

del %xmlname%.lll >nul 2>nul
del %xmlname%.l.out >nul 2>nul
ren %xmlname%.old %xmlname%.lll
%compare% %xmlname% %xmlname%.lll > %xmlname%.l.out
del %xmlname%.lll >nul 2>nul
echo +++++++++++++++++++++++++++++++++++++++++++++++++
echo +++++++++ Exit %browse% to continue
echo +++++++++++++++++++++++++++++++++++++++++++++++++
%browse% %xmlname%.l.out

:do_metaph
rem "metapb" should be "metaph"

perl -pi.old -e "s/metapb/metaph/g" "%xmlfile%" 

del %xmlname%.met >nul 2>nul
del %xmlname%.metaph.out >nul 2>nul
ren %xmlname%.old %xmlname%.met
%compare% %xmlname% %xmlname%.met > %xmlname%.metaph.out
del %xmlname%.met >nul 2>nul
echo +++++++++++++++++++++++++++++++++++++++++++++++++
echo +++++++++ Exit %browse% to continue
echo +++++++++++++++++++++++++++++++++++++++++++++++++
%browse% %xmlname%.metaph.out

exit /b
