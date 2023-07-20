@echo off
echo this template automation is for windows  bat
echo if you are using unix-like os, please switch
echo to copy.sh.
echo\

set curr_path=%~dp0
set /p dist_path= please specify the template path: 
if not exist %dist_path% (
    md %dist_path%
)

echo curr_path: %curr_path%
echo dist_path: %dist_path%

echo on
md %dist_path%\app
md %dist_path%\src
md %dist_path%\bin
md %dist_path%\include
md %dist_path%\build
md %dist_path%\cmake

md %dist_path%\lib
md %dist_path%\lib\Debug
md %dist_path%\lib\Debug\SHARED
md %dist_path%\lib\Debug\STATIC
md %dist_path%\lib\Release
md %dist_path%\lib\Release\SHARED
md %dist_path%\lib\Release\STATIC
xcopy %dist_path%\lib %dist_path%\src\runtimelib\ /s /e /h

md %dist_path%\doc
md %dist_path%\.vscode
echo "hello world" > %dist_path%\README.md
echo off

xcopy %curr_path%\.vscode %dist_path%\.vscode\  /s /e /h
xcopy %curr_path%\app %dist_path%\app\  /s /e /h
xcopy %curr_path%\src %dist_path%\src\  /s /e /h
xcopy %curr_path%\include %dist_path%\include\  /s /e /h
xcopy %curr_path%\cmake %dist_path%\cmake\  /s /e /h
copy /-Y %curr_path%\CMakeLists.txt %dist_path%\CMakeLists.txt
