open Csv ;;
module Pc = Process_collection.Process_Collection ;;

let cIN_FILENAME = "collection.csv"
let cOUT_FILENAME = "deck.csv"
let cTARGET_COLUMNS: string list = [ "Quantity"; "Name" ]

type format = Printed | Csv of string

let process_csv (input_filename : string) (target_cols : string list) (output_format : format)  : unit =
  match output_format with 
  | Printed -> Pc.print_deck_from_collection input_filename target_cols 
  | Csv (output_filename) -> Pc.csv_deck_from_collection input_filename target_cols output_filename
;;

(* let () = process_csv cIN_FILENAME cTARGET_COLUMNS (Csv cOUT_FILENAME) *)
let () = process_csv cIN_FILENAME cTARGET_COLUMNS Printed 

