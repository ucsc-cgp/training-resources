version 1.0

# This is a sample workflow that has been simplified to demonstrate
# the inner workings of WDL. If you are looking for an actually
# functional LD pruning workflow, please see here:
# https://dockstore.org/workflows/github.com/DataBiosphere/analysis_pipeline_WDL/ld-pruning-wdl

workflow ldpruning_with_two_optional_steps {
	input {
		Array[File] gds_files
	}

	Int num_gds_files = length(gds_files)

	scatter(gds_file in gds_files) {
		call prune {
			input:
				gds_file = gds_file
		}
	}

	if (num_gds_files > 1) {
		call merge_gds {
			input:
				gdss = prune.pruned_output
		}
		
		scatter(pruned_gds in prune.pruned_output) {
			call check_merged_gds {
				input:
					gds_file = pruned_gds,
					merged_gds_file = merge_gds.merged_gds_output

			}
		}
	}
}

task prune {
	input {
		File gds_file
	}

	command <<<
		ln -s ~{gds_file}
	>>>
	
	output {
		File pruned_output = glob("*.gds")[0]
	}
}

task merge_gds {
	input {
		Array[File] gdss
	}

	command <<<
		BASH_FILES=(~{sep=" " gdss})
		for BASH_FILE in ${BASH_FILES[@]};
		do
			ln -s ${BASH_FILE} .
		done

		ls > merge.gds
	>>>
	
	output {
		File merged_gds_output = "merge.gds"
	}
}

task check_merged_gds {
	input {
		File gds_file
		File merged_gds_file
	}

	command <<<
		echo "foo"
	>>>
	
	output {
		File pruned_output = glob("*.gds")[0]
	}
}