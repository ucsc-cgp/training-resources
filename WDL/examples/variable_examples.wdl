version 1.0

task look_at_all_those_chickens {
    input {
        File chickens
    }
    
    Int disk_size = ceil(size(chickens))
    String base_chicken = basename(chickens, ".mp3")

    command <<<
        chickenscopy="~{base_chicken} duck sounds"
        echo ${chickenscopy} >> out.txt
    >>>

    runtime {
        disks: "local-disk " + disk_size + " HDD"
    }

    output {
        String out = read_string("out.txt")
    }
}

workflow variable_examples {
    input {
        File birds
    }

    call look_at_all_those_chickens {
        input:
            chickens = birds
    }
}