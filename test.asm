.include "macro-string.asm"
.include "macro-syscalls.asm"

.eqv    NAME_SIZE 256		# Size for the file name
.eqv    TEXT_SIZE 2048		# Size for the text buffer

.data
.align 2
	prompt:        	.asciz "Input file path: "     # Prompt for file name input
	error_name:   	.asciz "Incorrect file name\n"
	error_read:   	.asciz "Incorrect read operation\n"
	
	input_name_1:		.asciz "input1.txt"		# Buffer for file name of input
	output_name_1:	.asciz "output1.txt"		# Buffer for file name of output
	substring1:	.asciz 	"ab"
	input_name_2:		.asciz "input2.txt"		# Buffer for file name of input
	output_name_2:	.asciz "output2.txt"		# Buffer for file name of output
	substring2:	.asciz 	"A"
	input_name_3:		.asciz "input3.txt"		# Buffer for file name of input
	output_name_3:	.asciz "output3.txt"		# Buffer for file name of output
	substring3:	.asciz 	"B"
	
	input:      		.space TEXT_SIZE		# Input buffer
	output:      	.space TEXT_SIZE		# Output buffer
	reversed:		.space TEXT_SIZE		# Buffer for reversed number (for converting it to string)
		               

.text
main:
    read_from_file(input, input_name_1)  		# Read data from the file
    
    process(input, output, substring1)					
    write_to_file(output, output_name_1)  		# Write the result to the file
    
    read_from_file(input, input_name_2)  		# Read data from the file
    process(input, output, substring2)					
    write_to_file(output, output_name_2)  		# Write the result to the file
    
    read_from_file(input, input_name_3)  		# Read data from the file
    process(input, output, substring3)			# Find index	
    write_to_file(output, output_name_3)  		# Write the result to the file
    
    exit
