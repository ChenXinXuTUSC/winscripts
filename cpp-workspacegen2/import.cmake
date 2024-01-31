# other third party libraries should be specified manually
# if any of the source file depends on  them,  please  put
# additional libraries in the `lib` folder.

# I manually gather all lib file available in  the  search
# path, but don't worry, only needed part will  be  linked
# to the binary(for static libs).
set(imported_shared_lib_output_dir ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
if(MSVC)
    set(imported_shared_lib_output_dir ${imported_shared_lib_output_dir}/${CMAKE_BUILD_TYPE})
endif(MSVC)
set(imported_shared_lib_name_list )
set(imported_shared_lib_path_list )
foreach(search_path ${library_search_path_list})
    find_lib(${search_path} ${shared_lib_suffix} "" name_list path_list)
    list(APPEND imported_shared_lib_name_list ${name_list})
    list(APPEND imported_shared_lib_path_list ${path_list})
    install( # for debug runtime
        FILES ${path_list}
        DESTINATION ${imported_shared_lib_output_dir}
    )
endforeach(search_path ${library_search_path_list})
list(REMOVE_DUPLICATES imported_shared_lib_name_list)
list(REMOVE_DUPLICATES imported_shared_lib_path_list)
# make imported shared lib as inner target
# https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html
# https://cmake.org/cmake/help/latest/command/foreach.html
foreach(shared_lib_name shared_lib_path IN ZIP_LISTS imported_shared_lib_name_list imported_shared_lib_path_list)
    add_library(${shared_lib_name} SHARED IMPORTED GLOBAL)
    set_property(
        TARGET ${shared_lib_name}
        PROPERTY
        IMPORTED_LOCATION ${shared_lib_path}
    )
    if(MSVC OR WIN32)
        # On Windows, a .dll and its .lib import library may be imported together
        get_filename_component(dir_path ${shared_lib_path} DIRECTORY)
        set_property(
            TARGET ${shared_lib_name}
            PROPERTY
            IMPORTED_IMPLIB ${dir_path}/${shared_lib_name}.lib
        )
    endif(MSVC OR WIN32)
endforeach(shared_lib_name shared_lib_path IN ZIP_LISTS imported_shared_lib_name_list imported_shared_lib_path_list)
print_list("${imported_shared_lib_name_list}" "IMPORTED SHARED LIB" "")
install(
    IMPORTED_RUNTIME_ARTIFACTS ${imported_shared_lib_name_list}
    LIBRARY
    DESTINATION bin
)


set(imported_static_lib_name_list )
set(imported_static_lib_path_list )
foreach(search_path ${library_search_path_list})
    find_lib(${search_path} ${static_lib_suffix} "" name_list path_list)
    list(APPEND imported_static_lib_name_list ${name_list})
    list(APPEND imported_static_lib_path_list ${path_list})
endforeach(search_path ${library_search_path_list})
list(REMOVE_DUPLICATES imported_static_lib_name_list)
list(REMOVE_DUPLICATES imported_static_lib_path_list)
list(REMOVE_ITEM imported_static_lib_name_list ${imported_shared_lib_name_list}) # as MSVC acquire a same name lib along with dll for export
list(REMOVE_ITEM imported_static_lib_path_list ${imported_shared_lib_path_list}) # as MSVC acquire a same name lib along with dll for export
# make imported static lib as inner target
# https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html
# https://cmake.org/cmake/help/latest/command/foreach.html
foreach(static_lib_name static_lib_path ZIP_LISTS imported_static_lib_name_list imported_static_lib_path_list)
    add_library(${static_lib_name} STATIC IMPORTED GLOBAL)
    set_property(
        TARGET ${static_lib_name}
        PROPERTY
        IMPORTED_LOCATION ${static_lib_path}
    )
endforeach(static_lib_name static_lib_path ZIP_LISTS imported_static_lib_name_list imported_static_lib_path_list)
print_list("${imported_static_lib_name_list}" "IMPORTED STATIC LIB" "")
