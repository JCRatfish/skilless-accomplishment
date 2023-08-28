@echo off
setlocal enabledelayedexpansion

rem Get the directory path of the script being run
set "scriptDir=%~dp0"

rem Set the output file name
set "outputFile=Sounds.lua"
set "AddonName=..AddonName.."

rem Combine script directory with the output file name
set "filePath=%scriptDir%..\Source\%outputFile%"

rem Clear the output file if it already exists
type nul > "%filePath%"

rem Write the Lua table header
echo values = { >> "%filePath%"

rem Loop through all files in the directory
for %%I in ("%scriptDir%\*.*") do (
    set "sfn=%%~nI"
    set "sfp=%%~fI"
    rem Write the Lua table entry for each file
    if /I "%%~nxI" neq "UpdateList.bat" (
        if /I "%%~nxI" neq "%outputFile%" (
            rem Write the Lua table entry for each file
            set "escapedPath=!sfp:%scriptDir%=!"
            echo   !sfn! = "Interface\\AddOns\\!AddonName!\\Media\\!escapedPath!", >> "%filePath%"
        )
    )
)

rem Write the Lua table footer
echo } >> "%filePath%"

endlocal