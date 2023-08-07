# find all subdirectories
MACRO(GET_ALL_SUBDIRS target_dir result)
    SET(result ${target_dir})
    FILE(
        GLOB_RECURSE items 
        LIST_DIRECTORIES true 
        ${target_dir}/*
    )

    FOREACH(item ${items})
        IF(IS_DIRECTORY ${item})
            LIST(APPEND result ${item})
        ENDIF()
    ENDFOREACH()
ENDMACRO()

# find all include directories
MACRO(FIND_HEADER_DIRECTORIES target_dir return_list exclude_path_pattern)
    UNSET(dir_list CACHE)
	FILE(
        GLOB_RECURSE dir_list
        ${target_dir}/*.h ${target_dir}/*.hpp
    )
	SET(return_list )
	FOREACH(file_path ${dir_list})
		GET_FILENAME_COMPONENT(dir_path ${file_path} PATH)
        SET(exclude_dirs )
        FOREACH(pattern ${exclude_path_pattern})
            STRING(REGEX MATCHALL ${pattern} exclude_dir ${dir_path})
            LIST(APPEND exclude_dirs ${exclude_dir})
        ENDFOREACH()
        LIST(LENGTH exclude_dirs exclude_mask)
        IF(exclude_mask EQUAL 0)
            LIST(APPEND return_list ${dir_path})
        ENDIF()
	ENDFOREACH()
	LIST(REMOVE_DUPLICATES return_list)
    # LIST(APPEND return_list ${target_dir})
ENDMACRO()

# find all specified libraries
MACRO(GET_LIB_NAME lib_paths return_list)
    SET(return_list )
    FOREACH (lib_path ${lib_paths})
        GET_FILENAME_COMPONENT(lib_name ${lib_path} NAME)
        STRING(REGEX REPLACE ".[0-9A-Za-z_]*\$" "" lib_name ${lib_name}) # remove suffix if it has
        STRING(REGEX REPLACE "^lib" "" lib_name ${lib_name}) # remove "lib" prefix if it has
        GET_FILENAME_COMPONENT(lib_suffix ${lib_path} LAST_EXT)
        IF(NOT lib_suffix)
            MESSAGE("empty lib suffix detected")
            CONTINUE()
        ENDIF()
        IF(NOT(lib_suffix STREQUAL ".a" OR lib_suffix STREQUAL ".so" OR lib_suffix STREQUAL ".lib" OR lib_suffix STREQUAL ".dll"))
            MESSAGE(FATAL_ERROR "lib format '${lib_suffix}' unknown")
            RETURN()
        ENDIF()
        LIST(APPEND return_list ${lib_name})
    ENDFOREACH()
    LIST(REMOVE_DUPLICATES return_list)
ENDMACRO()

# give platform specific library suffix
MACRO(GET_LIB_SUFFIX static_lib_suffix shared_lib_suffix)
    IF(WIN32)
        IF(MINGW)
            SET(static_lib_suffix ".a")
            SET(shared_lib_suffix ".dll")
        ELSEIF(MSVC)
            SET(static_lib_suffix ".lib")
            SET(shared_lib_suffix ".dll")
        ENDIF()
    ELSE()
        SET(static_lib_suffix ".a")
        SET(shared_lib_suffix ".so")
    ENDIF()
ENDMACRO()

# install dynamic libraries to destination
MACRO(INSTALL_SHARED_LIB lib_paths shared_lib_suffix dst_dir)
    SET(to_be_installed )
    FOREACH(lib_path ${lib_paths})
        GET_FILENAME_COMPONENT(lib_post ${lib_path} LAST_EXT)
        IF(${lib_post} STREQUAL ${shared_lib_suffix})
            # note: imported object not generated inside the cmake script
            #       can not be type 'TARGET' to isntall.
            INSTALL(
                FILES ${lib_path}
                DESTINATION ${dst_dir}
            )
            LIST(APPEND to_be_installed ${lib_path})
        ENDIF()
    ENDFOREACH()
	LIST(REMOVE_DUPLICATES to_be_installed)
    IF(to_be_installed)
        MESSAGE("following libraries will be installed to ${dst_dir}")
        PRINT_LIST_ITEM("${to_be_installed}" "TO BE INSTALLED" "")
    ENDIF()
ENDMACRO()

# print list item
FUNCTION(PRINT_LIST_ITEM list_item title prefix)
    IF(NOT list_item OR (list_item STREQUAL ""))
        RETURN()
    ENDIF()
    
    IF(prefix STREQUAL "")
        SET(prefix "│")
    ENDIF()
    MESSAGE("┌────────────────── ${title}")
    FOREACH(item ${list_item})
        MESSAGE("${prefix} ${item}")
    ENDFOREACH()
    MESSAGE("└──────────────────]\n")
ENDFUNCTION()
