# WDL Cheat Sheet
No explanations, just examples of stuff that can be hard to remember. Some examples might be for command sections, some might be for runtime attributes, some might be for other parts of WDL. All examples use WDL 1.0 syntax.


### if/else
The basic template is `if condition then value else othervalue`, not `value if condition else othervalue`
* `disk: if howBigShouldDiskSizeBe == "very big" then "local-disk 400000 SSD" else "local-disk 10 SSD"`
* `String? arg_unsorted_sam = if unsorted_sam == true then "--unsorted_sam" else ""`

### Reference an array in a command section
sep always goes before the name of the variable.
`~{sep=" " variable_name}`

This seems to be the most robust way to handle bash for loops:
```
GDS_FILES=(~{sep=" " input_gds_files})
for GDS_FILE in ${GDS_FILES[@]};
do
	cp ${GDS_FILE} .
done
```

### select_first
* `select_first([optional_variable, "foo"])`
* `Int optional_file_size = select_first([ceil(size(optional_file, "GB")), 0])`