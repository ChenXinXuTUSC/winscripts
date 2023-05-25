#!/bin/bash

echo "this automation is only suitable for bash with version >= 3.0.0"
echo "if your shell doesn't satisfy the condition, you  may  consider"
echo "specifying some paths in the script."
echo "---------------------------------------------------------------"
SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
echo "\${SCRIPT_PATH}=${SCRIPT_PATH}"

read -p "specify a path :" DST_PATH
if  [ ! -n "${DST_PATH}" ] ;then
    echo "didn't choose the path, will create in current working dir..."
    path=$(pwd)
else
    echo "template will be generated in ${DST_PATH}"
fi

if  [ ! -d ${DST_PATH} ] ;then
    mkdir -p ${DST_PATH}
fi

mkdir -p ${DST_PATH}/app
mkdir -p ${DST_PATH}/src
mkdir -p ${DST_PATH}/bin
mkdir -p ${DST_PATH}/lib/Debug/SHARED
mkdir -p ${DST_PATH}/lib/Debug/STATIC
mkdir -p ${DST_PATH}/lib/Release/SHARED
mkdir -p ${DST_PATH}/lib/Release/STATIC
cp -r ${DST_PATH}/lib ${DST_PATH}/runtimelib
mkdir -p ${DST_PATH}/include
mkdir -p ${DST_PATH}/build
mkdir -p ${DST_PATH}/cmake
mkdir -p ${DST_PATH}/doc
mkdir -p ${DST_PATH}/.vscode
touch ${DST_PATH}/README.md

cp ${SCRIPT_PATH}/CMakeLists.txt ${DST_PATH}/CMakeLists.txt
cp -r ${SCRIPT_PATH}/app/ ${DST_PATH}/
cp -r ${SCRIPT_PATH}/src/ ${DST_PATH}/
cp -r ${SCRIPT_PATH}/include/ ${DST_PATH}/
cp -r ${SCRIPT_PATH}/cmake/ ${DST_PATH}/
cp -r ${SCRIPT_PATH}/.vscode/ ${DST_PATH}/
