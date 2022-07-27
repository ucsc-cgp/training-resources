version 1.0

task echo_one_bam {
	input {
		File inputBam
		File refGenome
		String animal
	}
	command <<<
		echo ~{inputBam} > somefile.txt
		echo ~{refGenome} >> somefile.txt
		echo ~{animal}
	>>>

	output {
		String filenames = read_string("somefile.txt")
	}
}

task report {
	input {
		Array[String] foo
	}
	command <<<
		echo foo
	>>>
}

workflow simple_scatter {
	input {
		Array[File] inputBams
		File refGenome
		String? favoriteAnimal
	}

	# Figure out which animal to use, fall back to dogs if none specified
	String animal = select_first([favoriteAnimal, "dog"])

	scatter(oneBam in inputBams) {
		call echo_one_bam as scattered_echo_one_bam { 
			input:
				inputBam = oneBam,
				refGenome = refGenome,
				animal = animal
		}
	}

	call report {
		input:
			foo = scattered_echo_one_bam.filenames
	}
}