# though SrcAllInOne.cmake already provides needed  symbols
# for linking stage, this cmake script provides each module
# standalone library file when `USE_SHARED_LIB` is selected
# thus convenient for redistribution of the certain module.

set(sub_dir_list )
file(GLOB dir_item_list LIST_DIRECTORIES TRUE ${CMAKE_CURRENT_SOURCE_DIR}/*)
foreach(item ${dir_item_list})
    if(IS_DIRECTORY ${item})
        list(APPEND sub_dir_list ${item})
    endif()
endforeach()

set(sub_module_list )
foreach(sub_dir ${sub_dir_list})
    file(
        GLOB_RECURSE sub_dir_src_list
        ${sub_dir}/*.cpp
        ${sub_dir}/*.c
    )
    if(sub_dir_src_list)
        get_filename_component(sub_lib ${sub_dir} NAME_WE)
        list(APPEND sub_module_list ${sub_lib})
        add_library(${sub_lib} ${LIB_TYPE} ${sub_dir_src_list})
        target_compile_definitions(${sub_lib} PRIVATE DLLCOMPILE=1)
        target_link_libraries(${sub_lib} src) # find cross reference to other modules

        if(USE_SHARED_LIB)
            install(
                TARGETS ${sub_lib}
                LIBRARY
                DESTINATION bin
            )
        endif()
        if(USE_STATIC_LIB)
            install(
                TARGETS ${sub_lib}
                ARCHIVE
                DESTINATION lib
            )
        endif()
    endif()
endforeach()

print_list("${sub_module_list}" "MODULE" "")
