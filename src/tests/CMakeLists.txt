#################################################################
# TESTS
#################################################################

FILE(GLOB_RECURSE TESTS_SRC *.f90 *.F90)
SET(TESTS_SRC ${TESTS_SRC} PARENT_SCOPE)

#################################################################
# EXTERNAL LIBRARIES
#################################################################

FOREACH(TEST_SRC ${TESTS_SRC})
    GET_FILENAME_COMPONENT(EXE_NAME ${TEST_SRC} NAME_WE)
    ADD_EXECUTABLE(${EXE_NAME} ${TEST_SRC})
    TARGET_LINK_LIBRARIES(${EXE_NAME} ${LIB})
    FOREACH (EXT_LIB ${EXT_LIBS})
        IF(DEFINED ${PROJECT_NAME}_ENABLE_${EXT_LIB} AND ${PROJECT_NAME}_ENABLE_${EXT_LIB} AND ${EXT_LIB}_FOUND)
            TARGET_LINK_LIBRARIES(${EXE_NAME} ${${EXT_LIB}_LIBRARIES})
        ENDIF()
    ENDFOREACH()
    ADD_TEST(NAME ${EXE_NAME}_TEST COMMAND ${EXECUTABLE_OUTPUT_PATH}/${EXE_NAME} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
ENDFOREACH()

