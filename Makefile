# make(1) build, an alternative to fpm.
#   make                  library, tests, examples and app
#   make test             run the tests
#   make FC=ifx FFLAGS=-O2
#   make install PREFIX=$HOME/.local
#   make generate         regenerate src/ and test/ from tmpl/ (needs fypp)
#   make check-generated  fail if src/ or test/ differ from the templates
#   make doc              HTML documentation in build/doc (needs ford)

ifeq ($(origin FC),default)
FC = gfortran
endif
FFLAGS ?= -O2
FYPP ?= fypp
PREFIX ?= /usr/local

B := build/make
LIB := $(B)/libfortran_quaternions.a
PROGS := $(B)/test_quaternions $(B)/demo_algebra $(B)/demo_rotations $(B)/slerp_demo
GENERATED := src/quaternions.F90 test/test_quaternions.F90

.PHONY: all test install generate check-generated doc clean

all: $(LIB) $(PROGS)

# Compiling inside $(B) puts the .mod files there for every compiler.
$(LIB): src/quaternions.F90
	mkdir -p $(B)
	cd $(B) && $(FC) $(FFLAGS) -c $(CURDIR)/$< -o quaternions.o
	ar rcs $@ $(B)/quaternions.o

LINK = $(FC) $(FFLAGS) -I$(B) $< $(LIB) -o $@
$(B)/test_quaternions: test/test_quaternions.F90 $(LIB)
	$(LINK)
$(B)/demo_%: example/demo_%.f90 $(LIB)
	$(LINK)
$(B)/slerp_demo: app/main.f90 $(LIB)
	$(LINK)

test: $(B)/test_quaternions
	$<

install: $(LIB)
	install -d $(PREFIX)/lib $(PREFIX)/include $(PREFIX)/share/man/man3
	install -m 644 $(LIB) $(PREFIX)/lib
	install -m 644 $(B)/*.mod $(PREFIX)/include
	install -m 644 man/quaternions.3 $(PREFIX)/share/man/man3

generate:
	$(FYPP) -I tmpl tmpl/quaternions.fypp src/quaternions.F90
	$(FYPP) -I tmpl tmpl/test_quaternions.fypp test/test_quaternions.F90

check-generated: generate
	git diff --exit-code -- $(GENERATED)

# The user manual page is llms.txt, so there is one reference to maintain.
doc:
	mkdir -p build/pages
	{ printf -- '---\ntitle: User manual\n---\n\n'; sed 1d llms.txt; } > build/pages/index.md
	ford ford.md
	cp llms.txt build/doc/

clean:
	rm -rf $(B)
