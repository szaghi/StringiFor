include(GNUInstallDirs)

SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/tests/${CMAKE_INSTALL_BINDIR}")

function(add_stringifor_doctest test_src libraries)
    get_filename_component(test_name ${test_src} NAME_WE)
    get_filename_component(test_dir ${test_src} DIRECTORY)

    add_executable(${test_name} ${test_src})
    foreach(lib IN LISTS libraries)
        target_link_libraries(${test_name} ${lib})
    endforeach()
    if (${test_name} STREQUAL "stringifor_test_parse_large_csv" OR ${test_name} STREQUAL "stringifor_test_csv_naive_parser")
        message(${test_name} , " needs special testing")
        return()
    endif()
    add_test(NAME ${test_name} COMMAND ${test_name})

    set(result_src "${test_dir}/${test_name}.result")

    file(STRINGS ${result_src} result_raw)
    string(REGEX REPLACE "([+.])([^+.]*)" "\\\\\\1\\2" result ${result_raw})

    set_tests_properties(${test_name} PROPERTIES
        PASS_REGULAR_EXPRESSION "${result}"
    )
endfunction()

file(GLOB_RECURSE stringifor_doctests *.f90)

foreach(stringifor_doctest IN LISTS stringifor_doctests)
    add_stringifor_doctest(${stringifor_doctest} StringiFor BeFoR64 PENF FACE)
endforeach()
