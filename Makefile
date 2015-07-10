OCAMLC          = ocamlc
OCAMLOPT        = ocamlopt
OCAMLMKLIB      = ocamlmklib
OCAMLFIND       = ocamlfind
FOLDERS_OPT     = -I $(SOURCES_FOLDER)
OCAMLC_FLAGS    = $(FOLDERS_OPT) -w @1..8 -w @10..26 -w @28..31 -w @39..49
OCAMLFIND_FLAGS = -package lwt,lwt.unix -linkpkg

LIB_FOLDER = lib
LIB_NAME   = OCamlEV3-bindings
LIB_DIST   = $(LIB_FOLDER)/$(LIB_NAME)

SOURCES_FOLDER = src
SOURCES=$(shell find src -name "*.ml")
SOURCES_MLI=$(SOURCES:.ml=.mli)
SOURCES_CMI=$(SOURCES:.ml=.cmi)
SOURCES_OBJ_BYT=$(SOURCES:.ml=.cmo)
SOURCES_OBJ_NAT=$(SOURCES:.ml=.cmx)

.PHONY: all
all: depend library


# Library compilation

COMPILATION_ORDER = src/core.cmx src/device.cmx src/led.cmx

library: depend $(SOURCES_OBJ_BYT) $(SOURCES_OBJ_NAT)
	@ mkdir -p $(LIB_FOLDER)
	$(OCAMLFIND) $(OCAMLMKLIB) $(FOLDERS_OPT) $(OCAMLFIND_FLAGS) \
		-o $(LIB_DIST) $(COMPILATION_ORDER) \
		&& echo "Library compiled." \
		|| echo "Error while compiling library."




# Opam

PACKAGE = OCamlEV3-bindings
INSTALL = META $(LIB_BYTECODE) $(LIB_NATIVE) $(SOURCES_ML) $(SOURCES_MLI) \
		  $(SOURCES_OBJ_BYT) $(SOURCES_OBJ_NAT) $(SOURCES_CMI)

install: $(LIB_BYTECODE) $(LIB_NATIVE)
	ocamlfind install $(PACKAGE) $(INSTALL)

.PHONY: uninstall
uninstall:
	ocamlfind remove $(PACKAGE)

.PHONY: reinstall
reinstall:
	$(MAKE) uninstall
	$(MAKE)
	$(MAKE) install


# Others

.PHONY: clean
clean:
	find . \( -name "*.cm*" -o -name "*.o" -o -name "*.a" \
		-o -name "*.ml.*" -o -name "dump_*" \) -delete
	rm -f $(LIB_BYTECODE) $(LIB_NATIVE)





.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(OCAMLFIND) $(OCAMLC) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.mli.cmi:
	$(OCAMLFIND) $(OCAMLC) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.ml.cmx:
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.PHONY: ocamlev3bindings-dep
depend:
	ocamldep $(FOLDERS_OPT) $(SOURCES_MLI) $(SOURCES) > .depend
include .depend
