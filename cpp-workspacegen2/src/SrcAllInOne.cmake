file(
    GLOB_RECURSE src_list
    *.cpp
    *.c
)
print_list("${src_list}" "SOURCE" "")
add_library(src ${LIB_TYPE} ${src_list})

target_link_libraries(src ${imported_shared_lib_name_list})
target_link_libraries(src ${imported_static_lib_name_list})

# install to binary dir for runtime env
if(USE_SHARED_LIB)
    install(
        TARGETS src
        LIBRARY
        DESTINATION bin
    )
endif()
if(USE_STATIC_LIB)
    install(
        TARGETS src
        ARCHIVE
        DESTINATION lib
    )
endif()
