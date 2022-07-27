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

	call only_know_output_extension {
		input:
			gds = gds_file
	}

	call A
}

task consistent_output_filename {
	input {
		File gds
	}

	command <<<
		touch my_cool_file.txt
	>>>

	output {
		File out = "my_cool_file.txt"
	}
}

task output_matches_input_filename {
	input {
		File gds
	}
	String gds_basename = basename(gds)

	command <<<
		touch ~{gds_basename}
	>>>

	output {
		File out = gds_basename
	}
}

task only_know_output_extension {
	input {
		File gds
	}

	command <<<
		touch $RANDOM.txt
	>>>

	output {
		File out = glob("*.txt")[0]
	}
}

# https://github.com/openwdl/wdl/issues/500
task A {
    input {
        Array[String] test = ["a","b","c","d"]
    }

    command {
       for foo in ~{sep=" " test}
       do 
           echo $foo
       done
    }
    output {
        Array[String] out = read_lines(stdout())
    }
}