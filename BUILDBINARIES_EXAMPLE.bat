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

SET BINARIES_DIR="./build/Win32"
cmake . -G "%GENERATOR%" -A Win32 -S %SOURCE_DIR% -B %BINARIES_DIR%
cmake --build %BINARIES_DIR% --config debug
cmake --build %BINARIES_DIR% --config release

SET BINARIES_DIR="./build/x64"
cmake . -G "%GENERATOR%" -A x64 -S %SOURCE_DIR% -B %BINARIES_DIR%
cmake --build %BINARIES_DIR% --config debug
cmake --build %BINARIES_DIR% --config release

:: ARM64 needs the "MSVC ARM64 build tools" component of Visual Studio.
:: The assimp viewer is not built for ARM64 because the legacy D3DX9 library is x86/x64 only.
SET BINARIES_DIR="./build/ARM64"
cmake . -G "%GENERATOR%" -A ARM64 -S %SOURCE_DIR% -B %BINARIES_DIR%
cmake --build %BINARIES_DIR% --config debug
cmake --build %BINARIES_DIR% --config release

PAUSE
