file(GLOB_RECURSE app_list *.cpp *.c)
print_list("${app_list}" "APPLICATION" "")

# common library linking
foreach(app ${app_list})
    get_filename_component(out ${app} NAME_WE)
    add_executable(${out} ${app})
    target_link_libraries(${out} src)
    install(
        TARGETS ${out}
        RUNTIME
        DESTINATION bin
    )
endforeach()

# additional library linking
# if using MSVC, an additional .lib attached to
# the .dll shared library is also needed
# https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html

# target_link_libraries(<app> <lib> [<lib> ...])

# if additonal library is shared, remember to install them
# to the binary dir

# install(
#     TARGETS <lib> [<lib> ...]
#     LIBRARY
#     DESTINATION bin
# )
