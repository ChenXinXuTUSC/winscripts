cmake_minimum_required(VERSION 3.21)
project(msvctest)
message("build system: ${CMAKE_SYSTEM_NAME}")
message("${CMAKE_CURRENT_BINARY_DIR}")
set(CMAKE_CXX_STANDARD 17)
set(CAMKE_C_STANDARD 17)

option(USE_SHARED_LIB "use shared library" OFF)
option(USE_STATIC_LIB "use static library" OFF)
if((USE_SHARED_LIB AND USE_STATIC_LIB) OR (NOT USE_SHARED_LIB AND NOT USE_STATIC_LIB))
    message(FATAL_ERROR "invalid lib type")
endif()

set(shared_lib_suffix )
set(static_lib_suffix )
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(shared_lib_suffix "dll")
    set(static_lib_suffix "lib")
elseif(CMAKE_SYSTEM_NAME STREQUAL "LInux")
    set(shared_lib_suffix "so")
    set(static_lib_suffix "a")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(shared_lib_suffix "dylib")
    set(static_lib_suffix "a") # different from the static lib type on Linux
else()
    message(FATAL_ERROR "unimplemented ${CMAKE_SYSTEM_NAME}")
endif()


if(NOT CMAKE_BUILD_TYPE)
    # in vscode settings, turn on the cmake option:
    # "cmake.setBuildTypeOnMultiConfig": true
    # set(CMAKE_BUILD_TYPE Debug)
    if(MSVC)
        message(WARNING 
            "generator is MSVC, it provides more configurations other than "
            "`Debug` and `Release`, please check the build type manually."
        )
    endif()
    message(FATAL_ERROR "no build type chosen")
endif()
string(TOUPPER ${CMAKE_BUILD_TYPE} BUILD_TYPE_UPPERCASE)
add_definitions(-D"BUILD_TYPE_${BUILD_TYPE_UPPERCASE}")


# compiler settings and definitions
message("compiler tool chain: ${CMAKE_CXX_COMPILER_ID} and ${CMAKE_C_COMPILER_ID}")
if(MSVC)
    message("generator is MSVC and symbols will be exported to a .lib along with .dll")
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()
add_definitions(-D"CXX_COMPILER_ID_${CMAKE_CXX_COMPILER_ID}")
add_definitions(-D"C_COMPILER_ID_${CMAKE_C_COMPILER_ID}")


set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install/${CMAKE_BUILD_TYPE})
# MSVC will automatically add a {config} sub-directory after the target
# to get rid of this, ref:
# https://stackoverflow.com/questions/47175912/using-cmake-how-to-stop-the-debug-and-release-subdirectories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin) # binary executable
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin) # shared library
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib) # static library
if(NOT MSVC)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}) # binary executable
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}) # shared library
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}) # static library
endif(NOT MSVC)



# additional useful macros(functions)
include(${PROJECT_SOURCE_DIR}/cmake/macro.cmake)

# find include
set(include_list )
set(
    include_search_path_list
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/include/box2d
    ${PROJECT_SOURCE_DIR}/include/SFML
)
foreach(search_path ${include_search_path_list})
    find_header_dir_atend(${search_path} return_list "")
    include_directories(${return_list})
    list(APPEND include_list ${return_list})
endforeach(search_path ${include_search_path_list})
install(
    DIRECTORY ${PROJECT_SOURCE_DIR}/include
    DESTINATION ${CMAKE_INSTALL_PREFIX}
    FILES_MATCHING PATTERN "*.h;*.hpp"
)
print_list("${include_list}" "INCLUDE" "")


# find library
set(
    library_search_path_list
    ${PROJECT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE}
    ${PROJECT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE}/box2d
    ${PROJECT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE}/sfml
)
link_directories(${library_search_path_list})
include(${PROJECT_SOURCE_DIR}/import.cmake)

# build source dependencies and all applications
add_subdirectory(${PROJECT_SOURCE_DIR}/src)
add_subdirectory(${PROJECT_SOURCE_DIR}/test)
add_subdirectory(${PROJECT_SOURCE_DIR}/app)
