#################################################################
# Gather fortran files list
#################################################################

ADD_SUBDIRECTORY(${LIB_PATH})

MESSAGE("LIBSRC 1: ${LIB_SRC}")

ADD_SUBDIRECTORY(${THIRDPARTY_PATH})

MESSAGE("LIBSRC 2: ${LIB_SRC}")

#################################################################
# Library target
#################################################################
ADD_LIBRARY(${LIB} ${LIB_SRC})

#################################################################
# External libraries
#################################################################
FOREACH(EXT_LIB ${EXT_LIBS})
    IF (${EXT_LIB}_FOUND)
        TARGET_LINK_LIBRARIES(${LIB} ${${EXT_LIB}_LIBRARIES})
    ENDIF()
ENDFOREACH()

SET_TARGET_PROPERTIES(${LIB} PROPERTIES VERSION ${${LIB}_VERSION} SOVERSION ${${LIB}_SOVERSION})
EXPORT(TARGETS ${LIB} APPEND FILE ${PROJECT_BINARY_DIR}/${LIB}Targets.cmake)

