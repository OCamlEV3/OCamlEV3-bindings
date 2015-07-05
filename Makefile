OCAMLC    = ocamlc
OCAMLOPT  = ocamlopt
OCAMLFIND = ocamlfind
FLAGS     = -I $(SOURCES_FOLDER) -I $(SOURCES_FOLDER)/motors \
			-I $(SOURCES_FOLDER)/sensors

LIB_FOLDER 		  = lib
LIB_NAME	 	  = OCamlEV3-bindings
LIB_BYTECODE      = $(LIB_FOLDER)/$(LIB_NAME).cma
LIB_NATIVE		  = $(LIB_BYTECODE:.cma=.cmxa)

SOURCES_FOLDER = src
SOURCES=$(shell find src -name "*.ml")
SOURCES_MLI=$(SOURCES:.ml=.mli)
SOURCES_CMI=$(SOURCES:.ml=.cmi)
SOURCES_OBJ_BYT=$(SOURCES:.ml=.cmo)
SOURCES_OBJ_NAT=$(SOURCES:.ml=.cmx)

.PHONY: all
all: $(LIB_BYTECODE) $(LIB_NATIVE)


# Library compilation

$(LIB_BYTECODE): $(SOURCES_OBJ_BYT)
	@ mkdir -p $(LIB_FOLDER)
	@ $(OCAMLFIND) $(OCAMLC) $(FLAGS) -a -o $@ $? \
		&& echo "Bytecode library compiled." \
		|| echo "Error while compile bytecode library."

$(LIB_NATIVE): $(SOURCES_OBJ_NAT)
	@ mkdir -p $(LIB_FOLDER)
	@ $(OCAMLFIND) $(OCAMLOPT) -I src/ $(FLAGS) -a -o $@ $? \
		&& echo "Native library compiled." \
		|| echo "Error while compile native library."

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
	$(OCAMLC) $(FLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(FLAGS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(FLAGS) -c $<

.PHONY: ocamlev3bindings-dep
depend:
	ocamldep $(FLAGS) $(SOURCES_MLI) $(SOURCES) > .depend
include .depend

