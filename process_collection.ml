module type PROCESS_COLLECTION = sig
  (*
     print_deck_from_collection: input_filename -> target_columns -> unit
       Given access to a local CSV of data from Manabox, prints columns
       in a format readable by the Manabox deck import tool.

     input_filename: a filepath/filename ending in .csv.
         Ex: collection.csv
     target_columns: a list of column names from the input CSV's header.
         Ex: [ "Name"; "Quantity" ]
  *)
  val print_deck_from_collection : string -> string list -> unit

  (*
       csv_deck_from_collection: input_filename -> target_columns -> output_filename -> unit
          Similar to print_deck_from_collection
          Generates a CSV at the output location with the fields specified in target_columns

        output_filename:  a filepath/filename ending in .csv.
            Ex: deck.csv 
    *)
  val csv_deck_from_collection : string -> string list -> string -> unit

  (*
     txt_deck_from_collection: input_filename -> target_columns -> output_filename -> unit
         Similar to csv_deck_from_collection

     output_filename: a filepath/filename ending in .txt
         Ex: deck.txt
  *)
  val txt_deck_from_collection : string -> string list -> string -> unit
end



(* Process_Collection: a helper module for turning Manabox 
   collection CSVs into data formats accepted by Manabox's 
   deck import tool *)
module Process_Collection : PROCESS_COLLECTION = struct
  type csv_row = string array

  type csv = csv_row array

  type output_format = Printed | CSV of string

  (* list_target_values: given a list of target indices and the row they're contained
      within, returns a list of the values mapping to those indices (in order) *)
  let rec list_target_values (row : csv_row) (targets : int list) : string list
      =
    match targets with
    | [] -> []
    | hd :: tl -> row.(hd) :: list_target_values row tl

  (* generate_output_csv: iterates through a CSV (string matrix), creating a new
     CSV with only the fields specified in the target_columns parameter. *)
  let generate_output_csv (out_filename : string) (csv : csv)
      (target_fields : int list) : unit =
    let csv_out_channel = Csv.to_channel (open_out out_filename) in
    (* append_row: extends the new CSV with a new row including only the fields
       specified by the client in the target_columns parameter. The first
       loop at index 0 creates the CSV header. *)
    let append_row (row : csv_row) : unit =
      Csv.output_record csv_out_channel (list_target_values row target_fields)
    in
    Array.iter append_row csv;
    Csv.close_out csv_out_channel

  (* list_to_spaced_string: given a list of strings, returns the list as a series
     of strings separated by spaces. This is how Manabox requires inputs to
     be formatted. *)
  let list_to_spaced_string (fields : string list) : string =
    let join_elements (acc : string) (str : string) : string =
      acc ^ " " ^ str
    in
    List.fold_left join_elements "" fields ^ "\n"

  (* generate_output_txt: generates a txt file with the values specified in the target_fields
     parameter (in order) with each CSV row saved as a space-separated series of values *)
  let generate_output_txt (out_filename : string) (csv : csv)
      (target_fields : int list) : unit =
    let out_channel = open_out out_filename in
    let append_row (row : csv_row) : unit =
      output_string out_channel
        (list_to_spaced_string (list_target_values row target_fields))
    in
    Array.iter append_row csv;
    close_out out_channel

  (* print_collection: iterates through the CSV printing only the values
     specified by the client in the target_columns parameter in a format
     recognized by ManaBox *)
  let print_collection (csv : csv) (targets : int list) : unit =
    (* print_target: prints the value at the row's target index *)
    let print_target (row : csv_row) (target : int) : unit =
      Printf.printf "%s " row.(target)
    in
    (* print_targets: prints the values stored in a list of target indices *)
    let print_targets (row : csv_row) : unit =
      List.iter (fun index -> print_target row index) targets;
      Printf.printf "\n"
    in
    Array.iter print_targets csv

  (* find_index_arr: returns the index of a value in an OCaml array. Raises Not_found if the
      value is not found
      I feel like this should be an Array library function but was unable to find one. This
      function should be replaced by the library function if one is found. *)
  let find_index_arr (arr : 'a array) (target : 'a) : int =
    let rec find_index_iterator (index : int) =
      if index >= Array.length arr then raise Not_found
      else if arr.(index) = target then index
      else find_index_iterator (index + 1)
    in
    find_index_iterator 0

  (* get_target_col_indices: given a list of column names, returns a list of their
     indices in the CSV header (preserving order) *)
  let rec get_header_col_indices (header : string array)
      (target_columns : string list) : int list =
    match target_columns with
    | [] -> []
    | hd :: tl -> find_index_arr header hd :: get_header_col_indices header tl

  (* load_csv: given a CSV filename, attempts to retrieve and parse it.
     Returns a Csv matrix if successful. May raise NotFound error if the CSV
     cannot be found or parsed. *)
  let load_csv (csv_filename : string) : csv =
    Csv.to_array (Csv.load csv_filename)

  let print_deck_from_collection (input_filename : string)
      (target_columns : string list) : unit =
    let input = load_csv input_filename in
    print_collection input (get_header_col_indices input.(0) target_columns)

  let csv_deck_from_collection (input_filename : string)
      (target_columns : string list) (output_filename : string) : unit =
    let input = load_csv input_filename in
    generate_output_csv output_filename input
      (get_header_col_indices input.(0) target_columns)

  let txt_deck_from_collection (input_filename : string)
      (target_columns : string list) (output_filename : string) : unit =
    let input = load_csv input_filename in
    generate_output_txt output_filename input
      (get_header_col_indices input.(0) target_columns)
end
