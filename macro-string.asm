# Returns 1 if char is found in source, else 0
.macro find(%char, %source)
	la a0 %source		
	mv a1 %char

loop_iteration_by_source:
    	lb      t5 (a0)       		# Load the character in the source string
    	beqz   t5 not_found        	# If we reached the end of the string, terminate the loop
    	beq t5 a1 found			# If equals, we found our char
    	addi    a0 a0 1           	# Move further in the source string
    	j loop_iteration_by_source
    
found:
    	li a2 1
    	j end
not_found:
    	li a2 0
    	j end
end:	
.end_macro

# Gets the result
.macro process(%input, %output,%substring)
	la  t0 %input
	la  t2 %output
	la  t3 %substring	#Begin of substr
	li  s11 0
loop:
  	lb t5 (t0)
  	beqz t5, break
  	mv t1 t0
  	la t3 %substring
cont:
    	lb t4 (t1)
   	lb t6 (t3)
    
    	beqz t4, end_cont
    	bnez t6, not_add_index
    
    	sw   s11 (t2)
    	addi t2 t2 4
        
not_add_index:
    
    	bne t6, t4, end_cont
    
    	addi t1, t1, 1
    	addi t3, t3, 1
    	j cont
end_cont:
  	addi t0, t0, 1
  	addi s11, s11, 1
  	j loop
	
break:	
    	li      t0 0        		# Counter
    	la 	t3 %substring
    	li	s11 -1
    	sw	s11 (t2)
    	
end_process:
.end_macro

# Reading from file
.macro read_from_file(%result, %filename)
    la a0 %filename
    la a6 %result
    jal read_from_file
.end_macro

# Reading from file with inputing filename
.macro read_from_file_input(%result)
.eqv    NAME_SIZE 256     				# Size of the file name buffer
.data
    file_name:      .space  NAME_SIZE       	# Name of the file to read
.text
    input_with_message("Input path to file for reading: ", file_name, NAME_SIZE)
    la a0 file_name
    la a6 %result
    jal read_from_file
.end_macro

# Writing result to file
.macro write_to_file(%result, %file_name_out)
    la  a0 %file_name_out
    la  a2 %result
    jal write_to_file
.end_macro

# Writing result to file with inputing filename
.macro write_to_file_input(%result)
.eqv    NAME_SIZE 256     # Size of the file name buffer
.data
    file_name_out:      .space  NAME_SIZE    # Name of the file to read
.text
    input_with_message("Input path to file for writing: ", file_name_out, NAME_SIZE)
    la  a0 file_name_out
    la  a2 %result
    jal write_to_file
.end_macro
