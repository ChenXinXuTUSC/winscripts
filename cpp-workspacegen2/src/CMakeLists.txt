set(LIB_TYPE )

if(USE_SHARED_LIB)
    set(LIB_TYPE SHARED)
    message("shared dll will be built")
endif()
if(USE_STATIC_LIB)
    set(LIB_TYPE STATIC)
    message("static lib will be built")
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/SrcAllInOne.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/SrcSeperate.cmake)
