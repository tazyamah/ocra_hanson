@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"C:\Ruby23\bin\ruby.exe" "C:/Users/rlearning/Documents/GitHub/ocra_hanson/vendor/bundle/ruby/2.3.0/bin/ocra" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"C:\Ruby23\bin\ruby.exe" "%~dpn0" %*
