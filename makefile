#!/usr/bin/make
MAKEFLAGS = -j 1

#main building variables
DSRC = src

COMPILER = gnu
ifeq "$(COMPILER)" "gnu"
  FC    = gfortran
  OPTSC = -c -frealloc-lhs -std=f2008 -fall-intrinsics -O2 -D_R16P_SUPPORTED -J $(DMOD)
  OPTSL = -O2 -J $(DMOD)
endif
ifeq "$(COMPILER)" "intel"
  FC    = ifort
  OPTSC = -c -assume realloc_lhs -standard-semantics -std08 -O2 -D_R16P_SUPPORTED -module $(DMOD)
  OPTSL = -O2 -module $(DMOD)
endif
ifeq "$(COMPILER)" "nag"
# nagfor has quad-precision (precision=31 range=291) but not the one demanded by R16P
  FC    = nagfor
  OPTSC = -c -C=array -C=bits -C=calls -C=dangling -C=do -C=intovf -C=present -C=pointer -C=recursion -colour -fpp -f2008 -gline -info -kind=unique -mtrace -nan -O4 -I $(DMOD) -mdir $(DMOD)
  OPTSL = -I $(DMOD)
endif

TESTS = no
ifeq "$(TESTS)" "yes"
  DOBJ = exe/obj/
  DMOD = exe/mod/
  DEXE = exe/
  RULE = .NOTPARALLEL
else
  DOBJ = lib/obj/
  DMOD = lib/mod/
  DEXE = lib/
  RULE = STRINGIFOR
endif
LIBS    =
VPATH   = $(DSRC) $(DOBJ) $(DMOD)
MKDIRS  = $(DOBJ) $(DMOD) $(DEXE)
LCEXES  = $(shell echo $(EXES) | tr '[:upper:]' '[:lower:]')
EXESPO  = $(addsuffix .o,$(LCEXES))
EXESOBJ = $(addprefix $(DOBJ),$(EXESPO))
MAKELIB = ar -rcs $(DEXE)libstringifor.a $(DOBJ)*.o ; ranlib $(DEXE)libstringifor.a

#auxiliary variables
COTEXT = "Compile $(<F)"
LITEXT = "Assemble $@"

firstrule: $(RULE)

#building rules
#the library
STRINGIFOR: $(MKDIRS) $(DOBJ)stringifor.o
	@echo $(LITEXT)
	@$(MAKELIB)

#tests
.NOTPARALLEL: $(DEXE)STRINGIFOR_TEST_CSV_NAIVE_PARSER  \
              $(DEXE)STRINGIFOR_TEST_PARSE_LARGE_CSV   \
              $(DEXE)STRINGIFOR-DOCTEST-1              \
              $(DEXE)STRINGIFOR-DOCTEST-2              \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-78    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-22    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-72    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-47    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-62    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-3     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-94    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-105   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-19    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-103   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-75    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-108   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-90    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-45    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-81    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-4     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-87    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-30    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-65    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-52    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-10    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-51    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-16    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-20    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-2     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-50    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-9     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-98    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-57    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-80    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-17    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-91    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-71    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-69    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-77    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-107   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-74    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-63    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-104   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-106   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-44    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-96    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-55    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-15    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-46    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-86    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-40    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-73    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-8     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-38    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-60    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-54    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-49    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-64    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-27    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-85    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-70    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-36    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-67    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-18    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-37    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-88    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-29    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-23    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-82    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-84    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-41    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-89    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-100   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-56    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-61    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-31    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-11    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-1     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-79    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-33    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-28    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-35    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-59    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-26    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-101   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-14    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-13    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-5     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-43    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-58    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-92    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-68    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-32    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-7     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-42    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-12    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-24    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-34    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-21    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-39    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-76    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-93    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-99    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-66    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-95    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-109   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-48    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-6     \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-25    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-102   \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-83    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-53    \
              $(DEXE)STRINGIFOR_STRING_T-DOCTEST-97

# tests
$(DEXE)STRINGIFOR_TEST_CSV_NAIVE_PARSER: $(MKDIRS) $(DOBJ)stringifor_test_csv_naive_parser.o
	@rm -f $(filter-out $(DOBJ)stringifor_test_csv_naive_parser.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_TEST_CSV_NAIVE_PARSER
$(DEXE)STRINGIFOR_TEST_PARSE_LARGE_CSV: $(MKDIRS) $(DOBJ)stringifor_test_parse_large_csv.o
	@rm -f $(filter-out $(DOBJ)stringifor_test_parse_large_csv.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_TEST_PARSE_LARGE_CSV
$(DEXE)STRINGIFOR-DOCTEST-1: $(MKDIRS) $(DOBJ)stringifor-doctest-1.o
	@rm -f $(filter-out $(DOBJ)stringifor-doctest-1.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR-DOCTEST-1
$(DEXE)STRINGIFOR-DOCTEST-2: $(MKDIRS) $(DOBJ)stringifor-doctest-2.o
	@rm -f $(filter-out $(DOBJ)stringifor-doctest-2.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR-DOCTEST-2
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-78: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-78.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-78.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-78
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-22: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-22.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-22.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-22
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-72: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-72.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-72.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-72
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-47: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-47.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-47.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-47
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-62: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-62.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-62.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-62
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-3: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-3.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-3.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-3
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-94: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-94.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-94.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-94
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-105: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-105.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-105.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-105
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-19: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-19.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-19.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-19
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-103: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-103.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-103.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-103
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-75: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-75.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-75.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-75
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-108: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-108.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-108.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-108
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-90: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-90.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-90.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-90
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-45: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-45.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-45.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-45
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-81: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-81.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-81.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-81
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-4: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-4.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-4.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-4
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-87: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-87.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-87.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-87
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-30: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-30.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-30.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-30
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-65: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-65.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-65.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-65
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-52: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-52.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-52.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-52
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-10: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-10.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-10.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-10
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-51: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-51.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-51.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-51
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-16: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-16.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-16.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-16
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-20: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-20.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-20.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-20
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-2: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-2.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-2.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-2
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-50: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-50.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-50.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-50
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-9: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-9.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-9.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-9
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-98: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-98.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-98.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-98
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-57: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-57.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-57.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-57
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-80: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-80.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-80.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-80
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-17: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-17.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-17.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-17
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-91: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-91.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-91.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-91
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-71: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-71.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-71.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-71
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-69: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-69.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-69.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-69
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-77: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-77.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-77.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-77
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-107: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-107.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-107.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-107
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-74: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-74.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-74.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-74
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-63: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-63.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-63.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-63
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-104: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-104.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-104.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-104
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-106: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-106.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-106.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-106
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-44: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-44.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-44.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-44
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-96: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-96.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-96.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-96
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-55: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-55.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-55.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-55
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-15: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-15.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-15.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-15
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-46: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-46.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-46.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-46
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-86: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-86.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-86.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-86
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-40: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-40.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-40.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-40
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-73: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-73.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-73.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-73
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-8: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-8.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-8.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-8
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-38: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-38.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-38.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-38
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-60: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-60.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-60.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-60
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-54: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-54.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-54.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-54
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-49: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-49.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-49.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-49
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-64: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-64.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-64.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-64
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-27: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-27.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-27.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-27
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-85: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-85.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-85.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-85
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-70: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-70.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-70.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-70
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-36: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-36.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-36.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-36
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-67: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-67.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-67.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-67
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-18: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-18.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-18.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-18
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-37: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-37.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-37.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-37
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-88: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-88.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-88.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-88
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-29: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-29.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-29.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-29
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-23: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-23.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-23.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-23
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-82: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-82.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-82.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-82
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-84: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-84.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-84.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-84
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-41: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-41.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-41.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-41
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-89: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-89.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-89.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-89
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-100: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-100.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-100.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-100
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-56: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-56.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-56.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-56
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-61: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-61.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-61.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-61
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-31: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-31.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-31.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-31
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-11: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-11.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-11.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-11
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-1: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-1.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-1.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-1
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-79: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-79.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-79.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-79
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-33: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-33.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-33.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-33
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-28: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-28.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-28.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-28
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-35: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-35.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-35.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-35
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-59: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-59.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-59.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-59
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-26: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-26.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-26.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-26
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-101: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-101.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-101.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-101
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-14: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-14.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-14.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-14
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-13: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-13.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-13.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-13
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-5: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-5.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-5.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-5
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-43: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-43.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-43.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-43
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-58: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-58.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-58.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-58
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-92: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-92.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-92.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-92
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-68: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-68.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-68.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-68
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-32: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-32.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-32.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-32
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-7: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-7.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-7.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-7
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-42: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-42.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-42.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-42
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-12: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-12.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-12.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-12
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-24: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-24.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-24.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-24
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-34: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-34.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-34.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-34
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-21: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-21.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-21.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-21
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-39: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-39.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-39.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-39
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-76: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-76.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-76.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-76
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-93: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-93.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-93.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-93
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-99: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-99.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-99.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-99
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-66: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-66.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-66.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-66
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-95: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-95.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-95.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-95
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-109: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-109.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-109.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-109
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-48: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-48.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-48.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-48
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-6: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-6.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-6.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-6
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-25: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-25.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-25.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-25
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-102: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-102.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-102.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-102
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-83: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-83.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-83.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-83
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-53: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-53.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-53.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-53
$(DEXE)STRINGIFOR_STRING_T-DOCTEST-97: $(MKDIRS) $(DOBJ)stringifor_string_t-doctest-97.o
	@rm -f $(filter-out $(DOBJ)stringifor_string_t-doctest-97.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRINGIFOR_STRING_T-DOCTEST-97
$(DEXE)FACE_TEST_COLORS: $(MKDIRS) $(DOBJ)face_test_colors.o
	@rm -f $(filter-out $(DOBJ)face_test_colors.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@

#compiling rules
$(DOBJ)stringifor.o: src/lib/stringifor.F90 \
	$(DOBJ)penf.o \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t.o: src/lib/stringifor_string_t.F90 \
	$(DOBJ)befor64.o \
	$(DOBJ)face.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)befor64_pack_data_m.o: src/third_party/BeFoR64/src/lib/befor64_pack_data_m.F90 \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)befor64.o: src/third_party/BeFoR64/src/lib/befor64.F90 \
	$(DOBJ)penf.o \
	$(DOBJ)befor64_pack_data_m.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)face.o: src/third_party/FACE/src/lib/face.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)penf.o: src/third_party/PENF/src/lib/penf.F90 \
	$(DOBJ)penf_global_parameters_variables.o \
	$(DOBJ)penf_b_size.o \
	$(DOBJ)penf_stringify.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)penf_b_size.o: src/third_party/PENF/src/lib/penf_b_size.F90 \
	$(DOBJ)penf_global_parameters_variables.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)penf_stringify.o: src/third_party/PENF/src/lib/penf_stringify.F90 \
	$(DOBJ)penf_b_size.o \
	$(DOBJ)penf_global_parameters_variables.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)penf_global_parameters_variables.o: src/third_party/PENF/src/lib/penf_global_parameters_variables.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

# tests
$(DOBJ)stringifor_test_csv_naive_parser.o: src/tests/stringifor/stringifor_test_csv_naive_parser.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_test_parse_large_csv.o: src/tests/stringifor/stringifor_test_parse_large_csv.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor-doctest-1.o: src/tests/stringifor/stringifor-doctest-1.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor-doctest-2.o: src/tests/stringifor/stringifor-doctest-2.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-78.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-78.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-22.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-22.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-72.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-72.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-47.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-47.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-62.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-62.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-3.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-3.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-94.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-94.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-105.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-105.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-19.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-19.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-103.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-103.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-75.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-75.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-108.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-108.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-90.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-90.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-45.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-45.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-81.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-81.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-4.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-4.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-87.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-87.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-30.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-30.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-65.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-65.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-52.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-52.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-10.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-10.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-51.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-51.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-16.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-16.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-20.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-20.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-2.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-2.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-50.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-50.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-9.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-9.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-98.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-98.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-57.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-57.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-80.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-80.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-17.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-17.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-91.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-91.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-71.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-71.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-69.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-69.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-77.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-77.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-107.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-107.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-74.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-74.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-63.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-63.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-104.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-104.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-106.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-106.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-44.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-44.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-96.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-96.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-55.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-55.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-15.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-15.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-46.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-46.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-86.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-86.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-40.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-40.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-73.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-73.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-8.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-8.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-38.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-38.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-60.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-60.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-54.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-54.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-49.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-49.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-64.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-64.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-27.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-27.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-85.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-85.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-70.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-70.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-36.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-36.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-67.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-67.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-18.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-18.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-37.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-37.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-88.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-88.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-29.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-29.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-23.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-23.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-82.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-82.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-84.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-84.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-41.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-41.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-89.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-89.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-100.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-100.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-56.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-56.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-61.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-61.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-31.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-31.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-11.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-11.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-1.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-1.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-79.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-79.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-33.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-33.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-28.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-28.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-35.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-35.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-59.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-59.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-26.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-26.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-101.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-101.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-14.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-14.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-13.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-13.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-5.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-5.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-43.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-43.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-58.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-58.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-92.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-92.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-68.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-68.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-32.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-32.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-7.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-7.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-42.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-42.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-12.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-12.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-24.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-24.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-34.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-34.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-21.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-21.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-39.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-39.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-76.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-76.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-93.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-93.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-99.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-99.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-66.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-66.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-95.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-95.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-109.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-109.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-48.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-48.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-6.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-6.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-25.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-25.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-102.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-102.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-83.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-83.f90 \
	$(DOBJ)stringifor_string_t.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-53.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-53.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t-doctest-97.o: src/tests/stringifor_string_t/stringifor_string_t-doctest-97.f90 \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

#phony auxiliary rules
.PHONY : $(MKDIRS)
$(MKDIRS):
	@mkdir -p $@
.PHONY : cleanobj
cleanobj:
	@echo deleting objects
	@rm -fr $(DOBJ)
.PHONY : cleanmod
cleanmod:
	@echo deleting mods
	@rm -fr $(DMOD)
.PHONY : cleanexe
cleanexe:
	@echo deleting exes
	@rm -f $(addprefix $(DEXE),$(EXES))
.PHONY : clean
clean: cleanobj cleanmod
.PHONY : cleanall
cleanall: clean cleanexe
