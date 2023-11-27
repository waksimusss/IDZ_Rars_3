.include "macro-string.asm"
.include "macro-syscalls.asm"

.eqv    NAME_SIZE 256		# Size for the file name
.eqv    TEXT_SIZE 2048		# Size for the text buffer

.data
.align 2
	input_name:	.space NAME_SIZE		# Buffer for file name of input
	output_name:	.space NAME_SIZE		# Buffer for file name of output
	
	input:      	.space TEXT_SIZE		# Input buffer
	output:      	.space TEXT_SIZE		# Output buffer
	substring:	.space TEXT_SIZE		# Buffer for substring for find
	reversed:	.space TEXT_SIZE		# Buffer for reversed number (for converting it to string)

	yn_case: .word 1				# Value if user typed "Y"

	default_name:   .asciz "testout.txt"      	# Default file name
	prompt:        	.asciz "Input file path: "     # Prompt for file name input
	error_name:   	.asciz "Incorrect file name\n"
	error_read:   	.asciz "Incorrect read operation\n"

.text
main:
    YN_cases(yn_case) 			# User chooses if he wants to print result to the console
    newline   
    input_with_message("Write substring for find in input file: ", substring, TEXT_SIZE)
    newline	
    read_from_file_input(input)  		# Read data from the file
   
    process(input, output, substring)			# Calculate number of different symbols

    write_to_file_input(output)  		# Write the result to the file
    
    la t0 yn_case
    lw t1 (t0)
    bnez t1 display_result    		# If t1 = 1, display the result, skip otherwise
    
    j exit
    
display_result:
    print_result(output)		# Print the result to the console
    
exit: 
    exit
