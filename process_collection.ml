module type PROCESS_COLLECTION = 
  sig
    
  end

module type PC_INPUTS =
  sig
    type output_format
    val input_filename : string
    val output_filename : string 
    val target_columns : string list 
  end

module Process_Collection (Elt : PC_INPUTS) =
  struct
    
  end