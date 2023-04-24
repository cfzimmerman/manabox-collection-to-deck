open Csv
module Pc = Process_collection.Process_Collection

let cIN_FILENAME = "input/collection.csv"

let cCSV_OUT_FILENAME = "output/deck.csv"

let cTXT_OUT_FILENAME = "output/deck.txt"

let cTARGET_COLUMNS : string list = [ "Quantity"; "Name" ]

(* output options that can be passed to process_csv *)
type format = Printed | Csv of string | Txt of string

(* process_csv: handles the desired operation using whichever method is specified *)
let process_csv (input_filename : string) (target_cols : string list)
    (output_format : format) : unit =
  match output_format with
  | Printed -> Pc.print_deck_from_collection input_filename target_cols
  | Csv output_filename ->
      Pc.csv_deck_from_collection input_filename target_cols output_filename
  | Txt output_filename ->
      Pc.txt_deck_from_collection input_filename target_cols output_filename

(* different ways to apply process_csv *)
let () = process_csv cIN_FILENAME cTARGET_COLUMNS (Csv cCSV_OUT_FILENAME)
(* let () = process_csv cIN_FILENAME cTARGET_COLUMNS Printed *)
(* let () = process_csv cIN_FILENAME cTARGET_COLUMNS (Txt cTXT_OUT_FILENAME) *)
