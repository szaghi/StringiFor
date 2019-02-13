#################################################################
# Search F90 files recursively in all subdirs
#################################################################

FILE(GLOB_RECURSE TMP_LIB_SRC */src/lib/*.f90 */src/lib/*.F90 */src/lib/*.c)
SET(LIB_SRC ${LIB_SRC} ${TMP_LIB_SRC} PARENT_SCOPE)

