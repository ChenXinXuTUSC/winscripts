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
mkdir %dist_path%\app
mkdir %dist_path%\src
mkdir %dist_path%\bin
mkdir %dist_path%\include
mkdir %dist_path%\build
mkdir %dist_path%\cmake

mkdir %dist_path%\lib\generate\Debug\SHARED
mkdir %dist_path%\lib\generate\Debug\STATIC
mkdir %dist_path%\lib\generate\Release\SHARED
mkdir %dist_path%\lib\generate\Release\STATIC
xcopy %dist_path%\lib\generate\ %dist_path%\lib\imported\ /s /e /h

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
copy /-Y %curr_path%\.clang-tidy %dist_path%\.clang-tidy