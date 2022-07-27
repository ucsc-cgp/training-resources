version 1.0

# This is a sample workflow that has been simplified to demonstrate
# the inner workings of WDL. If you are looking for an actually
# functional VCF to GDS converter, please see here:
# https://dockstore.org/workflows/github.com/DataBiosphere/analysis_pipeline_WDL/vcf-to-gds-wdl

workflow vcf2gds_with_optional_check {
	input {
		Array[File] vcf_files
		Boolean check_gds = false
	}

	scatter(vcf_file in vcf_files) {
		call vcf2gds {
			input:
				vcf = vcf_file
		}
	}

	if(check_gds) {
		scatter(gds in vcf2gds.gds_output) {
			call check_gds_files {
				input:
					gds = gds
			}
		}
	}

	output {
		Array[File] gdss = vcf2gds.gds_output
	}
}

task vcf2gds {
	input {
		File vcf
	}
	String basename = basename(vcf)

	command <<<
		# this is not actually how you create a gds file

		touch ~{basename}.gds
	>>>
	
	runtime {
		docker: "uwgac/topmed-master@sha256:0bb7f98d6b9182d4e4a6b82c98c04a244d766707875ddfd8a48005a9f5c5481e"
	}
	output {
		File gds_output = glob("*.gds")[0]
	}
}

task check_gds_files {
	input {
		File gds
	}

	command {
		echo "foo"
	}
}