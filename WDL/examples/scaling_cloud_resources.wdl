version 1.0

task aggregate_list {
	input {
		File some_big_file
		File some_other_file
		Int addl_disk = 1
	}

	Int big_size = ceil(size(some_big_file, "GB"))
	Int other_size = ceil(size(some_big_file, "GB"))
	Int final_disk_size = big_size + other_size + addl_disk

	command <<<
		echo "foo"
	>>>

	runtime {
		disks: "local-disk " + final_disk_size + " HDD"
	}
}

workflow scaling_cloud_resources {
	input {
		File some_big_file
		File some_other_file
	}

	call aggregate_list {
		input:
			some_big_file = some_big_file,
			some_other_file = some_other_file
	} 
}