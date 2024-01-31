# find all include directories
function(find_header_dir_atend target_dir return_list exclude_path_pattern)
	file(
        GLOB_RECURSE dir_list
        ${target_dir}/*.h
        ${target_dir}/*.hpp
    )
    
	set(item_list ${target_dir})
	foreach(file_path ${dir_list})
		get_filename_component(dir_path ${file_path} PATH)
        set(exclude_dirs )
        foreach(pattern ${exclude_path_pattern})
            string(REGEX MATCHALL ${pattern} exclude_dir ${dir_path})
            list(APPEND exclude_dirs ${exclude_dir})
        endforeach(pattern ${exclude_path_pattern})
        if(NOT exclude_dirs)
            list(APPEND item_list ${dir_path})
        endif(NOT exclude_dirs)
    endforeach(file_path ${dir_list})
    list(REMOVE_DUPLICATES item_list)
    set(return_list ${item_list} PARENT_SCOPE)
endfunction()

# print list item
function(print_list list_item title prefix)
    if(NOT list_item OR (list_item STREQUAL ""))
        return()
    endif()
    message("┌────────────────── ${title}")
    foreach(item ${list_item})
        message("│ ${prefix} ${item}")
    endforeach()
    message("└──────────────────]\n")
endfunction()

# get all libraries' path
function(find_lib_path target_dir lib_suffix exclude_pattern_list return_list )
    unset(return_list CACHE)
    file(
        GLOB_RECURSE lib_path_list
        ${target_dir}/*.${lib_suffix}
    )
    
    set(item_list )
    foreach(lib_path ${lib_path_list})
        get_filename_component(lib_name ${lib_path} NAME_WE)
        set(exclude_match_list )
        foreach(exclude_pattern ${exclude_pattern_list})
            string(REGEX MATCHALL ${exclude_pattern} matched_list ${lib_name})
            list(APPEND exclude_match_list ${matched_list})
        endforeach(exclude_pattern ${exclude_pattern_list})
        if(NOT exclude_match_list)
            list(APPEND item_list ${lib_path})
        endif(NOT exclude_match_list)
    endforeach(lib_path ${lib_path_list})
    list(REMOVE_DUPLICATES item_list)
    set(return_list ${item_list} PARENT_SCOPE)
endfunction()

# get all libraries' name and path
function(find_lib target_dir lib_suffix exclude_pattern_list name_list path_list)
    set(name_list )
    set(path_list )
    find_lib_path("${target_dir}" "${lib_suffix}" "${exclude_pattern_list}" return_list)
    set(path_list ${return_list}) # don't set PARENT_SCOPE here, or result won't be applied in this scope
    foreach(lib_path ${path_list})
        get_filename_component(lib_name ${lib_path} NAME_WE)
        list(APPEND name_list ${lib_name})
    endforeach(lib_path ${path_list})
    set(name_list ${name_list} PARENT_SCOPE)
    set(path_list ${path_list} PARENT_SCOPE)
endfunction(find_lib target_dir lib_suffix exclude_pattern_list name_list path_list)

