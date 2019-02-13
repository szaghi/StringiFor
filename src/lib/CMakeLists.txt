#################################################################
# Search F90 files recursively in all subdirs
#################################################################

FILE(GLOB_RECURSE TMP_LIB_SRC *.f90 *.F90 *.c)
SET(LIB_SRC ${LIB_SRC} ${TMP_LIB_SRC} PARENT_SCOPE)

