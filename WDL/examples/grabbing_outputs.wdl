version 1.0

workflow grabbing_outputs {
	input {
		File gds_file
	}

	call consistent_output_filename {
		input:
			gds = gds_file
	}

	call output_matches_input_filename {
		input:
			gds = gds_file
	}

	call output_
}