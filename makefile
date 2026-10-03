#!/usr/bin/make
MAKEFLAGS = -j 1

#main building variables
DSRC = src

COMPILER = gnu
ifeq "$(COMPILER)" "gnu"
  FC    = gfortran
  OPTSC = -c -frealloc-lhs -std=f2008 -fall-intrinsics -O2 -DPENF_R16P -J $(DMOD)
  OPTSL = -O2 -J $(DMOD)
endif
ifeq "$(COMPILER)" "intel"
  FC    = ifx
  OPTSC = -c -assume realloc_lhs -standard-semantics -std08 -O2 -DPENF_R16P -module $(DMOD)
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
  RULE = tests
else
  DOBJ = lib/obj/
  DMOD = lib/mod/
  DEXE = lib/
  RULE = STRINGIFOR
endif
LIBS    =
VPATH   = $(DSRC) $(DOBJ) $(DMOD)
MKDIRS  = $(DOBJ) $(DMOD) $(DEXE)
MAKELIB = ar -rcs $(DEXE)libstringifor.a $(DOBJ)*.o ; ranlib $(DEXE)libstringifor.a

#the objects of the library and of its dependencies
LIBOBJ = $(addprefix $(DOBJ),stringifor.o stringifor_string_t.o befor64.o befor64_pack_data_m.o face.o penf.o \
           penf_allocatable_memory.o penf_b_size.o penf_stringify.o penf_global_parameters_variables.o)

#the tests: every program found in a directory of src/tests, no list to maintain
TESTSRC  = $(wildcard src/tests/*/*.f90)
TESTDIRS = $(sort $(dir $(TESTSRC)))
EXES     = $(notdir $(basename $(TESTSRC)))
TESTEXES = $(addprefix $(DEXE),$(EXES))
TESTOBJ  = $(addprefix $(DOBJ),$(addsuffix .o,$(EXES)))

#auxiliary variables
COTEXT = "Compile $(<F)"
LITEXT = "Assemble $@"

firstrule: $(RULE)

#building rules
#the library
STRINGIFOR: $(MKDIRS) $(DOBJ)stringifor.o
	@echo $(LITEXT)
	@$(MAKELIB)

#the tests
.PHONY : tests
tests: $(MKDIRS) $(TESTEXES)

$(TESTEXES): $(DEXE)%: $(DOBJ)%.o $(LIBOBJ)
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $< $(LIBOBJ) $(LIBS) -o $@

define TESTRULE
$$(DOBJ)%.o: $(1)%.f90 $$(DOBJ)stringifor.o
	@echo $$(COTEXT)
	@$$(FC) $$(OPTSC)  $$< -o $$@
endef
$(foreach testdir,$(TESTDIRS),$(eval $(call TESTRULE,$(testdir))))
.SECONDARY: $(TESTOBJ)

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
	$(DOBJ)penf_stringify.o \
	$(DOBJ)penf_allocatable_memory.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC)  $< -o $@

$(DOBJ)penf_allocatable_memory.o: src/third_party/PENF/src/lib/penf_allocatable_memory.F90 \
	$(DOBJ)penf_global_parameters_variables.o \
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
