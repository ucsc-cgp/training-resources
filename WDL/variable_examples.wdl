version 1.0

task look_at_all_those_chickens {
    input {
        String chickens
    }

    command <<<
        chickenscopy="~{chickens}"
        echo ${chickenscopy} >> out.txt
    >>>

    output {
        String out = read_string("out.txt")
    }
}

workflow variable_examples {
	input {
		String birds
	}

	call look_at_all_those_chickens {
		input:
			chickens = birds
	}
}