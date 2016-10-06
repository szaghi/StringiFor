#!/usr/bin/make
MAKEFLAGS = -j 1

#main building variables
DSRC = src

COMPILER = gnu
ifeq "$(COMPILER)" "gnu"
  FC    = gfortran
  OPTSC = -c -frealloc-lhs -std=f2008 -fall-intrinsics -O2 -Dr16p -J $(DMOD)
  OPTSL = -O2 -J $(DMOD)
endif
ifeq "$(COMPILER)" "intel"
  FC    = ifort
  OPTSC = -c -assume realloc_lhs -standard-semantics -std08 -O2 -Dr16p -module $(DMOD)
  OPTSL = -O2 -module $(DMOD)
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
.NOTPARALLEL: $(DEXE)IS_REAL            \
              $(DEXE)SLEN               \
              $(DEXE)IS_NUMBER          \
              $(DEXE)FILL               \
              $(DEXE)WRITE_LINES        \
              $(DEXE)CONCATENATION      \
              $(DEXE)SEARCH             \
              $(DEXE)CAPITALIZE         \
              $(DEXE)SVERIFY            \
              $(DEXE)IS_INTEGER         \
              $(DEXE)STRIP              \
              $(DEXE)SREPEAT            \
              $(DEXE)SPLIT              \
              $(DEXE)SLICE              \
              $(DEXE)ESCAPE             \
              $(DEXE)SADJUSTLR          \
              $(DEXE)CSV_NAIVE_PARSER   \
              $(DEXE)TO_NUMBER          \
              $(DEXE)IS_DIGIT           \
              $(DEXE)IO_BASIC           \
              $(DEXE)SINDEX             \
              $(DEXE)WRITE_FILE         \
              $(DEXE)EQUAL              \
              $(DEXE)CAMELCASE          \
              $(DEXE)SNAKECASE          \
              $(DEXE)REVERSE            \
              $(DEXE)BASENAME_DIR       \
              $(DEXE)SCOUNT             \
              $(DEXE)READ_LINES         \
              $(DEXE)UPPER_LOWER        \
              $(DEXE)UNIQUE             \
              $(DEXE)JOIN               \
              $(DEXE)GREATER_EQUAL_THAN \
              $(DEXE)READ_FILE          \
              $(DEXE)EXTENSION          \
              $(DEXE)SWAPCASE           \
              $(DEXE)IO_LISTDIRECTED    \
              $(DEXE)UNESCAPE           \
              $(DEXE)STARTCASE          \
              $(DEXE)FREE               \
              $(DEXE)NOT_EQUAL          \
              $(DEXE)INSERT             \
              $(DEXE)PARTITION          \
              $(DEXE)STRIM              \
              $(DEXE)ASSIGNMENTS        \
              $(DEXE)GREATER_THAN       \
              $(DEXE)ENCODE             \
              $(DEXE)LOWER_THAN         \
              $(DEXE)SSCAN              \
              $(DEXE)DECODE             \
              $(DEXE)REPLACE            \
              $(DEXE)READ_LINE          \
              $(DEXE)LOWER_EQUAL_THAN   \
              $(DEXE)START_END

$(DEXE)IS_REAL: $(MKDIRS) $(DOBJ)is_real.o
	@rm -f $(filter-out $(DOBJ)is_real.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) IS_REAL
$(DEXE)SLEN: $(MKDIRS) $(DOBJ)slen.o
	@rm -f $(filter-out $(DOBJ)slen.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SLEN
$(DEXE)IS_NUMBER: $(MKDIRS) $(DOBJ)is_number.o
	@rm -f $(filter-out $(DOBJ)is_number.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) IS_NUMBER
$(DEXE)FILL: $(MKDIRS) $(DOBJ)fill.o
	@rm -f $(filter-out $(DOBJ)fill.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FILL
$(DEXE)WRITE_LINES: $(MKDIRS) $(DOBJ)write_lines.o
	@rm -f $(filter-out $(DOBJ)write_lines.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) WRITE_LINES
$(DEXE)CONCATENATION: $(MKDIRS) $(DOBJ)concatenation.o
	@rm -f $(filter-out $(DOBJ)concatenation.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) CONCATENATION
$(DEXE)SEARCH: $(MKDIRS) $(DOBJ)search.o
	@rm -f $(filter-out $(DOBJ)search.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SEARCH
$(DEXE)CAPITALIZE: $(MKDIRS) $(DOBJ)capitalize.o
	@rm -f $(filter-out $(DOBJ)capitalize.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) CAPITALIZE
$(DEXE)SVERIFY: $(MKDIRS) $(DOBJ)sverify.o
	@rm -f $(filter-out $(DOBJ)sverify.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SVERIFY
$(DEXE)IS_INTEGER: $(MKDIRS) $(DOBJ)is_integer.o
	@rm -f $(filter-out $(DOBJ)is_integer.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) IS_INTEGER
$(DEXE)STRIP: $(MKDIRS) $(DOBJ)strip.o
	@rm -f $(filter-out $(DOBJ)strip.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRIP
$(DEXE)SREPEAT: $(MKDIRS) $(DOBJ)srepeat.o
	@rm -f $(filter-out $(DOBJ)srepeat.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SREPEAT
$(DEXE)SPLIT: $(MKDIRS) $(DOBJ)split.o
	@rm -f $(filter-out $(DOBJ)split.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SPLIT
$(DEXE)SLICE: $(MKDIRS) $(DOBJ)slice.o
	@rm -f $(filter-out $(DOBJ)slice.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SLICE
$(DEXE)ESCAPE: $(MKDIRS) $(DOBJ)escape.o
	@rm -f $(filter-out $(DOBJ)escape.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) ESCAPE
$(DEXE)SADJUSTLR: $(MKDIRS) $(DOBJ)sadjustlr.o
	@rm -f $(filter-out $(DOBJ)sadjustlr.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SADJUSTLR
$(DEXE)CSV_NAIVE_PARSER: $(MKDIRS) $(DOBJ)csv_naive_parser.o
	@rm -f $(filter-out $(DOBJ)csv_naive_parser.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) CSV_NAIVE_PARSER
$(DEXE)TO_NUMBER: $(MKDIRS) $(DOBJ)to_number.o
	@rm -f $(filter-out $(DOBJ)to_number.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) TO_NUMBER
$(DEXE)IS_DIGIT: $(MKDIRS) $(DOBJ)is_digit.o
	@rm -f $(filter-out $(DOBJ)is_digit.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) IS_DIGIT
$(DEXE)IO_BASIC: $(MKDIRS) $(DOBJ)io_basic.o
	@rm -f $(filter-out $(DOBJ)io_basic.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) IO_BASIC
$(DEXE)SINDEX: $(MKDIRS) $(DOBJ)sindex.o
	@rm -f $(filter-out $(DOBJ)sindex.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SINDEX
$(DEXE)WRITE_FILE: $(MKDIRS) $(DOBJ)write_file.o
	@rm -f $(filter-out $(DOBJ)write_file.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) WRITE_FILE
$(DEXE)EQUAL: $(MKDIRS) $(DOBJ)equal.o
	@rm -f $(filter-out $(DOBJ)equal.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) EQUAL
$(DEXE)CAMELCASE: $(MKDIRS) $(DOBJ)camelcase.o
	@rm -f $(filter-out $(DOBJ)camelcase.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) CAMELCASE
$(DEXE)SNAKECASE: $(MKDIRS) $(DOBJ)snakecase.o
	@rm -f $(filter-out $(DOBJ)snakecase.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SNAKECASE
$(DEXE)REVERSE: $(MKDIRS) $(DOBJ)reverse.o
	@rm -f $(filter-out $(DOBJ)reverse.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) REVERSE
$(DEXE)BASENAME_DIR: $(MKDIRS) $(DOBJ)basename_dir.o
	@rm -f $(filter-out $(DOBJ)basename_dir.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) BASENAME_DIR
$(DEXE)SCOUNT: $(MKDIRS) $(DOBJ)scount.o
	@rm -f $(filter-out $(DOBJ)scount.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SCOUNT
$(DEXE)READ_LINES: $(MKDIRS) $(DOBJ)read_lines.o
	@rm -f $(filter-out $(DOBJ)read_lines.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) READ_LINES
$(DEXE)UPPER_LOWER: $(MKDIRS) $(DOBJ)upper_lower.o
	@rm -f $(filter-out $(DOBJ)upper_lower.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) UPPER_LOWER
$(DEXE)UNIQUE: $(MKDIRS) $(DOBJ)unique.o
	@rm -f $(filter-out $(DOBJ)unique.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) UNIQUE
$(DEXE)JOIN: $(MKDIRS) $(DOBJ)join.o
	@rm -f $(filter-out $(DOBJ)join.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) JOIN
$(DEXE)GREATER_EQUAL_THAN: $(MKDIRS) $(DOBJ)greater_equal_than.o
	@rm -f $(filter-out $(DOBJ)greater_equal_than.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) GREATER_EQUAL_THAN
$(DEXE)READ_FILE: $(MKDIRS) $(DOBJ)read_file.o
	@rm -f $(filter-out $(DOBJ)read_file.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) READ_FILE
$(DEXE)EXTENSION: $(MKDIRS) $(DOBJ)extension.o
	@rm -f $(filter-out $(DOBJ)extension.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) EXTENSION
$(DEXE)SWAPCASE: $(MKDIRS) $(DOBJ)swapcase.o
	@rm -f $(filter-out $(DOBJ)swapcase.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SWAPCASE
$(DEXE)IO_LISTDIRECTED: $(MKDIRS) $(DOBJ)io_listdirected.o
	@rm -f $(filter-out $(DOBJ)io_listdirected.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) IO_LISTDIRECTED
$(DEXE)UNESCAPE: $(MKDIRS) $(DOBJ)unescape.o
	@rm -f $(filter-out $(DOBJ)unescape.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) UNESCAPE
$(DEXE)STARTCASE: $(MKDIRS) $(DOBJ)startcase.o
	@rm -f $(filter-out $(DOBJ)startcase.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STARTCASE
$(DEXE)FREE: $(MKDIRS) $(DOBJ)free.o
	@rm -f $(filter-out $(DOBJ)free.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) FREE
$(DEXE)NOT_EQUAL: $(MKDIRS) $(DOBJ)not_equal.o
	@rm -f $(filter-out $(DOBJ)not_equal.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) NOT_EQUAL
$(DEXE)INSERT: $(MKDIRS) $(DOBJ)insert.o
	@rm -f $(filter-out $(DOBJ)insert.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) INSERT
$(DEXE)PARTITION: $(MKDIRS) $(DOBJ)partition.o
	@rm -f $(filter-out $(DOBJ)partition.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) PARTITION
$(DEXE)STRIM: $(MKDIRS) $(DOBJ)strim.o
	@rm -f $(filter-out $(DOBJ)strim.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) STRIM
$(DEXE)ASSIGNMENTS: $(MKDIRS) $(DOBJ)assignments.o
	@rm -f $(filter-out $(DOBJ)assignments.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) ASSIGNMENTS
$(DEXE)GREATER_THAN: $(MKDIRS) $(DOBJ)greater_than.o
	@rm -f $(filter-out $(DOBJ)greater_than.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) GREATER_THAN
$(DEXE)ENCODE: $(MKDIRS) $(DOBJ)encode.o
	@rm -f $(filter-out $(DOBJ)encode.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) ENCODE
$(DEXE)LOWER_THAN: $(MKDIRS) $(DOBJ)lower_than.o
	@rm -f $(filter-out $(DOBJ)lower_than.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) LOWER_THAN
$(DEXE)SSCAN: $(MKDIRS) $(DOBJ)sscan.o
	@rm -f $(filter-out $(DOBJ)sscan.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) SSCAN
$(DEXE)DECODE: $(MKDIRS) $(DOBJ)decode.o
	@rm -f $(filter-out $(DOBJ)decode.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) DECODE
$(DEXE)REPLACE: $(MKDIRS) $(DOBJ)replace.o
	@rm -f $(filter-out $(DOBJ)replace.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) REPLACE
$(DEXE)READ_LINE: $(MKDIRS) $(DOBJ)read_line.o
	@rm -f $(filter-out $(DOBJ)read_line.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) READ_LINE
$(DEXE)LOWER_EQUAL_THAN: $(MKDIRS) $(DOBJ)lower_equal_than.o
	@rm -f $(filter-out $(DOBJ)lower_equal_than.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) LOWER_EQUAL_THAN
$(DEXE)START_END: $(MKDIRS) $(DOBJ)start_end.o
	@rm -f $(filter-out $(DOBJ)start_end.o,$(EXESOBJ))
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)*.o $(LIBS) -o $@
EXES := $(EXES) START_END

#compiling rules
$(DOBJ)stringifor.o: src/lib/stringifor.F90 \
	$(DOBJ)penf.o \
	$(DOBJ)stringifor_string_t.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)stringifor_string_t.o: src/lib/stringifor_string_t.F90 \
	$(DOBJ)befor64.o \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)penf.o: src/third_party/BeFoR64/src/lib/penf.F90 \
	$(DOBJ)penf_global_parameters_variables.o \
	$(DOBJ)penf_b_size.o \
	$(DOBJ)penf_stringify.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@
	@rm -f $(DOBJ)penf_global_parameters_variables.o $(DOBJ)penf_b_size.o $(DOBJ)penf_stringify.o

$(DOBJ)befor64_pack_data_m.o: src/third_party/BeFoR64/src/lib/befor64_pack_data_m.F90 \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)befor64.o: src/third_party/BeFoR64/src/lib/befor64.F90 \
	$(DOBJ)penf.o \
	$(DOBJ)befor64_pack_data_m.o
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

$(DOBJ)is_real.o: src/tests/is_real.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)slen.o: src/tests/slen.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)is_number.o: src/tests/is_number.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)fill.o: src/tests/fill.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)write_lines.o: src/tests/write_lines.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)concatenation.o: src/tests/concatenation.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)search.o: src/tests/search.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)capitalize.o: src/tests/capitalize.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)sverify.o: src/tests/sverify.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)is_integer.o: src/tests/is_integer.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)strip.o: src/tests/strip.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)srepeat.o: src/tests/srepeat.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)split.o: src/tests/split.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)slice.o: src/tests/slice.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)escape.o: src/tests/escape.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)sadjustlr.o: src/tests/sadjustlr.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)csv_naive_parser.o: src/tests/csv_naive_parser.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)to_number.o: src/tests/to_number.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)is_digit.o: src/tests/is_digit.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)io_basic.o: src/tests/io_basic.F90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)sindex.o: src/tests/sindex.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)write_file.o: src/tests/write_file.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)equal.o: src/tests/equal.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)camelcase.o: src/tests/camelcase.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)snakecase.o: src/tests/snakecase.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)reverse.o: src/tests/reverse.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)basename_dir.o: src/tests/basename_dir.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)scount.o: src/tests/scount.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)read_lines.o: src/tests/read_lines.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)upper_lower.o: src/tests/upper_lower.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)unique.o: src/tests/unique.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)join.o: src/tests/join.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)greater_equal_than.o: src/tests/greater_equal_than.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)read_file.o: src/tests/read_file.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)extension.o: src/tests/extension.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)swapcase.o: src/tests/swapcase.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)io_listdirected.o: src/tests/io_listdirected.F90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)unescape.o: src/tests/unescape.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)startcase.o: src/tests/startcase.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)free.o: src/tests/free.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)not_equal.o: src/tests/not_equal.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)insert.o: src/tests/insert.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)partition.o: src/tests/partition.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)strim.o: src/tests/strim.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)assignments.o: src/tests/assignments.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)greater_than.o: src/tests/greater_than.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)encode.o: src/tests/encode.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)lower_than.o: src/tests/lower_than.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)sscan.o: src/tests/sscan.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)decode.o: src/tests/decode.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)replace.o: src/tests/replace.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)read_line.o: src/tests/read_line.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)lower_equal_than.o: src/tests/lower_equal_than.f90 \
	$(DOBJ)stringifor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)start_end.o: src/tests/start_end.f90 \
	$(DOBJ)stringifor.o
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
