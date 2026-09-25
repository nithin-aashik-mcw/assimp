:: This is an example file to generate binaries using Windows Operating System
:: This script is configured to be executed from the source directory

:: Compiled binaries will be placed in BINARIES_DIR\code\CONFIG

:: NOTE
:: The build process will generate a config.h file that is placed in BINARIES_DIR\include
:: This file must be merged with SOURCE_DIR\include
:: You should write yourself a script that copies the files where you want them.
:: Also see: https://github.com/assimp/assimp/pull/2646

SET SOURCE_DIR=.
SET GENERATOR=Visual Studio 17 2022
SET ARCH=%PROCESSOR_ARCHITECTURE%
IF /I "%ARCH%"=="ARM64" SET ARCH=ARM64
IF /I "%ARCH%"=="AMD64" SET ARCH=x64
IF /I "%ARCH%"=="x86" SET ARCH=Win32

SET BINARIES_DIR="./build/%ARCH%"
cmake . -G "%GENERATOR%" -A %ARCH% -S %SOURCE_DIR% -B %BINARIES_DIR%
cmake --build %BINARIES_DIR% --config debug
cmake --build %BINARIES_DIR% --config release

PAUSE
