FILE(GLOB_RECURSE APP_LIST ${PROJECT_SOURCE_DIR}/app/*.cpp ${PROJECT_SOURCE_DIR}/app/*.c)

IF(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
	ADD_DEFINITIONS(-DDEBUG)
ENDIF()


FILE(
    GLOB_RECURSE RUNTIMELIB_LIST
    ${PROJECT_SOURCE_DIR}/runtimelib/${CMAKE_BUILD_TYPE}/${LIB_TYPE}/*${SRCLIB_SUFFIX}
)
LIST(APPEND RUNTIMELIB_LIST ${SRC_LIB})
LIST(REMOVE_DUPLICATES RUNTIMELIB_LIST)
PRINT_LIST_ITEM("${RUNTIMELIB_LIST}" "RUNTIME LIB LIST" "")





FOREACH(app ${APP_LIST})
	GET_FILENAME_COMPONENT(output ${app} NAME_WE)
	ADD_EXECUTABLE(${output} ${app})

	SET(to_be_linked )
    # self runtime libs
	GET_LIB_NAME("${RUNTIMELIB_LIST}" return_list)
    TARGET_LINK_LIBRARIES(${output} ${return_list})
    INSTALL_SHARED_LIB("${RUNTIMELIB_LIST}" ${SHARED_LIB_SUFFIX} ${EXECUTABLE_OUTPUT_PATH})
    LIST(APPEND to_be_linked ${return_list})

	# IF (LIB_LIST)
	# 	FOREACH (lib ${LIB_LIST})
	# 		GET_FILENAME_COMPONENT(lib_name ${lib} NAME)
    #         STRING(REGEX REPLACE ".[0-9A-Za-z_]*\$" "" lib_name ${lib_name})
	# 		GET_FILENAME_COMPONENT(lib_post ${lib} LAST_EXT)
	# 		IF(NOT lib_post)
	# 			MESSAGE(FATAL_ERROR "no lib suffix detected")
    #             RETURN()
	# 		ENDIF()
	# 		IF(NOT(lib_post STREQUAL ".a" OR lib_post STREQUAL ".so" OR lib_post STREQUAL ".lib" OR lib_post STREQUAL ".dll"))
	# 			MESSAGE(FATAL_ERROR "lib format '${lib_post}' unkown")
    #             RETURN()
	# 		ENDIF()
	# 		TARGET_LINK_LIBRARIES(${output} ${lib_name})
            
    #         # also move dynamic libraries to executable dir
    #         IF(${lib_post} STREQUAL ${SHARED_LIB_SUFFIX})
    #             INSTALL(
    #                 # note: imported object not generated inside the cmake script
    #                 #       can not be type 'TARGET' to isntall.
    #                 FILES ${lib}
    #                 DESTINATION ${EXECUTABLE_OUTPUT_PATH}
    #             )
    #         ENDIF()
            
    #         SET(to_be_linked ${to_be_linked} ${lib_name})
	# 	ENDFOREACH()

	# ENDIF()
    MESSAGE("${output} will be linked with: ${to_be_linked}")
ENDFOREACH()
