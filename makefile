BUILD = ocamlbuild -use-ocamlfind -package csv

all: coll_to_deck process_collection

coll_to_deck: coll_to_deck.ml 
	${BUILD} coll_to_deck.byte

process_collection: process_collection.ml 
	${BUILD} process_collection.byte