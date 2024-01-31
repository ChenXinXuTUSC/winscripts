file(GLOB_RECURSE test_list *.cpp *.c)
print_list("${test_list}" "TEST" "")
foreach(test ${test_list})
    get_filename_component(out ${test} NAME_WE)
    add_executable(${out} ${test})
    target_link_libraries(${out} src)
    
    install(
        TARGETS ${out}
        RUNTIME
        DESTINATION bin
    )
endforeach()

