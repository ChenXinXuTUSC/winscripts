CMAKE_MINIMUM_REQUIRED(VERSION 3.19)
PROJECT(test)

# SET(CMAKE_BUILD_TYPE "Debug")
SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_C_STANDARD   17)

IF(WIN32)
    # clang does not support __float128 type, which is  supported
    # by GNU GCC/G++, to eliminate this lint error, an additional
    # define macro is needed.
    ADD_DEFINITIONS(-D__STRICT_ANSI__)
ENDIF()

# some useful macros(functions)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/macro.cmake)

SET(header_dirs )
# use the following form to search your own header file paths:
#   FIND_HEADER_DIRECTORIES(path/to/your/headers return_list "")
#   LIST(APPEND header_dirs ${return_list})

FIND_HEADER_DIRECTORIES(${PROJECT_SOURCE_DIR}/include return_list "")
LIST(APPEND header_dirs ${return_list})
# LIST(APPEND header_dirs ${PROJECT_SOURCE_DIR}/include)

INCLUDE_DIRECTORIES(${header_dirs})
PRINT_LIST_ITEM("${header_dirs}" "HEADER LIST" "")


OPTION(USE_SHARED_LIB "use shared library" OFF)
OPTION(USE_STATIC_LIB "use static library" OFF)
IF(USE_SHARED_LIB AND USE_STATIC_LIB)
    MESSAGE(FATAL_ERROR "must choose a lib type from static and dynamic")
    RETURN()
ENDIF()
IF(NOT USE_SHARED_LIB AND NOT USE_STATIC_LIB)
    MESSAGE(FATAL_ERROR "must choose a lib type from static and dynamic")
    RETURN()
ENDIF()

IF(USE_STATIC_LIB)
    SET(LIB_TYPE "STATIC")
ELSE()
    SET(LIB_TYPE "SHARED")
ENDIF()

SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib/generate/${CMAKE_BUILD_TYPE}/${LIB_TYPE})
UNSET(LIB_DIRS CACHE)
SET(LIB_DIRS )
GET_ALL_SUBDIRS(${PROJECT_SOURCE_DIR}/lib result)
LIST(APPEND LIB_DIRS ${result})
# GET_ALL_SUBDIRS(${PROJECT_SOURCE_DIR}/runtimelib result)
# LIST(APPEND LIB_DIRS ${result})
LIST(APPEND LIB_DIRS ${PROJECT_SOURCE_DIR}/lib) # add the lib dir itself
LINK_DIRECTORIES(${LIB_DIRS})


SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/${LIB_TYPE})

IF(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
	ADD_DEFINITIONS(-DDEBUG)
ENDIF()

ADD_SUBDIRECTORY(${PROJECT_SOURCE_DIR}/src)
ADD_SUBDIRECTORY(${PROJECT_SOURCE_DIR}/app)

INSTALL(
    FILES ${PROJECT_SOURCE_DIR}/README.md
    DESTINATION ${PROJECT_SOURCE_DIR}/doc
)
