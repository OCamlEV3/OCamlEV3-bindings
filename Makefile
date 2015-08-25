OCAMLC          = ocamlc
OCAMLDOC	= ocamldoc
OCAMLOPT        = ocamlopt
OCAMLMKLIB      = ocamlmklib
OCAMLFIND       = ocamlfind
FOLDERS_OPT     = -I $(SOURCES_FOLDER) -I $(SOURCES_FOLDER)/sensors \
		-I $(SOURCES_FOLDER)/sensors/hiTechnic \
		-I $(SOURCES_FOLDER)/sensors/lego \
		-I $(SOURCES_FOLDER)/sensors/microinfinity \
		-I $(SOURCES_FOLDER)/sensors/mindsensors
OCAMLC_FLAGS    = $(FOLDERS_OPT) -w @1..8 -w @10..26 -w @28..31 -w @39..49 -annot
OCAMLFIND_FLAGS =

OCAMLDOC_FLAGS  = -html -d $(OCAMLDOC_FOLDER) -t OCamlEV3-bindings \
			-colorize-code -short-functors
OCAMLDOC_FOLDER = doc

LIB_FOLDER = lib
LIB_NAME   = OCamlEV3-bindings
LIB_DIST   = $(LIB_FOLDER)/$(LIB_NAME)
LIB_DIST_NATIVE = $(LIB_DIST).cmxa
LIB_DIST_BYTECODE = $(LIB_DIST).cma

SOURCES_FOLDER=src
TEST=IO path_finder
SOURCES=$(shell find $(SOURCES_FOLDER) -name "*.ml")
SOURCES_MLI=$(SOURCES:.ml=.mli)
SOURCES_CMI=$(SOURCES:.ml=.cmi)
SOURCES_OBJ_BYT=$(SOURCES:.ml=.cmo)
SOURCES_OBJ_NAT=$(SOURCES:.ml=.cmx)

.PHONY: all
all: depend $(LIB_DIST_NATIVE)


# Library compilation
include Makefile.order

# library: depend $(SOURCES_OBJ_BYT) $(SOURCES_OBJ_NAT)
# 	@ mkdir -p $(LIB_FOLDER)
# 	$(OCAMLFIND) $(OCAMLMKLIB) $(FOLDERS_OPT) $(OCAMLFIND_FLAGS) \
# 		-o $(LIB_DIST) $(COMPILATION_ORDER)

$(LIB_DIST_NATIVE): $(SOURCES_OBJ_NAT) $(SOURCES_OBJ_BYT)
	@ mkdir -p $(LIB_FOLDER)
	$(OCAMLFIND) $(OCAMLOPT) $(FOLDERS_OPT) $(OCAMLFIND_FLAGS) \
		-a -o $(LIB_DIST_NATIVE) $(COMPILATION_ORDER)

doc: library
	mkdir -p $(OCAMLDOC_FOLDER)
	$(OCAMLFIND) $(OCAMLDOC) $(OCAMLDOC_FLAGS) \
		$(FOLDERS_OPT) $(SOURCES_MLI)



# Opam

PACKAGE = OCamlEV3-bindings
INSTALL = META $(LIB_BYTECODE) $(LIB_NATIVE) $(SOURCES_ML) $(SOURCES_MLI) \
		  $(SOURCES_OBJ_BYT) $(SOURCES_OBJ_NAT) $(SOURCES_CMI) \
		  $(LIB_DIST).cmxa $(LIB_DIST).a

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
		-o -name "*.ml.*" -o -name "dump_*" -o -name "*.annot" \) \
		-delete
	rm -rf $(OCAMLDOC_FOLDER)





.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(OCAMLFIND) $(OCAMLC) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.mli.cmi:
	$(OCAMLFIND) $(OCAMLC) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.ml.cmx:
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLC_FLAGS) $(OCAMLFIND_FLAGS) -c $<

.PHONY: depend
depend:
	ocamldep $(FOLDERS_OPT) $(SOURCES_MLI) $(SOURCES) > .depend
-include .depend
