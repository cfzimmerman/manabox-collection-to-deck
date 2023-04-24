open Csv ;;

let in_FILENAME = "collection.csv"
let out_FILENAME = "deck.csv"


type csv_row = string array

type csv = csv_row array 

type output = Csv | Text

let find_index (arr : 'a array) (target : 'a) : int =
  let rec find_index_iterator (index : int) =
    if index >= Array.length arr then raise Not_found
    else if arr.(index) = target then index else find_index_iterator (index + 1)
  in
  find_index_iterator 0
;;

let target_columns: string list = [ "Name"; "Quantity" ]

let rec list_of_targets (row : csv_row) (targets : int list) : string list =
  match targets with 
  | [] -> []
  | hd :: tl -> row.(hd) :: (list_of_targets row tl)
;;

let generate_output_csv (csv : csv) (targets : int list) : unit =
  let out_channel = open_out out_FILENAME in 
  let csv_out = Csv.to_channel out_channel in 
  let append_row (row : csv_row) : unit =
    Csv.output_record csv_out (list_of_targets row targets)
  in
  Array.iter append_row csv;
  Csv.close_out csv_out
;;

let print_data (csv : csv) (targets : int list) : unit =
  let print_target (row : csv_row) (target : int) : unit =
    Printf.printf "%s " row.(target)
  in
  let print_targets (row : csv_row) : unit =
    List.iter (fun index -> print_target row index) targets;
    Printf.printf "\n"
  in
  Array.iter (fun row -> print_targets row) csv
;;

let rec get_target_indices (header : string array) (targets : string list) : int list =
  match targets with 
  | [] -> []
  | hd :: tl -> (find_index header hd) :: (get_target_indices header tl)
;;

let process_csv ?(output_format = Text) (filename : string) : unit =
  let input: csv = Csv.to_array (Csv.load "collection.csv") in 
  let targe_cols = (get_target_indices input.(0) target_columns) in
  if output_format = Text then 
    print_data input targe_cols
  else generate_output_csv input targe_cols
;;

let () = process_csv ~output_format:Csv in_FILENAME