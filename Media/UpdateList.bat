@echo off
setlocal enabledelayedexpansion

rem Get the directory path of the script being run
set "scriptDir=%~dp0"

rem Set the output file name
set "outputFile=Sounds.lua"
set "AddonName=AddonName"  rem Replace with actual AddonName

rem Combine script directory with the output file name
set "filePath=%scriptDir%..\Source\%outputFile%"

rem Clear the output file if it already exists
type nul > "%filePath%"

rem Write the Lua table header
echo local AddonName, AddonTable = ... > "%filePath%"
echo.>> "%filePath%"
echo if not AddonTable.Ace3.Addon then return end >> "%filePath%"
echo.>> "%filePath%"
echo local sounds = { >> "%filePath%"

rem Loop through all files in the directory
for %%I in ("%scriptDir%\*.*") do (
    set "sfn=%%~nI"
    set "sfp=%%~fI"
    rem Write the Lua table entry for each file
    if /I "%%~nxI" neq "UpdateList.bat" (
        if /I "%%~nxI" neq "%outputFile%" (
            rem Write the Lua table entry for each file
            set "escapedPath=!sfp:%scriptDir%=!"
            echo   !sfn! = "!escapedPath!", >> "%filePath%"
        )
    )
)

rem Write the Lua table footer
echo } >> "%filePath%"
echo.>> "%filePath%"
echo function SetSounds() >> "%filePath%"
echo     AddonTable.Ace3.Config.Options.args.sound.values = sounds >> "%filePath%"
echo end >> "%filePath%"
echo.>> "%filePath%"
echo SetSounds() >> "%filePath%"

endlocal