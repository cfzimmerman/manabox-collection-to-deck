all: coll_to_deck

coll_to_deck: coll_to_deck.ml 
	ocamlbuild -use-ocamlfind -package csv coll_to_deck.byte

